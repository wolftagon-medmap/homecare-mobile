import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_flow_bloc.dart';
import 'package:m2health/features/nutrition/screens/assessment/forms/biomarker_upload_screen.dart';
import 'package:m2health/features/nutrition/screens/assessment/forms/health_history_screen.dart';
import 'package:m2health/features/nutrition/screens/assessment/forms/lifestyle_habits_screen.dart';
import 'package:m2health/features/nutrition/screens/assessment/forms/main_concern_screen.dart';
import 'package:m2health/features/nutrition/screens/assessment/forms/nutrition_habits_screen.dart';
import 'package:m2health/features/nutrition/screens/assessment/forms/self_rated_health_screen.dart';
import 'package:m2health/features/nutrition/screens/assessment/info/anti_aging_longevity_page.dart';
import 'package:m2health/features/nutrition/screens/assessment/info/chronic_disease_support_page.dart';
import 'package:m2health/features/nutrition/screens/assessment/info/sub_health_page.dart';
import 'package:m2health/route/app_routes.dart';

class NutritionAssessmentPage extends StatefulWidget {
  const NutritionAssessmentPage({super.key});

  @override
  State<NutritionAssessmentPage> createState() =>
      _NutritionAssessmentPageState();
}

class _NutritionAssessmentPageState extends State<NutritionAssessmentPage> {
  int? _responseIdAtEntry;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<NutritionFlowBloc>();
    _responseIdAtEntry = bloc.state.questionnaireResponseId;
    bloc.add(const NutritionFlowStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NutritionFlowBloc, NutritionFlowState>(
      listenWhen: (prev, curr) =>
          prev.questionnaireResponseId != curr.questionnaireResponseId &&
          curr.questionnaireResponseId != null &&
          curr.questionnaireResponseId != _responseIdAtEntry,
      listener: (context, state) {
        // New submission succeeded — replace assessment with review in the stack.
        context.pushReplacement(AppRoutes.nutritionReview);
      },
      builder: (context, state) {
        if (state.isInitializing) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Const.aqua)),
          );
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            if (state.isLoading) return;
            if (state.assessmentStep > 0) {
              context
                  .read<NutritionFlowBloc>()
                  .add(const NutritionFlowAssessmentStepDecremented());
            } else {
              context.pop();
            }
          },
          child: _buildStep(state),
        );
      },
    );
  }

  Widget _buildStep(NutritionFlowState state) => switch (state.assessmentStep) {
        0 => const MainConcernScreen(),
        1 => switch (state.mainConcern) {
            'Sub-Health' => const SubHealthPage(),
            'Chronic Disease' => const ChronicDiseaseSupportPage(),
            _ => const AntiAgingLongevityPage(),
          },
        2 => const HealthHistoryScreen(),
        3 => const SelfRatedHealthScreen(),
        4 => const LifestyleHabitsScreen(),
        5 => const NutritionHabitsScreen(),
        _ => const BiomarkerUploadScreen(),
      };
}
