import 'package:flutter/material.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/confirm_request_card.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/intake_bubbles.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/professional_shortlist.dart';

/// Renders a single [Block]. Interactive blocks are actionable only when they're
/// the latest block and unresolved; [onReply] echoes the backend token.
class BlockView extends StatelessWidget {
  final Block block;

  /// Whether this is the last block in the transcript (interactive blocks are
  /// only actionable while latest).
  final bool isLast;

  /// The reply token already chosen for this block, if any.
  final String? chosenReplyId;

  final ValueChanged<String>? onReply;

  const BlockView({
    super.key,
    required this.block,
    this.isLast = false,
    this.chosenReplyId,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final active = isLast && chosenReplyId == null;
    return switch (block) {
      UserTextBlock(:final text) => UserBubble(text: text),
      AssistantTextBlock(:final text) => AssistantBubble(text: text),
      NoticeBlock(:final text, :final noticeKind) => NoticeBanner(text: text, kind: noticeKind),
      ConfirmRequestBlock b => ConfirmRequestCard(
          block: b,
          active: active,
          chosenReplyId: chosenReplyId,
          onReply: onReply,
        ),
      ProfessionalShortlistBlock b => ProfessionalShortlist(
          block: b,
          active: active,
          chosenSelectId: chosenReplyId,
          onReply: onReply,
        ),
      LocationRequestBlock(:final text) => _pending(text),
      BookingCreatedBlock(:final text) => _pending(text),
      UnknownBlock() => const SizedBox.shrink(),
    };
  }

  Widget _pending(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text.isNotEmpty) AssistantBubble(text: text),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Text(
            'Please update your app to continue this step.',
            style: TextStyle(color: Color(0xFF8A96BC), fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}
