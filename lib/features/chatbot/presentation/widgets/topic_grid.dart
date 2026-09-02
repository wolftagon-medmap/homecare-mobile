import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class TopicGrid extends StatelessWidget {
  final TopicGridBlock block;
  final bool active;
  final String? chosenReplyId;
  final ValueChanged<String>? onSelect;

  const TopicGrid({
    super.key,
    required this.block,
    required this.active,
    required this.chosenReplyId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            block.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AssistantPalette.navy,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final topic in block.topics)
                    SizedBox(
                      width: tileWidth,
                      child: _TopicTile(
                        topic: topic,
                        selected: chosenReplyId == topic.replyId,
                        onTap: active && onSelect != null
                            ? () => onSelect!(topic.replyId)
                            : null,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  final AssistantTopic topic;
  final bool selected;
  final VoidCallback? onTap;

  const _TopicTile({
    required this.topic,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AssistantPalette.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? AssistantPalette.primary : AssistantPalette.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              ToneIcon(icon: topic.icon, tone: topic.tone, size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  topic.label,
                  style: const TextStyle(
                    color: AssistantPalette.navy,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
