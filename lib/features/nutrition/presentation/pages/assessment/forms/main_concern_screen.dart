import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/nutrition/presentation/widgets/precision_widgets.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_flow_bloc.dart';

class MainConcernScreen extends StatelessWidget {
  const MainConcernScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_assessment_title),
      body: BlocBuilder<NutritionFlowBloc, NutritionFlowState>(
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
                          isSelected:
                              state.assessment.mainConcern == 'Sub-Health',
                          onTap: () => context.read<NutritionFlowBloc>().add(
                              const NutritionFlowMainConcernSet('Sub-Health')),
                        ),
                        SelectionCard(
                          title: context.l10n.precision_chronic_disease,
                          description:
                              context.l10n.precision_chronic_disease_desc,
                          imagePath: 'assets/illustration/planning.png',
                          isSelected:
                              state.assessment.mainConcern == 'Chronic Disease',
                          onTap: () => context.read<NutritionFlowBloc>().add(
                              const NutritionFlowMainConcernSet(
                                  'Chronic Disease')),
                        ),
                        SelectionCard(
                          title: context.l10n.precision_anti_aging,
                          description: context.l10n.precision_anti_aging_desc,
                          imagePath: 'assets/illustration/implement.png',
                          isSelected:
                              state.assessment.mainConcern == 'Anti-aging',
                          onTap: () => context.read<NutritionFlowBloc>().add(
                              const NutritionFlowMainConcernSet('Anti-aging')),
                        ),
                      ],
                    ),
                  ),
                ),

                PrimaryButton(
                  text: context.l10n.common_next,
                  onPressed: state.assessment.mainConcern != null
                      ? () => context
                          .read<NutritionFlowBloc>()
                          .add(const NutritionFlowAssessmentStepAdvanced())
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
