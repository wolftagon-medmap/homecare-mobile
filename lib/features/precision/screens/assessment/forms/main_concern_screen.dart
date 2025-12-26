import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/precision/screens/assessment/info/anti_aging_longevity_page.dart';
import 'package:m2health/features/precision/screens/assessment/info/chronic_disease_support_page.dart';
import 'package:m2health/features/precision/screens/assessment/info/sub_health_page.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';
import 'package:m2health/features/precision/bloc/nutrition_assessment_cubit.dart';

class MainConcernScreen extends StatelessWidget {
  const MainConcernScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_assessment_title),
      body: BlocBuilder<NutritionAssessmentCubit, NutritionAssessmentState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.precision_main_concern_question,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.precision_main_concern_subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Selection Cards
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SelectionCard(
                          title: context.l10n.precision_sub_health,
                          description: context.l10n.precision_sub_health_desc,
                          imagePath: 'assets/illustration/foodies.png',
                          isSelected: state.mainConcern == 'Sub-Health',
                          onTap: () => context
                              .read<NutritionAssessmentCubit>()
                              .setMainConcern('Sub-Health'),
                        ),
                        SelectionCard(
                          title: context.l10n.precision_chronic_disease,
                          description:
                              context.l10n.precision_chronic_disease_desc,
                          imagePath: 'assets/illustration/planning.png',
                          isSelected: state.mainConcern == 'Chronic Disease',
                          onTap: () => context
                              .read<NutritionAssessmentCubit>()
                              .setMainConcern('Chronic Disease'),
                        ),
                        SelectionCard(
                          title: context.l10n.precision_anti_aging,
                          description: context.l10n.precision_anti_aging_desc,
                          imagePath: 'assets/illustration/implement.png',
                          isSelected: state.mainConcern == 'Anti-aging',
                          onTap: () => context
                              .read<NutritionAssessmentCubit>()
                              .setMainConcern('Anti-aging'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Next Button
                PrimaryButton(
                  text: context.l10n.common_next,
                  onPressed: state.mainConcern != null
                      ? () {
                          switch (state.mainConcern) {
                            case 'Sub-Health':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SubHealthPage(),
                                ),
                              );
                              break;
                            case 'Chronic Disease':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChronicDiseaseSupportPage(),
                                ),
                              );
                              break;
                            case 'Anti-aging':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AntiAgingLongevityPage(),
                                ),
                              );
                              break;
                          }
                        }
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
