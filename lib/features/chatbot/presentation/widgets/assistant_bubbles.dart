import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class AssistantAvatar extends StatelessWidget {
  final double size;

  const AssistantAvatar({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/ic_ai_robot.svg',
      width: size,
      height: size,
    );
  }
}

class AssistantBubble extends StatelessWidget {
  final String text;

  const AssistantBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AssistantAvatar(),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: const BoxDecoration(
                color: AssistantPalette.bubble,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: AssistantPalette.body,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssistantUserBubble extends StatelessWidget {
  final String text;

  const AssistantUserBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: const BoxDecoration(
            color: AssistantPalette.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Icon(
                Icons.done_all_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card body used by every interactive block, so the choice, summary, guidance
/// and next-step cards share one frame.
class AssistantCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const AssistantCard({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? AssistantPalette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AssistantPalette.border),
        ),
        child: child,
      ),
    );
  }
}
