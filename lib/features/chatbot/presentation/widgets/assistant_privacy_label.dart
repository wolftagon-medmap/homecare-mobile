import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

class AssistantPrivacyLabel extends StatelessWidget {
  const AssistantPrivacyLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/ic_lock.png', width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                t.privacyLabel,
                style: const TextStyle(
                  color: Color(0xFF5782F1),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: t.privacyDetail,
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 8),
              preferBelow: true,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AssistantPalette.navy,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.35,
              ),
              child: const Icon(
                Icons.info_outline,
                size: 18,
                color: Color(0xFF5782F1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
