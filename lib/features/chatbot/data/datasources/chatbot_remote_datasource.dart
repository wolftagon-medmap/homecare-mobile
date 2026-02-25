import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/data/models/chat_event_model.dart';
import 'package:m2health/features/chatbot/data/models/chat_session_model.dart';
import 'package:m2health/utils.dart';

abstract class ChatRemoteDataSource {
  /// Establishes SSE connection for new or existing session
  Stream<ChatEventModel> invokeSession({
    String? existingSessionId,
    bool stream = true,
  });

  /// Send user input and receive SSE stream response
  Stream<ChatEventModel> sendInput({
    required String nodeId,
    required String? messageId,
    required Map<String, dynamic> input,
  });

  /// Upload file and return URL
  Future<String> uploadFile(File file);

  /// Get active session history (for app restart/reconnect)
  Future<ChatSessionModel> getSessionHistory();

  /// Close session
  Future<void> closeSession(String sessionId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  @override
  Stream<ChatEventModel> invokeSession({
    String? existingSessionId,
    bool stream = true,
  }) async* {
    final requestBody = <String, dynamic>{
      'stream': stream,
      if (existingSessionId != null) 'session_id': existingSessionId,
    };

    final token = await Utils.getSpString(Const.TOKEN);
    final response = await _dio.post<ResponseBody>(
      '${Const.URL_API}/chatbot/invoke',
      data: requestBody,
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Accept': 'text/event-stream',
          'Authorization': 'Bearer $token'
        },
      ),
    );

    yield* _parseEventStream(response.data!.stream);
  }

  @override
  Stream<ChatEventModel> sendInput({
    required String nodeId,
    required String? messageId,
    required Map<String, dynamic> input,
  }) async* {
    final requestBody = {
      'message_id': messageId,
      'input': {nodeId: input},
      'stream': true,
    };

    final token = await Utils.getSpString(Const.TOKEN);
    final response = await _dio.post<ResponseBody>(
      '${Const.URL_API}/chatbot/invoke',
      data: requestBody,
      options: Options(
        responseType: ResponseType.stream,
        headers: {
          'Accept': 'text/event-stream',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    yield* _parseEventStream(response.data!.stream);
  }

  Stream<ChatEventModel> _parseEventStream(
      Stream<Uint8List> byteStream) async* {
    StreamTransformer<Uint8List, List<int>> unit8Transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );

    final transformedStream = byteStream
        .transform(unit8Transformer)
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in transformedStream) {
      if (line.startsWith('data: ')) {
        final jsonStr = line.substring(6).trim();
        if (jsonStr.isEmpty) continue; // Skip empty data lines
        try {
          final json = jsonDecode(jsonStr) as Map<String, dynamic>;
          yield ChatEventModel.fromJson(json);
        } catch (e, stackTrace) {
          log(
            'Failed to parse event: $jsonStr',
            name: 'ChatRemoteDataSourceImpl',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }
    }
  }

  @override
  Future<String> uploadFile(File file) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final token = await Utils.getSpString(Const.TOKEN);

    try {
      final response = await _dio.post(
        '${Const.URL_API}/chatbot/upload',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['url'] as String;
    } catch (e, stackTrace) {
      log('File upload failed',
          name: 'ChatRemoteDataSourceImpl', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<ChatSessionModel> getSessionHistory() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await _dio.get(
        '${Const.URL_API}/chatbot/session',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      log('Session history fetched successfully',
          name: 'ChatRemoteDataSourceImpl');

      return ChatSessionModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      log('Failed to get session history',
          name: 'ChatRemoteDataSourceImpl', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> closeSession(String sessionId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      await _dio.post(
        '${Const.URL_API}/chatbot/stop',
        data: {'session_id': sessionId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e, stackTrace) {
      log('Failed to close session',
          name: 'ChatRemoteDataSourceImpl', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
