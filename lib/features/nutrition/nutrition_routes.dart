import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_assessment_detail_cubit.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/features/nutrition/presentation/pages/assessment/nutrition_assessment_page.dart';
import 'package:m2health/features/nutrition/presentation/pages/nutrition_booking_flow_page.dart';
import 'package:m2health/features/nutrition/presentation/pages/assessment/nutrition_assessment_detail_screen.dart';
import 'package:m2health/features/nutrition/presentation/pages/implementation/implementation_journey_page.dart';
import 'package:m2health/features/nutrition/presentation/pages/plan/nutrition_plan_page.dart';
import 'package:m2health/features/nutrition/presentation/pages/plan/weekly_meal_plan_detail_page.dart';
import 'package:m2health/features/nutrition/presentation/pages/plan/weekly_meal_plan_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

final GlobalKey<NavigatorState> _nutritionPlanKey = GlobalKey<NavigatorState>();

class PrecisionNutritionRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: 'assessment',
      name: AppRoutes.nutritionAssessment,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NutritionAssessmentPage(),
    ),
    GoRoute(
      path: 'review',
      name: AppRoutes.nutritionReview,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final params = state.extra as NutritionAssessmentDetailPageParams;
        return BlocProvider(
          create: (_) => sl<NutritionAssessmentDetailCubit>(),
          child: NutritionAssessmentDetailPage(params: params),
        );
      },
    ),
    GoRoute(
      path: 'booking',
      name: AppRoutes.nutritionBooking,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NutritionBookingFlowPage(),
    ),
    ShellRoute(
        parentNavigatorKey: rootNavigatorKey,
        navigatorKey: _nutritionPlanKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (_) => sl<NutritionPlanCubit>(),
            child: child,
          );
        },
        routes: [
          GoRoute(
              path: 'plan',
              name: AppRoutes.precisionNutritionPlan,
              builder: (context, state) {
                return NutritionPlanPage(
                  appointmentId: state.extra as int?,
                );
              }),
          GoRoute(
              path: 'plan/weekly',
              name: AppRoutes.weeklyMealPlan,
              builder: (context, state) {
                return const WeeklyMealPlanPage();
              }),
          GoRoute(
              path: 'plan/weekly/detail',
              name: AppRoutes.weeklyMealPlanDetail,
              builder: (context, state) {
                final day = state.uri.queryParameters['day'] ?? 'Monday';
                return WeeklyMealPlanDetailPage(day: day);
              }),
        ]),
    GoRoute(
        path: 'implementation-journey',
        name: AppRoutes.implementationJourney,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const ImplementationJourneyPage();
        }),
  ];
}
