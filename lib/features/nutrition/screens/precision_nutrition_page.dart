import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_flow_bloc.dart';
import 'package:m2health/route/app_routes.dart';

class PrecisionNutritionPage extends StatefulWidget {
  const PrecisionNutritionPage({super.key});

  @override
  State<PrecisionNutritionPage> createState() => _PrecisionNutritionPageState();
}

class _PrecisionNutritionPageState extends State<PrecisionNutritionPage> {
  @override
  void initState() {
    super.initState();
    context.read<NutritionFlowBloc>().add(const NutritionFlowStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionFlowBloc, NutritionFlowState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.l10n.precision_nutrition_title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: state.isInitializing
              ? const Center(
                  child: CircularProgressIndicator(color: Const.aqua))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _NutritionStepTimeline(state: state),
                ),
        );
      },
    );
  }
}

// --- Step Timeline ------------------------------------------------------------

class _NutritionStepTimeline extends StatelessWidget {
  final NutritionFlowState state;

  const _NutritionStepTimeline({required this.state});

  void _openFlow(BuildContext context) {
    final state = context.read<NutritionFlowBloc>().state;
    if (state.isAssessmentSubmitted) {
      context.push(AppRoutes.nutritionReview);
    } else {
      context.push(AppRoutes.nutritionAssessment);
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessmentUnlocked = true;
    final planUnlocked = state.isAssessmentSubmitted;
    final implementationUnlocked = false;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left column: step badges + connecting lines
          SizedBox(
            width: 48,
            child: Column(
              children: [
                const Expanded(flex: 1, child: (SizedBox())),
                _StepBadge(step: 1, unlocked: assessmentUnlocked),
                _ConnectorLine(unlocked: planUnlocked),
                _StepBadge(step: 2, unlocked: planUnlocked),
                _ConnectorLine(unlocked: implementationUnlocked),
                _StepBadge(step: 3, unlocked: implementationUnlocked),
                const Expanded(flex: 1, child: (SizedBox())),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right column: step cards
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Step 1 — Assessment
                _StepCard(
                  title: context.l10n.precision_assessment_title,
                  description: context.l10n.precision_assessment_desc,
                  buttonText: state.isAssessmentSubmitted
                      ? context.l10n.precision_view_details
                      : context.l10n.precision_start_now,
                  imagePath: 'assets/illustration/foodies.png',
                  backgroundColor: const Color(0xFFE8F3FF),
                  unlocked: assessmentUnlocked,
                  onTap: () => _openFlow(context),
                ),
                const SizedBox(height: 16),
                // Step 2 — Plan / Book
                _StepCard(
                  title: context.l10n.precision_plan_title,
                  description: context.l10n.precision_plan_desc,
                  buttonText: context.l10n.precision_book_now,
                  imagePath: 'assets/illustration/planning.png',
                  backgroundColor: const Color(0xFFFFF6E9),
                  unlocked: planUnlocked,
                  onTap: planUnlocked
                      ? () => context.push(AppRoutes.nutritionBooking)
                      : null,
                ),
                const SizedBox(height: 16),
                // Step 3 — Implementation (locked until plan ready)
                _StepCard(
                  title: context.l10n.precision_implementation_title,
                  description: context.l10n.precision_implementation_desc,
                  buttonText: context.l10n.precision_start_now,
                  imagePath: 'assets/illustration/implement.png',
                  backgroundColor: const Color(0xFFF8F0FF),
                  unlocked: implementationUnlocked,
                  onTap: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Step Badge ---------------------------------------------------------------

class _StepBadge extends StatelessWidget {
  final int step;
  final bool unlocked;

  const _StepBadge({required this.step, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: unlocked ? Const.aqua : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// --- Connector Line -----------------------------------------------------------

class _ConnectorLine extends StatelessWidget {
  final bool unlocked;

  const _ConnectorLine({required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2, // 2x more space than first and last space
      child: Center(
        child: Container(
          width: 2,
          color: unlocked ? Const.aqua : Colors.grey.shade300,
        ),
      ),
    );
  }
}

// --- Step Card ----------------------------------------------------------------

class _StepCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final String imagePath;
  final Color backgroundColor;
  final bool unlocked;
  final VoidCallback? onTap;

  const _StepCard({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.imagePath,
    required this.backgroundColor,
    required this.unlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg =
        unlocked ? backgroundColor : backgroundColor.withOpacity(0.5);

    return Container(
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -16,
            child: Opacity(
              opacity: unlocked ? 1.0 : 0.4,
              child: Image.asset(imagePath, width: 160, height: 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: unlocked ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: unlocked ? Colors.black87 : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        unlocked ? Const.aqua : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
