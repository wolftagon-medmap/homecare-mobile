import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/choice_cards.dart';
import 'package:m2health/features/chatbot/presentation/widgets/guidance_card.dart';
import 'package:m2health/features/chatbot/presentation/widgets/next_step_list.dart';
import 'package:m2health/features/chatbot/presentation/widgets/summary_card.dart';
import 'package:m2health/features/chatbot/presentation/widgets/topic_grid.dart';

/// Renders one transcript block. A block is interactive only while it is the
/// last one and unanswered, which is what stops a question being answered twice
/// on a second pass through the script.
class AssistantBlockView extends StatelessWidget {
  final AssistantBlock block;
  final bool isLast;
  final String? chosenReplyId;
  final List<String> selection;
  final Map<String, String> answers;
  final ValueChanged<String>? onSelect;
  final ValueChanged<String>? onToggle;
  final VoidCallback? onSubmit;
  final ValueChanged<NextStepAction>? onAct;
  final ValueChanged<ServiceSuggestion>? onOpenSuggestion;

  const AssistantBlockView({
    super.key,
    required this.block,
    required this.isLast,
    required this.chosenReplyId,
    required this.selection,
    required this.answers,
    this.onSelect,
    this.onToggle,
    this.onSubmit,
    this.onAct,
    this.onOpenSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    final active = isLast && chosenReplyId == null;
    return switch (block) {
      AssistantTextBlock(:final text) => AssistantBubble(text: text),
      UserTextBlock(:final text) => AssistantUserBubble(text: text),
      TopicGridBlock b => TopicGrid(
          block: b,
          active: active,
          chosenReplyId: chosenReplyId,
          onSelect: onSelect,
        ),
      SingleChoiceBlock b => SingleChoiceCard(
          block: b,
          active: active,
          chosenReplyId: chosenReplyId,
          onSelect: onSelect,
        ),
      MultiChoiceBlock b => MultiChoiceCard(
          block: b,
          active: active,
          selected: selection,
          resolved: chosenReplyId != null,
          onToggle: onToggle,
          onSubmit: onSubmit,
        ),
      SummaryBlock b => SummaryCard(
          block: b,
          answers: answers,
          active: active,
          chosenReplyId: chosenReplyId,
          onSelect: onSelect,
        ),
      GuidanceBlock b => GuidanceCard(block: b, onOpen: onOpenSuggestion),
      NextStepBlock b => NextStepList(block: b, onAct: onAct),
      UnknownAssistantBlock() => const SizedBox.shrink(),
    };
  }
}
