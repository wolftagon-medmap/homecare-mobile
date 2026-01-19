import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';

class ImplementationJourneyPage extends StatelessWidget {
  const ImplementationJourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_implementation_journey),
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
                      iconData: Icons.description_outlined,
                      title: context.l10n.precision_implementation_indepth_assessment,
                      child: const Column(
                        children: [
                          CardBulletPoint(
                              text:
                                  'Omics testing + functional medicine examinations'),
                          CardBulletPoint(text: 'Digital lifestyle profiling'),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.groups_outlined,
                      title: context.l10n.precision_implementation_intervention,
                      child: const Column(
                        children: [
                          CardBulletPoint(text: 'Monthly biomarker retesting'),
                          CardBulletPoint(
                              text: 'Dynamic microbiome adjustment'),
                          CardBulletPoint(text: 'Digital therapy app support'),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.bar_chart_outlined,
                      title: context.l10n.precision_implementation_maintenance,
                      child: const Column(
                        children: [
                          CardBulletPoint(text: 'Annual genomic re-evaluation'),
                          CardBulletPoint(
                              text:
                                  'Adaptive nutrition strategies for environmental/lifestyle changes'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(text: context.l10n.precision_book_now, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
