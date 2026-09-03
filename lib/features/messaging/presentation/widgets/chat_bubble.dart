import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/i18n/translations.g.dart';

import '../../domain/entities/chat_message.dart';

/// A human-to-human message. Deliberately not the assistant's bubble: this is a
/// person, and it should not look like the AI.
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final String? authorName;
  final bool showAuthor;

  /// Marks the last message the other side has reached. Only ever set on one
  /// bubble in the thread — the cursor is per-thread, not per-message.
  final bool read;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.authorName,
    this.showAuthor = false,
    this.read = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.78),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? Const.aqua : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          border: isMine ? null : Border.all(color: Const.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (showAuthor && !isMine && authorName != null) ...[
              Text(
                authorName!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Const.aqua,
                ),
              ),
              const SizedBox(height: 3),
            ],
            Text(
              message.body ?? '',
              style: ProText.body.copyWith(
                height: 1.35,
                color: isMine ? Colors.white : Const.primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _clock(message.createdAt.toLocal()),
                  style: TextStyle(
                    fontSize: 11,
                    color: isMine ? Colors.white70 : Const.chatMutedColor,
                  ),
                ),
                if (read) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.done_all_rounded,
                    size: 13,
                    color: isMine ? Colors.white70 : Const.chatMutedColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    context.t.messaging.chat.read,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isMine ? Colors.white70 : Const.chatMutedColor,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _clock(DateTime at) =>
      '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';
}

/// A system line — no author, centred, quiet. Used to narrate a record change,
/// never to say something a person said.
class ChatSystemLine extends StatelessWidget {
  final String text;

  const ChatSystemLine({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Const.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: ProText.hint.copyWith(height: 1.3),
        ),
      ),
    );
  }
}

/// Day separator between message groups.
class ChatDayDivider extends StatelessWidget {
  final DateTime day;

  const ChatDayDivider({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          _label(day),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Const.chatMutedColor,
          ),
        ),
      ),
    );
  }

  static String _label(DateTime at) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(at.year, at.month, at.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${at.day.toString().padLeft(2, '0')}/'
        '${at.month.toString().padLeft(2, '0')}/${at.year}';
  }
}
