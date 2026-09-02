import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:m2health/features/chatbot/data/models/conversation_model.dart';
import 'package:m2health/features/chatbot/domain/chat_exception.dart';
import 'package:m2health/features/chatbot/domain/entities/conversation.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ConversationSummary>> listConversations({
    required String service,
    int page = 1,
  }) async {
    return _guard(() async {
      final json = await _remoteDataSource.listConversations(
        service: service,
        page: page,
      );
      final data = (json['data'] as List<dynamic>? ?? []);
      return data
          .map((e) => ChatbotModels.summaryFromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Conversation> getConversation(int conversationId) async {
    return _guard(() async {
      final json = await _remoteDataSource.getConversation(conversationId);
      return ChatbotModels.conversationFromJson(
        json['data'] as Map<String, dynamic>,
      );
    });
  }

  @override
  Future<Conversation> createConversation({
    required String service,
    required String message,
  }) async {
    return _guard(() async {
      final json = await _remoteDataSource.createConversation(
        service: service,
        message: message,
      );
      return _conversationWithTurn(json);
    });
  }

  @override
  Future<SendResult> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    return _guard(() async {
      final json = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        message: message,
      );
      return (
        userMessage: ChatbotModels.messageFromJson(
            json['userMessage'] as Map<String, dynamic>),
        assistantMessage: ChatbotModels.messageFromJson(
            json['assistantMessage'] as Map<String, dynamic>),
      );
    });
  }

  @override
  Future<void> deleteConversation(int conversationId) async {
    return _guard(() => _remoteDataSource.deleteConversation(conversationId));
  }

  Conversation _conversationWithTurn(Map<String, dynamic> json) {
    final userMessage = ChatbotModels.messageFromJson(
        json['userMessage'] as Map<String, dynamic>);
    final assistantMessage = ChatbotModels.messageFromJson(
        json['assistantMessage'] as Map<String, dynamic>);
    return ChatbotModels.conversationFromJson(
      json['conversation'] as Map<String, dynamic>,
      messages: [userMessage, assistantMessage],
    );
  }

  /// Runs [action], translating transport errors into a [ChatException].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e, stackTrace) {
      log('Chat request failed',
          name: 'ChatRepositoryImpl', error: e, stackTrace: stackTrace);
      throw _mapDioException(e);
    }
  }

  ChatException _mapDioException(DioException e) {
    final status = e.response?.statusCode;

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        status == 504) {
      return const ChatException(
        'The medical AI is taking too long to respond. Please try again.',
        retryable: true,
      );
    }

    if (status == 404) {
      return const ChatException('Conversation not found.', retryable: false);
    }

    if (status != null && status >= 400 && status < 500 && status != 429) {
      final message =
          _serverMessage(e) ?? 'Your request could not be processed.';
      return ChatException(message, retryable: false);
    }

    // 5xx, 429, connection errors -> retryable.
    return ChatException(
      _serverMessage(e) ?? 'Could not reach the AI service. Please try again.',
      retryable: true,
    );
  }

  String? _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}
