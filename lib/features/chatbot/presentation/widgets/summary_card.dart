import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class SummaryCard extends StatelessWidget {
  final SummaryBlock block;
  final bool active;
  final void Function({required bool confirm})? onAnswer;

  const SummaryCard({
    super.key,
    required this.block,
    required this.active,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = active && onAnswer != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssistantCard(
          color: AssistantPalette.cardTint,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.title,
                style: const TextStyle(
                  color: AssistantPalette.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              for (final row in block.rows) _SummaryRowView(row: row),
            ],
          ),
        ),
        if (block.footnote != null) AssistantBubble(text: block.footnote!),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: enabled ? () => onAnswer!(confirm: false) : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AssistantPalette.primary,
                    side: const BorderSide(color: AssistantPalette.primary),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    block.editLabel,
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
                    disabledBackgroundColor: AssistantPalette.border,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    block.confirmLabel,
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

class _SummaryRowView extends StatelessWidget {
  final SummaryRow row;

  const _SummaryRowView({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToneIcon(
            icon: row.icon == 'issue' ? 'issue' : 'answer',
            tone: 'teal',
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: const TextStyle(
                    color: AssistantPalette.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  row.value,
                  style: const TextStyle(
                    color: AssistantPalette.navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
