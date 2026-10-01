import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';

class AssistantTypingBubble extends StatefulWidget {
  const AssistantTypingBubble({super.key});

  @override
  State<AssistantTypingBubble> createState() => _AssistantTypingBubbleState();
}

class _AssistantTypingBubbleState extends State<AssistantTypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AssistantAvatar(),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: AssistantPalette.bubble,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 5),
                    _Dot(opacity: _opacityOf(i)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _opacityOf(int index) {
    final phase = (_controller.value - index * 0.2) % 1.0;
    return phase < 0.5 ? 0.35 + phase * 1.3 : 1.0 - (phase - 0.5) * 1.3;
  }
}

class _Dot extends StatelessWidget {
  final double opacity;

  const _Dot({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.35, 1.0),
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AssistantPalette.muted,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
