import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class NextStepList extends StatelessWidget {
  final NextStepBlock block;
  final ValueChanged<NextStepAction>? onAct;

  const NextStepList({super.key, required this.block, required this.onAct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          for (final action in block.actions)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ActionRow(
                action: action,
                onTap: onAct == null ? null : () => onAct!(action),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final NextStepAction action;
  final VoidCallback? onTap;

  const _ActionRow({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AssistantPalette.cardTint,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              ToneIcon(
                icon: action.icon,
                tone: action.tone,
                size: 36,
                rounded: true,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: const TextStyle(
                        color: AssistantPalette.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      action.subtitle,
                      style: const TextStyle(
                        color: AssistantPalette.body,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
