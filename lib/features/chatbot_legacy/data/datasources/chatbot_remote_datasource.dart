import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> listConversations({
    required String service,
    int page = 1,
  });

  Future<Map<String, dynamic>> getConversation(int conversationId);

  Future<Map<String, dynamic>> createConversation({
    required String service,
    required String message,
  });

  Future<Map<String, dynamic>> sendMessage({
    required int conversationId,
    required String message,
  });

  Future<void> deleteConversation(int conversationId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  static const _base = '${Const.URL_API}/chatbot/conversations';

  // Backend retry is included
  static const _aiTurnTimeout = Duration(seconds: 150);

  Future<Options> _authOptions({Duration? receiveTimeout}) async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(
      headers: {'Authorization': 'Bearer $token'},
      receiveTimeout: receiveTimeout,
    );
  }

  @override
  Future<Map<String, dynamic>> listConversations({
    required String service,
    int page = 1,
  }) async {
    final response = await _dio.get(
      _base,
      queryParameters: {'service': service, 'page': page},
      options: await _authOptions(),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getConversation(int conversationId) async {
    final response = await _dio.get(
      '$_base/$conversationId',
      options: await _authOptions(),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createConversation({
    required String service,
    required String message,
  }) async {
    final response = await _dio.post(
      _base,
      data: {'service': service, 'message': message},
      options: await _authOptions(receiveTimeout: _aiTurnTimeout),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    final response = await _dio.post(
      '$_base/$conversationId/messages',
      data: {'message': message},
      options: await _authOptions(receiveTimeout: _aiTurnTimeout),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteConversation(int conversationId) async {
    await _dio.delete(
      '$_base/$conversationId',
      options: await _authOptions(),
    );
  }
}
