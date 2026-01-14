import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';
import 'package:m2health/features/precision/screens/assessment/forms/health_history_screen.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';

class SubHealthPage extends StatelessWidget {
  const SubHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFF79E1B);
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_sub_health),
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
                      iconData: Icons.thermostat,
                      title: context.l10n.precision_sub_health_metabolic,
                      color: color,
                      child: Column(
                        children: [
                          CardSection(
                            title: context.l10n.precision_applicable_issues,
                            items: const [
                              'Fatigue syndrome',
                              'Blood glucose fluctuations',
                              'Mild insulin resistance',
                            ],
                          ),
                          CardSection(
                            title: context.l10n.precision_services_include,
                            items: const [
                              'CGM-guided card tolerance assesment',
                              'Mitochondrial support (CoQ10, alpha-lipoic acid)',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.psychology,
                      title: context.l10n.precision_sub_health_gut_brain,
                      color: color,
                      child: Column(
                        children: [
                          CardSection(
                            title: context.l10n.precision_applicable_issues,
                            items: const [
                              'Anxiety / Depression tendencies',
                              'Irritable Bowel Syndrome (IBS)',
                            ],
                          ),
                          CardSection(
                            title: context.l10n.precision_interventions_include,
                            items: const [
                              'Gut microbiota testing (16s rRNA)',
                              'Strain-specific probiotics (e.g. PS128)',
                              'Personalized low-FODMAP diet',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.shield_outlined,
                      title: context.l10n.precision_sub_health_immune,
                      color: color,
                      child: Column(
                        children: [
                          CardSection(
                            title: context.l10n.precision_applicable_issues,
                            items: const [
                              'Recurrent infections',
                              'Chronic inflammation',
                            ],
                          ),
                          CardSection(
                            title: context.l10n.precision_solutions_include,
                            items: const [
                              'VDR gene testing + vitamin D dosing',
                              'Flavonoid supplementation (based on COMT genotype)',
                              'AIDI (Anti-inflammatory Diet Index) improvement',
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
