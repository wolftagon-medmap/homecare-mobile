import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/features/chatbot/presentation/widgets/choice_cards.dart';
import 'package:m2health/features/chatbot/presentation/widgets/confirm_request_card.dart';
import 'package:m2health/features/chatbot/presentation/widgets/guidance_card.dart';
import 'package:m2health/features/chatbot/presentation/widgets/next_step_list.dart';
import 'package:m2health/features/chatbot/presentation/widgets/summary_card.dart';
import 'package:m2health/features/chatbot/presentation/widgets/topic_grid.dart';
import 'package:m2health/i18n/translations.g.dart';

class AssistantBlockView extends StatelessWidget {
  final AssistantBlock block;
  final AssistantReady state;
  final AssistantCubit? cubit;
  final VoidCallback? onNewConversation;

  const AssistantBlockView({
    super.key,
    required this.block,
    required this.state,
    required this.cubit,
    this.onNewConversation,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = this.cubit;
    final active = cubit != null && AssistantCubit.isInteractive(state, block);
    final resolved = state.resolved[block.id];

    return switch (block) {
      AssistantTextBlock(:final text, :final fromTeam) =>
        fromTeam ? _TeamBubble(text: text) : AssistantBubble(text: text),
      UserTextBlock(:final text) => AssistantUserBubble(text: text),
      TopicGridBlock b => TopicGrid(
          block: b,
          active: active,
          chosenReplyId: resolved,
          onSelect:
              cubit == null ? null : (topic) => cubit.selectTopic(b.id, topic),
        ),
      QuestionBlock b when b.mode == QuestionMode.multi => MultiChoiceCard(
          block: b,
          active: active,
          selected: state.selections[b.id] ?? const <int>{},
          resolved: resolved != null,
          onToggle: cubit == null
              ? null
              : (index) => cubit.toggleOption(b.id, b, index),
          onSubmit: cubit == null ? null : () => cubit.submitSelection(b.id, b),
        ),
      QuestionBlock b => SingleChoiceCard(
          block: b,
          active: active,
          chosenValue: resolved,
          onSelect: cubit == null
              ? null
              : (index) => cubit.chooseOption(b.id, b, index),
        ),
      SummaryBlock b => SummaryCard(
          block: b,
          active: active,
          onAnswer: cubit == null
              ? null
              : ({required bool confirm}) =>
                  cubit.answerSummary(b.id, b, confirm: confirm),
        ),
      GuidanceBlock b => GuidanceCard(
          block: b,
          onOpen: state.readOnly ? null : cubit?.openSuggestion,
        ),
      NextStepBlock b => NextStepList(
          block: b,
          onAct: state.readOnly || cubit == null
              ? null
              : (action) => action.kind == NextStepKind.newConversation
                  ? onNewConversation?.call()
                  : cubit.act(action),
        ),
      ConfirmRequestBlock b => ConfirmRequestCard(
          block: b,
          active: active,
          chosenReplyId: resolved,
          onAnswer: cubit == null
              ? null
              : ({required bool confirm}) => cubit.answerConfirmRequest(
                    b.id,
                    b,
                    confirm: confirm,
                    label: confirm
                        ? context.t.chatbot.confirm
                        : context.t.chatbot.cancel,
                  ),
        ),
      UnknownAssistantBlock() => const SizedBox.shrink(),
    };
  }
}

class _TeamBubble extends StatelessWidget {
  final String text;

  const _TeamBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(56, 6, 16, 0),
          child: Text(
            context.t.chatbot.teamLabel,
            style: const TextStyle(
              color: AssistantPalette.muted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        AssistantBubble(text: text),
      ],
    );
  }
}
