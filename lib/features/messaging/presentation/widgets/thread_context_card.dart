import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/i18n/translations.g.dart';

import '../../domain/entities/message_thread.dart';

/// What the conversation is about, pinned above the first message.
///
/// It sits in the transcript rather than the app bar because a professional
/// deciding on an offer needs the reasons, the address and the money in front
/// of them, and because it means the thread is never a blank screen.
class ThreadContextCard extends StatelessWidget {
  final String serviceLabel;
  final ThreadContext context_;

  const ThreadContextCard({
    super.key,
    required this.serviceLabel,
    required this.context_,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t.messaging.chat;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Const.borderSubtle),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services_outlined,
                  size: 16, color: Const.tosca),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  serviceLabel.isEmpty ? t.aboutTitle : serviceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ProText.bodyStrong
                      .copyWith(color: Const.primaryTextColor),
                ),
              ),
            ],
          ),
          if (context_.issueLabels.isNotEmpty) ...[
            const SizedBox(height: 10),
            _Label(t.reason),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final label in context_.issueLabels)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Const.tosca.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Const.tosca),
                    ),
                  ),
              ],
            ),
          ],
          if (context_.location != null) ...[
            const SizedBox(height: 10),
            _Label(t.where),
            const SizedBox(height: 4),
            Text(context_.location!, style: ProText.caption),
          ],
          if (context_.estimatedPrice != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _Label(t.estimate),
                const Spacer(),
                Text(
                  '\$${context_.estimatedPrice!.toStringAsFixed(2)}',
                  style: ProText.bodyStrong.copyWith(color: Const.aqua),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: ProText.overline.copyWith(
        color: Const.contentTextColor,
      ));
}

/// The suggested openers under an empty transcript. Tapping one fills the
/// composer — it never sends.
class ChatOpeners extends StatelessWidget {
  final List<String> openers;
  final ValueChanged<String> onPick;

  const ChatOpeners({super.key, required this.openers, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.messaging.chat.emptyPrompt,
            style: ProText.caption,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final opener in openers)
                OutlinedButton(
                  onPressed: () => onPick(opener),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Const.aqua),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    opener,
                    style: const TextStyle(
                      color: Const.aqua,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
