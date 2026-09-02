import 'package:equatable/equatable.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';

/// The whole guided conversation as a step graph.
///
/// Every non-terminal step declares [ScriptStep.fallbackNext], so an unmapped
/// reply still advances instead of dead-ending.
class AssistantScript extends Equatable {
  final String scriptId;
  final String entryStep;
  final String offTopicReply;
  final List<ScriptStep> steps;

  const AssistantScript({
    required this.scriptId,
    required this.entryStep,
    required this.offTopicReply,
    required this.steps,
  });

  ScriptStep? step(String id) {
    for (final step in steps) {
      if (step.id == id) return step;
    }
    return null;
  }

  ScriptStep get entry => step(entryStep) ?? steps.first;

  @override
  List<Object?> get props => [scriptId, entryStep, offTopicReply, steps];
}

class ScriptStep extends Equatable {
  final String id;
  final List<AssistantBlock> blocks;

  /// Records this step's answer under this key, for summary rows and for
  /// `{key}` placeholders in later copy. Null when the step asks nothing.
  final String? answerKey;

  /// Reply token to the step it leads to.
  final Map<String, String> transitions;

  final String? fallbackNext;

  /// Free text typed while this step is open advances here.
  final String? textNext;

  /// Appended instead, when [textNext] is null.
  final String? textReply;

  const ScriptStep({
    required this.id,
    required this.blocks,
    required this.answerKey,
    required this.transitions,
    required this.fallbackNext,
    required this.textNext,
    required this.textReply,
  });

  String? nextFor(String replyId) => transitions[replyId] ?? fallbackNext;

  bool get isTerminal => transitions.isEmpty && fallbackNext == null;

  @override
  List<Object?> get props =>
      [id, blocks, answerKey, transitions, fallbackNext, textNext, textReply];
}
