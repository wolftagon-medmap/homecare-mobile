import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

class ConfirmRequestCard extends StatelessWidget {
  final ConfirmRequestBlock block;
  final bool active;
  final String? chosenReplyId;
  final void Function({required bool confirm})? onAnswer;

  const ConfirmRequestCard({
    super.key,
    required this.block,
    required this.active,
    required this.chosenReplyId,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    final enabled = active && onAnswer != null && chosenReplyId == null;
    final confirmed = chosenReplyId == block.confirmId;
    final cancelled = chosenReplyId == block.cancelId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssistantBubble(text: block.text),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: enabled ? () => onAnswer!(confirm: false) : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AssistantPalette.primary,
                    backgroundColor: cancelled
                        ? AssistantPalette.primary.withValues(alpha: 0.1)
                        : null,
                    side: BorderSide(
                      color: cancelled
                          ? AssistantPalette.primary
                          : AssistantPalette.border,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    t.cancel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: enabled ? () => onAnswer!(confirm: true) : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AssistantPalette.primary,
                    disabledBackgroundColor: confirmed
                        ? AssistantPalette.primary
                        : AssistantPalette.border,
                    disabledForegroundColor:
                        confirmed ? Colors.white : AssistantPalette.muted,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    t.confirm,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
