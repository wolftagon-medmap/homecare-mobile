import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/chat_exception.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  final String service;

  String? _pendingRetryText;

  ChatCubit({required ChatRepository repository, required this.service})
      : _repository = repository,
        super(const ChatInitial());

  void startNewConversation() {
    _pendingRetryText = null;
    emit(const ChatLoaded());
  }

  /// Loads an existing conversation and its history.
  Future<void> loadConversation(int conversationId) async {
    _pendingRetryText = null;
    emit(const ChatLoading());
    try {
      final conversation = await _repository.getConversation(conversationId);
      emit(ChatLoaded(
        conversationId: conversation.id,
        messages: conversation.messages,
      ));
    } catch (e) {
      emit(ChatFatalError(_messageOf(e)));
    }
  }

  /// Sends a new user message: creates the conversation on the first send,
  /// appends to it afterwards.
  Future<void> sendText(String text) async {
    final trimmed = text.trim();
    final current = state;
    if (trimmed.isEmpty || current is! ChatLoaded || current.isSending) return;

    emit(current.copyWith(
      messages: [
        ...current.messages,
        Message(role: MessageRole.user, content: trimmed),
      ],
      isSending: true,
      clearSendError: true,
    ));

    await _dispatch(trimmed);
  }

  /// Resends the last failed message. The optimistic user bubble is already
  /// on screen, so this does not append it again.
  Future<void> retry() async {
    final text = _pendingRetryText;
    final current = state;
    if (text == null || current is! ChatLoaded || current.isSending) return;

    emit(current.copyWith(isSending: true, clearSendError: true));
    await _dispatch(text);
  }

  Future<void> _dispatch(String text) async {
    final current = state as ChatLoaded;
    try {
      if (current.conversationId == null) {
        final conversation = await _repository.createConversation(
            service: service, message: text);
        _pendingRetryText = null;
        emit(ChatLoaded(
          conversationId: conversation.id,
          messages: conversation.messages,
        ));
      } else {
        final result = await _repository.sendMessage(
          conversationId: current.conversationId!,
          message: text,
        );
        _pendingRetryText = null;
        emit(current.copyWith(
          messages: [...current.messages, result.assistantMessage],
          isSending: false,
        ));
      }
    } catch (e, stackTrace) {
      log('Failed to send message', name: 'ChatCubit', error: e, stackTrace: stackTrace);
      _pendingRetryText = text;
      final latest = state;
      if (latest is ChatLoaded) {
        emit(latest.copyWith(isSending: false, sendError: _messageOf(e)));
      }
    }
  }

  String _messageOf(Object error) {
    if (error is ChatException) return error.message;
    return 'Something went wrong. Please try again.';
  }
}
