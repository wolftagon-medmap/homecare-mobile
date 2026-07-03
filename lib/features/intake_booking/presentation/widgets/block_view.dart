import 'package:flutter/material.dart';
import 'package:m2health/features/intake_booking/domain/entities/block.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/intake_bubbles.dart';

/// Renders a single [Block]. M1 handles text + notices; interactive blocks
/// (confirm / shortlist / location / booking) get a placeholder until their
/// dedicated widgets land in M2–M4.
class BlockView extends StatelessWidget {
  final Block block;
  const BlockView({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      UserTextBlock(:final text) => UserBubble(text: text),
      AssistantTextBlock(:final text) => AssistantBubble(text: text),
      NoticeBlock(:final text, :final noticeKind) => NoticeBanner(text: text, kind: noticeKind),
      ConfirmRequestBlock(:final text) => _pending(text),
      LocationRequestBlock(:final text) => _pending(text),
      BookingCreatedBlock(:final text) => _pending(text),
      ProfessionalShortlistBlock() => _pending('Here are the available professionals.'),
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
