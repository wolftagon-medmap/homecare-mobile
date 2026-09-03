import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:m2health/core/messaging/thread_index_cubit.dart';

import '../../data/datasources/thread_stream.dart';
import '../../domain/entities/thread_event.dart';

class ThreadActivityHub with WidgetsBindingObserver {
  final ThreadStream _stream;
  final ThreadIndexCubit _index;

  ThreadActivityHub(this._stream, this._index);

  static const Duration indexDebounce = Duration(milliseconds: 1500);

  final StreamController<ThreadEvent> _events =
      StreamController<ThreadEvent>.broadcast();

  Stream<ThreadEvent> get events => _events.stream;

  StreamSubscription<ThreadEvent>? _subscription;
  Timer? _debounce;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _subscription = _stream.events.listen((event) {
      if (!_events.isClosed) _events.add(event);
      _refreshIndexSoon();
    });
    await _stream.connect();
  }

  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _debounce = null;
    await _subscription?.cancel();
    _subscription = null;
    await _stream.disconnect();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_started) return;
    if (state == AppLifecycleState.resumed) {
      unawaited(_stream.connect());
      unawaited(_index.refresh());
    } else if (state == AppLifecycleState.paused) {
      unawaited(_stream.disconnect());
    }
  }

  void _refreshIndexSoon() {
    _debounce?.cancel();
    _debounce = Timer(indexDebounce, () => unawaited(_index.refresh()));
  }
}
