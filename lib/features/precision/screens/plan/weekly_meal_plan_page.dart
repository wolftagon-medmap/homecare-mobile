import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/precision/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';
import 'package:m2health/route/app_routes.dart';

const weeklyFoodImagePaths = [
  'assets/images/food_chicken_breast.webp',
  'assets/images/food_salmon.webp',
  'assets/images/food_steak.webp',
  'assets/images/food_oatmeal.webp',
  'assets/images/food_vegetables.webp',
  'assets/images/food_bread.webp',
  'assets/images/food_beans.webp',
];

class WeeklyMealPlanPage extends StatelessWidget {
  const WeeklyMealPlanPage({super.key});

  String _getLocalDayName(BuildContext context, String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return context.l10n.day_monday;
      case 'tuesday':
        return context.l10n.day_tuesday;
      case 'wednesday':
        return context.l10n.day_wednesday;
      case 'thursday':
        return context.l10n.day_thursday;
      case 'friday':
        return context.l10n.day_friday;
      case 'saturday':
        return context.l10n.day_saturday;
      case 'sunday':
        return context.l10n.day_sunday;
      default:
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weeklyPlan = context.read<NutritionPlanCubit>().state.weeklyMealPlan;
    final days = weeklyPlan.keys.toList();
    final description =
        '${context.l10n.precision_meal_breakfast} • ${context.l10n.precision_meal_lunch} • ${context.l10n.precision_meal_dinner}';

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_weekly_meal_plan_title),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final imagePath = weeklyFoodImagePaths[index];

          return GestureDetector(
            onTap: () => GoRouter.of(context).pushNamed(
              AppRoutes.weeklyMealPlanDetail,
              queryParameters: {'day': day},
            ),
            child: Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _getLocalDayName(context, day).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
