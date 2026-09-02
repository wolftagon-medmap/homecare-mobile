import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class GuidanceCard extends StatelessWidget {
  final GuidanceBlock block;
  final ValueChanged<ServiceSuggestion>? onOpen;

  const GuidanceCard({super.key, required this.block, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return AssistantCard(
      color: AssistantPalette.cardTint,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.title,
                      style: const TextStyle(
                        color: AssistantPalette.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      block.body,
                      style: const TextStyle(
                        color: AssistantPalette.body,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.verified_user_outlined,
                color: AssistantPalette.primary,
                size: 22,
              ),
            ],
          ),
          if (block.suggestions.isNotEmpty) ...[
            const SizedBox(height: 16),
            if (block.suggestionsTitle != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  block.suggestionsTitle!,
                  style: const TextStyle(
                    color: AssistantPalette.body,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            for (final suggestion in block.suggestions)
              _SuggestionRow(
                suggestion: suggestion,
                onTap: onOpen == null ? null : () => onOpen!(suggestion),
              ),
          ],
        ],
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  final ServiceSuggestion suggestion;
  final VoidCallback? onTap;

  const _SuggestionRow({required this.suggestion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AssistantPalette.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AssistantPalette.border),
            ),
            child: Row(
              children: [
                ToneIcon(
                  icon: suggestion.icon,
                  tone: suggestion.tone,
                  size: 34,
                  rounded: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.title,
                        style: const TextStyle(
                          color: AssistantPalette.primary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        suggestion.subtitle,
                        style: const TextStyle(
                          color: AssistantPalette.body,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AssistantPalette.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
