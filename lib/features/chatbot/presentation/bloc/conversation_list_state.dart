import 'package:equatable/equatable.dart';
import 'package:m2health/features/chatbot/domain/entities/conversation.dart';

sealed class ConversationListState extends Equatable {
  const ConversationListState();

  @override
  List<Object?> get props => [];
}

class ConversationListLoading extends ConversationListState {
  const ConversationListLoading();
}

class ConversationListError extends ConversationListState {
  final String message;
  const ConversationListError(this.message);

  @override
  List<Object?> get props => [message];
}

class ConversationListLoaded extends ConversationListState {
  final List<ConversationSummary> conversations;

  const ConversationListLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}
