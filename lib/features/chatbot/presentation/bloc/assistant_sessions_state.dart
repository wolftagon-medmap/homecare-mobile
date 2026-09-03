import 'package:equatable/equatable.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';

sealed class AssistantSessionsState extends Equatable {
  const AssistantSessionsState();

  @override
  List<Object?> get props => [];
}

class AssistantSessionsLoading extends AssistantSessionsState {
  const AssistantSessionsLoading();
}

class AssistantSessionsFailed extends AssistantSessionsState {
  final String message;

  const AssistantSessionsFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class AssistantSessionsLoaded extends AssistantSessionsState {
  final List<AssistantSession> sessions;

  const AssistantSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}
