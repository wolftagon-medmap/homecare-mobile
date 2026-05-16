import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import '../../../widgets/precision_widgets.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_flow_bloc.dart';

class SelfRatedHealthScreen extends StatelessWidget {
  const SelfRatedHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: context.l10n.precision_self_rated_health_title),
      body: BlocBuilder<NutritionFlowBloc, NutritionFlowState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Spacer(),

                // Emoji Display
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getEmoji(state.assessment.selfRatedHealth),
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Health Rating Text
                Text(
                  _getHealthRatingText(context, state.assessment.selfRatedHealth),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Slider
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF00B4D8),
                          inactiveTrackColor: Colors.grey.shade300,
                          thumbColor: const Color(0xFF00B4D8),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12,
                            elevation: 4,
                          ),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 24),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: state.assessment.selfRatedHealth,
                          min: 1.0,
                          max: 5.0,
                          divisions: 4,
                          onChanged: (value) {
                            context.read<NutritionFlowBloc>().add(
                                NutritionFlowSelfRatedHealthUpdated(value));
                          },
                        ),
                      ),

                      // Slider Labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.precision_terrible,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            context.l10n.precision_excellent,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Next Button
                PrimaryButton(
                  text: context.l10n.common_next,
                  onPressed: () => context
                      .read<NutritionFlowBloc>()
                      .add(const NutritionFlowAssessmentStepAdvanced()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getEmoji(double rating) {
    if (rating <= 1.5) return '😰';
    if (rating <= 2.5) return '😕';
    if (rating <= 3.5) return '😐';
    if (rating <= 4.5) return '🙂';
    return '😊';
  }

  String _getHealthRatingText(BuildContext context, double rating) {
    if (rating <= 1.5) return context.l10n.precision_its_terrible;
    if (rating <= 2.5) return context.l10n.precision_its_bad;
    if (rating <= 3.5) return context.l10n.precision_neutral;
    if (rating <= 4.5) return context.l10n.precision_its_good;
    return context.l10n.precision_its_very_good;
  }
}
