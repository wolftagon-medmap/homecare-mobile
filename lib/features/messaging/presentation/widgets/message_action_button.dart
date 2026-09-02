import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';

import '../../domain/entities/message_thread.dart';
import '../../messaging_routes.dart';
import '../bloc/thread_index_cubit.dart';

/// The entry to a conversation, sitting on the thing the conversation is about.
///
/// It takes a [ThreadRef], never a thread id, so an appointment card can offer a
/// conversation without the appointment payload having grown a field for it. If
/// [ThreadIndexCubit] has no thread for the ref, this renders **nothing** — so a
/// card can never navigate to a screen that is not there.
class MessageActionButton extends StatelessWidget {
  final ThreadRef threadRef;

  /// `filled` for a primary action row, `outlined` beside other buttons,
  /// `icon` when the row is already crowded.
  final MessageActionStyle style;
  final String label;

  const MessageActionButton({
    super.key,
    required this.threadRef,
    this.style = MessageActionStyle.outlined,
    this.label = 'Message',
  });

  @override
  Widget build(BuildContext context) {
    final thread = context.select<ThreadIndexCubit, MessageThread?>(
      (cubit) => cubit.state.resolve(threadRef),
    );
    if (thread == null) return const SizedBox.shrink();

    void open() => _open(context, thread.id);

    return switch (style) {
      MessageActionStyle.icon =>
        _IconAction(unread: thread.unread, onTap: open),
      MessageActionStyle.filled =>
        _FilledAction(label: label, unread: thread.unread, onTap: open),
      MessageActionStyle.outlined =>
        _OutlinedAction(label: label, unread: thread.unread, onTap: open),
    };
  }

  Future<void> _open(BuildContext context, int threadId) async {
    final index = context.read<ThreadIndexCubit>();
    await context.push(MessagingRoutes.threadPath(threadId));
    // Reading the thread clears its unread; every badge in the app settles here.
    await index.refresh();
  }
}

enum MessageActionStyle { filled, outlined, icon }

class _OutlinedAction extends StatelessWidget {
  final String label;
  final int unread;
  final VoidCallback onTap;

  const _OutlinedAction({
    required this.label,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Const.aqua),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 15, color: Const.aqua),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Const.aqua,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          if (unread > 0) ...[
            const SizedBox(width: 6),
            UnreadDot(count: unread),
          ],
        ],
      ),
    );
  }
}

class _FilledAction extends StatelessWidget {
  final String label;
  final int unread;
  final VoidCallback onTap;

  const _FilledAction({
    required this.label,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Const.aqua,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          if (unread > 0) ...[
            const SizedBox(width: 6),
            UnreadDot(count: unread, onDark: true),
          ],
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final int unread;
  final VoidCallback onTap;

  const _IconAction({required this.unread, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: 'Message',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 22, color: Const.aqua),
          if (unread > 0)
            Positioned(
              right: -4,
              top: -4,
              child: UnreadDot(count: unread),
            ),
        ],
      ),
    );
  }
}

/// The per-conversation unread marker. The bell answers "is there anything
/// new?"; this answers "in which conversation?".
class UnreadDot extends StatelessWidget {
  final int count;
  final bool onDark;

  const UnreadDot({super.key, required this.count, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(minWidth: 17),
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: onDark ? Colors.white : const Color(0xFFD64545),
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 9 ? '9+' : '$count',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: onDark ? Const.aqua : Colors.white,
        ),
      ),
    );
  }
}
