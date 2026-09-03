import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/entities/thread_event.dart';
import 'thread_stream.dart';

/// The ticket is one-shot — reading it on the server burns it — and expires in
/// 60s, so every reconnect must mint a fresh one. Caching it reconnects into a
/// rejection loop that looks exactly like a dead server.
class ThreadSocketClient implements ThreadStream {
  final Dio _dio;

  ThreadSocketClient(this._dio);

  static const Duration _keepAlive = Duration(seconds: 30);
  static const Duration _firstRetry = Duration(seconds: 1);
  static const Duration _maxRetry = Duration(seconds: 30);

  final StreamController<ThreadEvent> _events =
      StreamController<ThreadEvent>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _frames;
  Timer? _keepAliveTimer;
  Timer? _retryTimer;
  Duration _retryDelay = _firstRetry;
  bool _wanted = false;

  @override
  Stream<ThreadEvent> get events => _events.stream;

  @override
  Future<void> connect() async {
    _wanted = true;
    await _open();
  }

  @override
  Future<void> disconnect() async {
    _wanted = false;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _teardown();
  }

  Future<void> _open() async {
    if (_channel != null) return;

    final ticket = await _mintTicket();
    // No ticket means no session yet. Retrying is right: the user may still be
    // signing in.
    if (ticket == null) return _scheduleRetry();
    if (!_wanted) return;

    try {
      final channel = WebSocketChannel.connect(_streamUri(ticket));
      await channel.ready;
      if (!_wanted) {
        await channel.sink.close();
        return;
      }

      _channel = channel;
      _retryDelay = _firstRetry;
      _frames = channel.stream.listen(
        _onFrame,
        onDone: _onDropped,
        onError: (Object _) => _onDropped(),
        cancelOnError: true,
      );
      _keepAliveTimer = Timer.periodic(_keepAlive, (_) => _ping());
    } catch (e, stackTrace) {
      log('thread socket connect failed',
          name: 'messaging.socket', error: e, stackTrace: stackTrace);
      await _teardown();
      _scheduleRetry();
    }
  }

  Future<String?> _mintTicket() async {
    final token = await Utils.getSpString(Const.TOKEN);
    if (token == null || token.isEmpty) return null;

    try {
      final response = await _dio.post(
        '${Const.URL_API_V2}/threads/socket-ticket',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final ticket = response.data['ticket'];
      return ticket is String && ticket.isNotEmpty ? ticket : null;
    } catch (e) {
      log('thread socket ticket failed', name: 'messaging.socket', error: e);
      return null;
    }
  }

  static Uri _streamUri(String ticket) {
    final base = Uri.parse(Const.BASE_URL);
    return base.replace(
      scheme: base.scheme == 'https' ? 'wss' : 'ws',
      path: '/v2/threads/stream',
      queryParameters: {'ticket': ticket},
    );
  }

  void _onFrame(dynamic raw) {
    if (raw is! String) return;
    final event = ThreadEvent.parseFrame(raw);
    if (event != null) _events.add(event);
  }

  void _ping() {
    try {
      _channel?.sink.add(jsonEncode({'type': 'ping'}));
    } catch (_) {
      _onDropped();
    }
  }

  void _onDropped() {
    unawaited(_teardown());
    if (_wanted) _scheduleRetry();
  }

  void _scheduleRetry() {
    if (!_wanted || _retryTimer != null) return;
    _retryTimer = Timer(_retryDelay, () {
      _retryTimer = null;
      unawaited(_open());
    });
    final next = _retryDelay * 2;
    _retryDelay = next > _maxRetry ? _maxRetry : next;
  }

  Future<void> _teardown() async {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    await _frames?.cancel();
    _frames = null;
    await _channel?.sink.close();
    _channel = null;
  }
}
