import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/precision/screens/assessment/forms/health_history_screen.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';

class AntiAgingLongevityPage extends StatelessWidget {
  const AntiAgingLongevityPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF10B981);
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_anti_aging),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  children: [
                    FeatureDetailCard(
                      iconData: Icons.autorenew_outlined,
                      title: context.l10n.precision_anti_aging_cellular,
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'Improve cellular energy and delay biological aging.'),
                          CardSection(
                            title: context.l10n.precision_applicable_issues,
                            items: const [
                              'Low energy and fatigue',
                              'Brain fog issues',
                              'Poor digital medium',
                            ],
                          ),
                          CardSection(
                            title: context.l10n.precision_interventions_include,
                            items: const [
                              'NAD+ and mitochondria function testing',
                              'Autophagy and cellular rejuvenation plan',
                              'Personalized oxidative stress reduction',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.psychology_outlined,
                      title: context.l10n.precision_anti_aging_cognitive,
                      color: color, // Blue
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'Enhance mental clarity, focus, and brain plasticity.'),
                          CardSection(
                            title: context.l10n.precision_applicable_issues,
                            items: const [
                              'Brain fog, memory issues, mental fatigue',
                              'APOE4-related cognitive risk',
                            ],
                          ),
                          CardSection(
                            title: context.l10n.precision_interventions_include,
                            items: const [
                              'Omega-3 Index and BDNF-related genotyping',
                              'Personalized MIND diet and nootropic nutrition plan',
                              'Gut-brain axis modulation',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.balance_outlined,
                      title: context.l10n.precision_anti_aging_hormonal,
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'Achieve optimal hormone levels and maintain youthful function.'),
                          CardSection(
                            title: context.l10n.precision_applicable_issues,
                            items: const [
                              'Hormonal decline (DHEA, estrogen, testosterone)',
                              'Subpar IGF-1 (blood biomarker)',
                              'Decline in strength',
                            ],
                          ),
                          CardSection(
                            title: context.l10n.precision_interventions_include,
                            items: const [
                              'Hormone-related genomic testing',
                              'Adaptogen and herbal support (ashwagandha, maca, etc)',
                              'Circadian rhythm and sleep optimization',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.face_retouching_natural,
                      title: context.l10n.precision_anti_aging_skin,
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'Maintain youthful skin and connective tissue health.'),
                          CardSection(
                            title: context.l10n.precision_applicable_issues,
                            items: const [
                              'Skin health, elasticity, wrinkles, joint stiffness',
                            ],
                          ),
                          CardSection(
                            title: context.l10n.precision_interventions_include,
                            items: const [
                              'Collagen-related genomic testing',
                              'Antioxidant-rich micronutrient protocol',
                              'Skin microbiome and hydration optimization program',
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.common_next,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HealthHistoryScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
