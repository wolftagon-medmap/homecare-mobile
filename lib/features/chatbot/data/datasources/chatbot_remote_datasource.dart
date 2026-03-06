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
    required String service,
    String? existingSessionId,
    bool stream = true,
  });

  /// Send user input and receive SSE stream response
  Stream<ChatEventModel> sendInput({
    required String service,
    required String nodeId,
    required String? messageId,
    required Map<String, dynamic> input,
  });

  /// Upload file and return URL
  Future<String> uploadFile(File file);

  /// Get active session history (for app restart/reconnect)
  Future<ChatSessionModel> getSessionHistory({
    required String service,
  });

  /// Close session
  Future<void> closeSession({
    required String service,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;
  final int _maxRetries = 3;
  final Duration _retryDelay = const Duration(seconds: 2);

  ChatRemoteDataSourceImpl(this._dio);

  @override
  Stream<ChatEventModel> invokeSession({
    required String service,
    String? existingSessionId,
    bool stream = true,
  }) async* {
    yield* _retryableStream(() async {
      final requestBody = <String, dynamic>{
        'service': service,
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

      return response;
    });
  }

  @override
  Stream<ChatEventModel> sendInput({
    required String nodeId,
    required String? messageId,
    required Map<String, dynamic> input,
    required String service,
  }) async* {
    yield* _retryableStream(() async {
      final requestBody = {
        'service': service,
        'message_id': messageId,
        'input': {nodeId: input},
        'stream': true,
      };

      log("Sending input to API: $requestBody",
          name: 'ChatRemoteDataSourceImpl.sendInput');

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
      return response;
    });
  }

  /// Helper to wrap the POST request with retry logic for SSE streams
  Stream<ChatEventModel> _retryableStream(
    Future<Response<ResponseBody>> Function() request,
  ) async* {
    int attempts = 0;

    while (attempts < _maxRetries) {
      try {
        attempts++;
        final response = await request();
        yield* _parseEventStream(response.data!.stream);
        break; // Successfully finished the stream
      } on DioException catch (e, stackTrace) {
        final isTimeout = e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.response?.statusCode == 504 ||
            e.response?.statusCode == 503;

        if (isTimeout && attempts < _maxRetries) {
          log('Connection timeout (attempt $attempts). Retrying in ${_retryDelay.inSeconds}s...',
              name: 'ChatRemoteDataSourceImpl');
          await Future.delayed(_retryDelay);
          continue;
        }

        if (e.response != null) {
          log('Request failed: status_code=${e.response?.statusCode}, message=${e.response?.data} (attempt $attempts)',
              name: 'ChatRemoteDataSourceImpl',
              error: e,
              stackTrace: stackTrace);
        } else {
          log('Request failed (attempt $attempts)',
              name: 'ChatRemoteDataSourceImpl',
              error: e,
              stackTrace: stackTrace);
        }
        rethrow;
      }
    }
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
  Future<ChatSessionModel> getSessionHistory({
    required String service,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await _dio.get(
        '${Const.URL_API}/chatbot/session',
        queryParameters: {'service': service},
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
  Future<void> closeSession({required String service}) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      await _dio.post(
        '${Const.URL_API}/chatbot/stop',
        data: {'service': service},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e, stackTrace) {
      log('Failed to close session',
          name: 'ChatRemoteDataSourceImpl', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
