import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/precision/screens/assessment/forms/health_history_screen.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';

class ChronicDiseaseSupportPage extends StatelessWidget {
  const ChronicDiseaseSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF92A3FD);
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_chronic_disease),
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
                      iconData: Icons.bloodtype,
                      title: context.l10n.precision_chronic_diabetes,
                      color: color,
                      child: CardSection(
                        title: context.l10n.precision_technologies_used,
                        items: const [
                          'PPARG-based glucose prediction',
                          'APOE-based ketogenic diet assessment',
                          'Microbiota modulation',
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.favorite_border,
                      title: context.l10n.precision_chronic_cardio,
                      color: color,
                      child: CardSection(
                        title: context.l10n.precision_programs_include,
                        items: const [
                          'APOA5 / LPL gene testing',
                          'TMAO metabolic intervention',
                          'ACE-guided sodium sensitivity check',
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.healing,
                      title: context.l10n.precision_chronic_autoimmune,
                      color: color,
                      child: CardSection(
                        title: context.l10n.precision_interventions_include,
                        items: const [
                          'Gluten/dairy cross-reactivity testing',
                          'VDR-based vitamin D3 dosing',
                          'Butyrate supplementation (SCFA therapy)',
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.monitor_weight_outlined,
                      title: context.l10n.precision_chronic_obesity,
                      color: color,
                      child: CardSection(
                        title: context.l10n.precision_precision_methods_include,
                        items: const [
                          'Hunger hormone genotyping (LEPR, MC4R)',
                          'Brown fat activators (Capsaicin, tea polyphenols)',
                          'Microbiota targeting (Akkermansia support)',
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
