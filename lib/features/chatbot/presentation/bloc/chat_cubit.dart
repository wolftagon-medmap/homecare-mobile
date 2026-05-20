import 'dart:async';
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

  Timer? _pollTimer;
  int _pollsLeft = 0;

  static const _pollInterval = Duration(seconds: 4);
  static const _maxPolls = 50;

  ChatCubit({required ChatRepository repository, required this.service})
      : _repository = repository,
        super(const ChatInitial());

  void startNewConversation() {
    _stopPolling();
    _pendingRetryText = null;
    emit(const ChatLoaded());
  }

  Future<void> loadConversation(int conversationId) async {
    _stopPolling();
    _pendingRetryText = null;
    emit(const ChatLoading());
    try {
      final conversation = await _repository.getConversation(conversationId);
      if (isClosed) return;
      final awaitingReply = _isAwaitingReply(conversation.messages);
      emit(ChatLoaded(
        conversationId: conversation.id,
        messages: conversation.messages,
        isSending: awaitingReply,
      ));
      if (awaitingReply) _startPolling(conversation.id);
    } catch (e) {
      emit(ChatFatalError(_messageOf(e)));
    }
  }

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

    await _dispatch(trimmed, current.conversationId);
  }

  /// Resends the last failed message. The optimistic user bubble is already
  /// on screen, so this does not append it again.
  Future<void> retry() async {
    final text = _pendingRetryText;
    final current = state;
    if (text == null || current is! ChatLoaded || current.isSending) return;

    emit(current.copyWith(isSending: true, clearSendError: true));
    await _dispatch(text, current.conversationId);
  }

  Future<void> _dispatch(String text, int? conversationId) async {
    try {
      if (conversationId == null) {
        final conversation = await _repository.createConversation(
            service: service, message: text);
        _pendingRetryText = null;
        final latest = state;
        if (latest is ChatLoaded && latest.conversationId == null) {
          emit(ChatLoaded(
            conversationId: conversation.id,
            messages: conversation.messages,
          ));
        }
      } else {
        final result = await _repository.sendMessage(
          conversationId: conversationId,
          message: text,
        );
        _pendingRetryText = null;
        final latest = state;
        if (latest is ChatLoaded && latest.conversationId == conversationId) {
          // A recovery poll may have already appended the reply.
          final alreadyPresent = latest.messages
              .any((m) => m.id != null && m.id == result.assistantMessage.id);
          _stopPolling();
          emit(latest.copyWith(
            messages: alreadyPresent
                ? latest.messages
                : [...latest.messages, result.assistantMessage],
            isSending: false,
          ));
        }
      }
    } catch (e, stackTrace) {
      log('Failed to send message',
          name: 'ChatCubit', error: e, stackTrace: stackTrace);
      _pendingRetryText = text;
      final latest = state;
      if (latest is ChatLoaded && latest.conversationId == conversationId) {
        _stopPolling();
        emit(latest.copyWith(isSending: false, sendError: _messageOf(e)));
      }
    }
  }

  // ===== Recovery polling =====

  bool _isAwaitingReply(List<Message> messages) {
    if (messages.isEmpty) return false;
    final last = messages.last;
    return last.isUser && last.isPending;
  }

  void _startPolling(int conversationId) {
    _pollTimer?.cancel();
    _pollsLeft = _maxPolls;
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll(conversationId));
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _poll(int conversationId) async {
    // Stop once the user is no longer viewing this conversation.
    final before = state;
    if (before is! ChatLoaded || before.conversationId != conversationId) {
      _stopPolling();
      return;
    }
    if (_pollsLeft-- <= 0) {
      _stopPolling();
      emit(before.copyWith(isSending: false));
      return;
    }

    try {
      final conversation = await _repository.getConversation(conversationId);
      if (isClosed) return;

      final after = state;
      if (after is! ChatLoaded || after.conversationId != conversationId) {
        _stopPolling();
        return;
      }
      if (!_isAwaitingReply(conversation.messages)) {
        _stopPolling();
        emit(ChatLoaded(
          conversationId: conversationId,
          messages: conversation.messages,
        ));
      }
    } catch (_) {
      // Transient failure - keep polling until the cap is reached.
    }
  }

  String _messageOf(Object error) {
    if (error is ChatException) return error.message;
    return 'Something went wrong. Please try again.';
  }

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}
