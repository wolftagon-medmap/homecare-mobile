import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/intake_booking/data/models/block_dto.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/utils.dart';

/// Talks to `/v2/intake/*`. The client is deliberately thin: start a session,
/// load history, open the SSE stream, and post user actions (text / replyId /
/// location). All rendering meaning lives in the [Block]s the backend sends.
abstract class IntakeRemoteDataSource {
  Future<String> startSession();
  Future<List<Block>> fetchHistory(String sessionId);
  Future<void> send({
    required String sessionId,
    String? text,
    String? replyId,
    Map<String, dynamic>? location,
  });

  /// Live blocks over SSE. Replays anything after [lastEventId] (a block id).
  Stream<Block> streamBlocks(
    String sessionId, {
    int? lastEventId,
    CancelToken? cancelToken,
  });
}

class IntakeRemoteDataSourceImpl implements IntakeRemoteDataSource {
  final Dio _dio;

  IntakeRemoteDataSourceImpl(this._dio);

  static const _base = '${Const.URL_API_V2}/intake';

  Future<Map<String, String>> _authHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return {'Authorization': 'Bearer $token'};
  }

  @override
  Future<String> startSession() async {
    final response = await _dio.post(
      '$_base/sessions',
      options: Options(headers: await _authHeaders()),
    );
    final data = response.data as Map<String, dynamic>;
    return data['conversationId'] as String;
  }

  @override
  Future<List<Block>> fetchHistory(String sessionId) async {
    final response = await _dio.get(
      '$_base/sessions/$sessionId/messages',
      options: Options(headers: await _authHeaders()),
    );
    final data = response.data as Map<String, dynamic>;
    final blocks = (data['blocks'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(blockFromJson)
        .toList();
    return blocks;
  }

  @override
  Future<void> send({
    required String sessionId,
    String? text,
    String? replyId,
    Map<String, dynamic>? location,
  }) async {
    await _dio.post(
      '$_base/messages',
      data: {
        'sessionId': sessionId,
        if (text != null) 'text': text,
        if (replyId != null) 'replyId': replyId,
        if (location != null) 'location': location,
      },
      options: Options(headers: await _authHeaders()),
    );
  }

  @override
  Stream<Block> streamBlocks(
    String sessionId, {
    int? lastEventId,
    CancelToken? cancelToken,
  }) async* {
    final headers = await _authHeaders();
    final response = await _dio.get<ResponseBody>(
      '$_base/stream/$sessionId',
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          ...headers,
          'Accept': 'text/event-stream',
          if (lastEventId != null) 'Last-Event-ID': '$lastEventId',
        },
      ),
      cancelToken: cancelToken,
    );

    final lines = response.data!.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    final dataBuffer = StringBuffer();
    await for (final line in lines) {
      if (line.isEmpty) {
        // Blank line terminates an SSE event.
        if (dataBuffer.isNotEmpty) {
          final raw = dataBuffer.toString();
          dataBuffer.clear();
          final block = _tryParse(raw);
          if (block != null) yield block;
        }
        continue;
      }
      if (line.startsWith(':')) continue; // keep-alive ping
      if (line.startsWith('data:')) {
        dataBuffer.write(line.substring(5).trimLeft());
      }
      // `id:` / `event:` lines are ignored — each block carries its own id + kind.
    }
  }

  Block? _tryParse(String raw) {
    try {
      return blockFromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
