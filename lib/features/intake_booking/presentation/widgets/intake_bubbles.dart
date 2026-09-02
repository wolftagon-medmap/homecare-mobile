import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';

class UserBubble extends StatelessWidget {
  final String text;
  const UserBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return _Bubble(
      alignment: Alignment.centerRight,
      color: Const.aqua,
      textColor: Colors.white,
      text: text,
    );
  }
}

class AssistantBubble extends StatelessWidget {
  final String text;
  const AssistantBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return _Bubble(
      alignment: Alignment.centerLeft,
      color: const Color(0xFFF1F3F8),
      textColor: const Color(0xFF232F55),
      text: text,
      markdown: true,
    );
  }
}

class _Bubble extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final Color textColor;
  final String text;
  final bool markdown;

  const _Bubble({
    required this.alignment,
    required this.color,
    required this.textColor,
    required this.text,
    this.markdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(color: textColor, fontSize: 14, height: 1.35);
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: markdown
            ? MarkdownBody(
                data: text,
                shrinkWrap: true,
                styleSheet: MarkdownStyleSheet(
                  p: baseStyle,
                  strong: baseStyle.copyWith(fontWeight: FontWeight.bold),
                  em: baseStyle.copyWith(fontStyle: FontStyle.italic),
                  listBullet: baseStyle,
                  a: baseStyle.copyWith(
                      color: Const.aqua,
                      decoration: TextDecoration.underline),
                  h1: baseStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  h2: baseStyle.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  h3: baseStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.w600),
                  blockSpacing: 6,
                ),
              )
            : Text(text, style: baseStyle),
      ),
    );
  }
}

class NoticeBanner extends StatelessWidget {
  final String text;
  final NoticeKind kind;
  const NoticeBanner({super.key, required this.text, required this.kind});

  @override
  Widget build(BuildContext context) {
    final bg = switch (kind) {
      NoticeKind.safety => Colors.red.shade50,
      NoticeKind.handoff => const Color(0xFFFFF6E5),
      NoticeKind.info => const Color(0xFFF1F3F8),
    };
    final fg = switch (kind) {
      NoticeKind.safety => Colors.red.shade700,
      NoticeKind.handoff => const Color(0xFF8A6D00),
      NoticeKind.info => const Color(0xFF5A6485),
    };
    final icon = switch (kind) {
      NoticeKind.safety => Icons.warning_amber_rounded,
      NoticeKind.handoff => Icons.support_agent_rounded,
      NoticeKind.info => Icons.info_outline_rounded,
    };
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(color: fg, fontSize: 13, height: 1.35))),
        ],
      ),
    );
  }
}

class ThinkingIndicator extends StatelessWidget {
  const ThinkingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Const.aqua),
        ),
      ),
    );
  }
}
