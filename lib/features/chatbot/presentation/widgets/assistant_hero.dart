import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

class AssistantHero extends StatelessWidget {
  const AssistantHero({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    final robotSize = MediaQuery.sizeOf(context).width * 0.28;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AssistantPalette.heroTop, AssistantPalette.heroBottom],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ilu_chatbot.png',
            width: robotSize.clamp(80, 130),
            height: robotSize.clamp(80, 130),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.heroGreeting,
                  style: const TextStyle(
                    color: AssistantPalette.navy,
                    fontSize: 18,
                    height: 1.3,
                  ),
                ),
                Text(
                  t.heroName,
                  style: const TextStyle(
                    color: AssistantPalette.navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  t.heroBody,
                  style: const TextStyle(
                    color: AssistantPalette.body,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
