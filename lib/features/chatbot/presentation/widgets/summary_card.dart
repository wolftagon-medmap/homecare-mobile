import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class SummaryCard extends StatelessWidget {
  final SummaryBlock block;
  final Map<String, String> answers;
  final bool active;
  final String? chosenReplyId;
  final ValueChanged<String>? onSelect;

  const SummaryCard({
    super.key,
    required this.block,
    required this.answers,
    required this.active,
    required this.chosenReplyId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
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
              for (final row in block.rows)
                _SummaryRowView(
                  row: row,
                  value: _valueOf(row),
                ),
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
                  onPressed: active && onSelect != null
                      ? () => onSelect!(block.editReplyId)
                      : null,
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
                  onPressed: active && onSelect != null
                      ? () => onSelect!(block.confirmReplyId)
                      : null,
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

  String? _valueOf(SummaryRow row) {
    final key = row.fromStep;
    if (key != null && answers[key] != null) return answers[key];
    return row.value;
  }
}

class _SummaryRowView extends StatelessWidget {
  final SummaryRow row;
  final String? value;

  const _SummaryRowView({required this.row, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToneIcon(icon: row.icon, tone: 'teal', size: 30),
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
                  value!,
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
