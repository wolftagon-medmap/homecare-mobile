import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/domain/entities/block.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/presentation/widgets/intake_bubbles.dart';

/// A yes/no confirmation. Tapping echoes the backend-supplied token. Once
/// resolved (or when historical) the buttons are replaced by the chosen answer.
class ConfirmRequestCard extends StatelessWidget {
  final ConfirmRequestBlock block;

  /// Whether this card can still be acted on (it's the latest block, unresolved).
  final bool active;

  /// The chosen token, if already resolved.
  final String? chosenReplyId;

  final ValueChanged<String>? onReply;

  const ConfirmRequestCard({
    super.key,
    required this.block,
    required this.active,
    this.chosenReplyId,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssistantBubble(text: block.text),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: chosenReplyId != null ? _chosen() : _buttons(),
        ),
      ],
    );
  }

  Widget _chosen() {
    final yes = chosenReplyId == block.confirmId;
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 18, color: Const.aqua),
        const SizedBox(width: 6),
        Text(
          yes ? 'You confirmed' : 'You declined',
          style: const TextStyle(color: Color(0xFF5A6485), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: active ? () => onReply?.call(block.confirmId) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.aqua,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Yes'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: active ? () => onReply?.call(block.cancelId) : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: Const.aqua,
              side: const BorderSide(color: Const.aqua),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('No'),
          ),
        ),
      ],
    );
  }
}
