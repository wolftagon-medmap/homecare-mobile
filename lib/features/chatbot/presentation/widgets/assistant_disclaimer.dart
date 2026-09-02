import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The mock's `Important` card. Pinned above the composer, never dismissible —
/// it is the only place the capability boundary is stated to the patient.
class AssistantDisclaimer extends StatefulWidget {
  const AssistantDisclaimer({super.key});

  @override
  State<AssistantDisclaimer> createState() => _AssistantDisclaimerState();
}

class _AssistantDisclaimerState extends State<AssistantDisclaimer> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    return Material(
      color: AssistantPalette.cardTint,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 18,
                color: AssistantPalette.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.disclaimerTitle,
                      style: const TextStyle(
                        color: AssistantPalette.navy,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.disclaimerBody,
                      maxLines: _expanded ? null : 2,
                      overflow: _expanded ? null : TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AssistantPalette.body,
                        fontSize: 11.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: AssistantPalette.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssistantPrivacyLabel extends StatelessWidget {
  const AssistantPrivacyLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/ic_lock.png', width: 18, height: 18),
          const SizedBox(width: 6),
          Tooltip(
            message: t.privacyDetail,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(seconds: 8),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AssistantPalette.navy,
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.35,
            ),
            child: Text(
              t.privacyLabel,
              style: const TextStyle(
                color: Color(0xFF5782F1),
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
