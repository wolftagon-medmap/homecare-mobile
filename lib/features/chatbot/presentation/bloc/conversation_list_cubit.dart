import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/chat_exception.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/conversation_list_state.dart';

class ConversationListCubit extends Cubit<ConversationListState> {
  final ChatRepository _repository;
  final String service;

  ConversationListCubit(
      {required ChatRepository repository, required this.service})
      : _repository = repository,
        super(const ConversationListLoading());

  Future<void> load() async {
    emit(const ConversationListLoading());
    try {
      final conversations =
          await _repository.listConversations(service: service);
      emit(ConversationListLoaded(conversations));
    } catch (e) {
      emit(ConversationListError(_messageOf(e)));
    }
  }

  // Optimistically removes the conversation, restoring it if the request fails.
  Future<void> delete(int conversationId) async {
    final current = state;
    if (current is! ConversationListLoaded) return;

    final remaining =
        current.conversations.where((c) => c.id != conversationId).toList();
    emit(ConversationListLoaded(remaining));

    try {
      await _repository.deleteConversation(conversationId);
    } catch (e) {
      log('Failed to delete conversation: $e', name: 'ConversationListCubit');
      emit(current);
    }
  }

  String _messageOf(Object error) {
    if (error is ChatException) return error.message;
    return 'Failed to load conversations. Please try again.';
  }
}
