import 'package:equatable/equatable.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';

sealed class AssistantState extends Equatable {
  const AssistantState();

  @override
  List<Object?> get props => [];
}

class AssistantLoading extends AssistantState {
  const AssistantLoading();
}

enum AssistantError { load, send, noReply }

class AssistantFailed extends AssistantState {
  final AssistantError error;

  const AssistantFailed(this.error);

  @override
  List<Object?> get props => [error];
}

sealed class AssistantNavigation extends Equatable {
  const AssistantNavigation();

  @override
  List<Object?> get props => [];
}

class OpenGuidedBooking extends AssistantNavigation {
  final BookingPrefill booking;

  const OpenGuidedBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}

class OpenAllServices extends AssistantNavigation {
  const OpenAllServices();
}

class AssistantReady extends AssistantState {
  final String sessionId;
  final bool readOnly;
  final List<AssistantBlock> blocks;
  final Map<int, String> resolved;
  final Map<int, Set<int>> selections;
  final bool awaitingReply;
  final bool connected;
  final AssistantError? actionError;
  final AssistantNavigation? navigation;

  const AssistantReady({
    required this.sessionId,
    this.readOnly = false,
    this.blocks = const [],
    this.resolved = const {},
    this.selections = const {},
    this.awaitingReply = false,
    this.connected = false,
    this.actionError,
    this.navigation,
  });

  AssistantReady copyWith({
    List<AssistantBlock>? blocks,
    Map<int, String>? resolved,
    Map<int, Set<int>>? selections,
    bool? awaitingReply,
    bool? connected,
    AssistantError? actionError,
    bool clearActionError = false,
    AssistantNavigation? navigation,
    bool clearNavigation = false,
  }) {
    return AssistantReady(
      sessionId: sessionId,
      readOnly: readOnly,
      blocks: blocks ?? this.blocks,
      resolved: resolved ?? this.resolved,
      selections: selections ?? this.selections,
      awaitingReply: awaitingReply ?? this.awaitingReply,
      connected: connected ?? this.connected,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      navigation: clearNavigation ? null : (navigation ?? this.navigation),
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        readOnly,
        blocks,
        resolved,
        selections,
        awaitingReply,
        connected,
        actionError,
        navigation,
      ];
}
