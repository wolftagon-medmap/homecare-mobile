import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/data/models/assistant_block_model.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session_summary.dart';
import 'package:m2health/utils.dart';

abstract class AssistantRemoteDataSource {
  Future<String> startSession({bool fresh = false});
  Future<List<AssistantSessionSummary>> listSessions();
  Future<void> deleteSession(String sessionId);
  Future<List<AssistantBlock>> fetchHistory(String sessionId);
  Future<void> send({
    required String sessionId,
    String? text,
    String? replyId,
  });
  Stream<AssistantBlock> streamBlocks(
    String sessionId, {
    int? lastEventId,
    CancelToken? cancelToken,
  });
}

class AssistantRemoteDataSourceImpl implements AssistantRemoteDataSource {
  final Dio _dio;

  AssistantRemoteDataSourceImpl(this._dio);

  static const _base = '${Const.URL_API_V2}/intake';
  static const _sendTimeout = Duration(seconds: 60);

  Future<Map<String, String>> _authHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return {'Authorization': 'Bearer $token'};
  }

  @override
  Future<String> startSession({bool fresh = false}) async {
    final response = await _dio.post(
      '$_base/sessions',
      data: {if (fresh) 'fresh': true},
      options: Options(headers: await _authHeaders()),
    );
    final data = response.data as Map<String, dynamic>;
    return data['conversationId'] as String;
  }

  @override
  Future<List<AssistantSessionSummary>> listSessions() async {
    final response = await _dio.get(
      '$_base/sessions',
      options: Options(headers: await _authHeaders()),
    );
    final data = response.data as Map<String, dynamic>;
    return (data['sessions'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(_sessionFromJson)
        .toList();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _dio.delete(
      '$_base/sessions/$sessionId',
      options: Options(headers: await _authHeaders()),
    );
  }

  AssistantSessionSummary _sessionFromJson(Map<String, dynamic> json) =>
      AssistantSessionSummary(
        id: json['id'] as String? ?? '',
        active: json['active'] as bool? ?? false,
        preview: json['preview'] as String?,
        lastMessageAt: _parseDate(json['lastMessageAt']),
        createdAt: _parseDate(json['createdAt']),
      );

  static DateTime? _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;

  @override
  Future<List<AssistantBlock>> fetchHistory(String sessionId) async {
    final response = await _dio.get(
      '$_base/sessions/$sessionId/messages',
      options: Options(headers: await _authHeaders()),
    );
    final data = response.data as Map<String, dynamic>;
    return (data['blocks'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(assistantBlockFromJson)
        .toList();
  }

  @override
  Future<void> send({
    required String sessionId,
    String? text,
    String? replyId,
  }) async {
    await _dio.post(
      '$_base/messages',
      data: {
        'sessionId': sessionId,
        if (text != null) 'text': text,
        if (replyId != null) 'replyId': replyId,
      },
      options: Options(
        headers: await _authHeaders(),
        receiveTimeout: _sendTimeout,
      ),
    );
  }

  @override
  Stream<AssistantBlock> streamBlocks(
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
        if (dataBuffer.isNotEmpty) {
          final raw = dataBuffer.toString();
          dataBuffer.clear();
          final block = _tryParse(raw);
          if (block != null) yield block;
        }
        continue;
      }
      if (line.startsWith(':')) continue;
      if (line.startsWith('data:')) {
        dataBuffer.write(line.substring(5).trimLeft());
      }
    }
  }

  AssistantBlock? _tryParse(String raw) {
    try {
      return assistantBlockFromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
