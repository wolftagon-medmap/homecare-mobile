import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/message_thread.dart';
import 'message_action_button.dart';

class ThreadListTile extends StatelessWidget {
  final MessageThread thread;
  final VoidCallback onTap;

  const ThreadListTile({super.key, required this.thread, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unread = thread.unread > 0;
    final name = thread.counterpart?.name ?? 'M2Health';

    return Material(
      color: unread ? Const.aqua.withValues(alpha: 0.06) : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(name: name, avatar: thread.counterpart?.avatar),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  unread ? FontWeight.w700 : FontWeight.w600,
                              color: Const.primaryTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _relative(thread.lastMessageAt),
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      thread.serviceLabel,
                      style: const TextStyle(fontSize: 11, color: Const.tosca),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _preview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  unread ? Colors.grey[850] : Colors.grey[600],
                              fontWeight:
                                  unread ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 8),
                          UnreadDot(count: thread.unread),
                        ],
                      ],
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

  /// A card carries no body of its own, so the list says what it is instead.
  String get _preview {
    final last = thread.lastMessage;
    if (last == null) return 'Say hello';
    return switch (last.kind) {
      MessageKind.timeProposal => 'Suggested a different time',
      MessageKind.estimateRevision => 'Proposed a revised estimate',
      _ => last.body ?? '',
    };
  }

  static String _relative(DateTime? at) {
    if (at == null) return '';
    final diff = DateTime.now().difference(at.toLocal());
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    final local = at.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}';
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatar;

  const _Avatar({required this.name, this.avatar});

  @override
  Widget build(BuildContext context) {
    if (avatar != null && avatar!.isNotEmpty) {
      return CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatar!));
    }
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return CircleAvatar(
      radius: 22,
      backgroundColor: Const.aqua.withValues(alpha: 0.15),
      child: Text(
        initial,
        style: const TextStyle(
          color: Const.aqua,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
