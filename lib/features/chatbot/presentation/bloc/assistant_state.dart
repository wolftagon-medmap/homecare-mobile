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

class AssistantFailed extends AssistantState {
  final String message;

  const AssistantFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class AssistantReady extends AssistantState {
  final List<AssistantBlock> blocks;

  /// Block id to the reply token already chosen on it. A resolved block renders
  /// read-only, which is what stops a question being answered twice.
  final Map<int, String> resolved;

  /// In-progress multi-choice ticks, by block id.
  final Map<int, List<String>> selections;

  /// Answer key to the phrase it contributed, for summary rows.
  final Map<String, String> answers;

  /// One-shot navigation request. `copyWith` drops it unless it is passed
  /// again, so the page cannot push the same route twice.
  final String? pendingRoute;

  const AssistantReady({
    required this.blocks,
    required this.resolved,
    required this.selections,
    required this.answers,
    this.pendingRoute,
  });

  bool get isEmpty => blocks.isEmpty;

  AssistantReady copyWith({
    List<AssistantBlock>? blocks,
    Map<int, String>? resolved,
    Map<int, List<String>>? selections,
    Map<String, String>? answers,
    String? pendingRoute,
  }) {
    return AssistantReady(
      blocks: blocks ?? this.blocks,
      resolved: resolved ?? this.resolved,
      selections: selections ?? this.selections,
      answers: answers ?? this.answers,
      pendingRoute: pendingRoute,
    );
  }

  @override
  List<Object?> get props =>
      [blocks, resolved, selections, answers, pendingRoute];
}
