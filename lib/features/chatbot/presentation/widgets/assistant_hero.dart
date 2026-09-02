import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          SvgPicture.asset(
            'assets/icons/ic_ai_robot.svg',
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

class AssistantBenefits extends StatelessWidget {
  const AssistantBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    final benefits = <(IconData, String)>[
      (Icons.lightbulb_outline, t.benefitUnderstand),
      (Icons.shield_outlined, t.benefitExplain),
      (Icons.schedule, t.benefitSaveTime),
      (Icons.person_outline, t.benefitConnect),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: AssistantPalette.cardTint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.benefitsTitle,
            style: const TextStyle(
              color: AssistantPalette.navy,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final benefit in benefits)
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 96) / 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        benefit.$1,
                        size: 18,
                        color: AssistantPalette.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit.$2,
                          style: const TextStyle(
                            color: AssistantPalette.body,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
