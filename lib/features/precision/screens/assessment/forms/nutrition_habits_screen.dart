import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/primary_button.dart';
import '../../../widgets/precision_widgets.dart';
import '../../../bloc/nutrition_assessment_cubit.dart';
import 'biomarker_upload_screen.dart';

class NutritionHabitsScreen extends StatefulWidget {
  const NutritionHabitsScreen({Key? key}) : super(key: key);

  @override
  State<NutritionHabitsScreen> createState() => _NutritionHabitsScreenState();
}

class _NutritionHabitsScreenState extends State<NutritionHabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mealFrequencyController = TextEditingController();
  final _foodSensitivitiesController = TextEditingController();
  final _favoriteFoodsController = TextEditingController();
  final _avoidedFoodsController = TextEditingController();
  final _waterIntakeController = TextEditingController();
  final _pastDietsController = TextEditingController();

  @override
  void dispose() {
    _mealFrequencyController.dispose();
    _foodSensitivitiesController.dispose();
    _favoriteFoodsController.dispose();
    _avoidedFoodsController.dispose();
    _waterIntakeController.dispose();
    _pastDietsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final nutritionHabits =
        context.read<NutritionAssessmentCubit>().state.nutritionHabits;
    if (nutritionHabits == null) return;
    _mealFrequencyController.text = nutritionHabits.mealFrequency;
    _foodSensitivitiesController.text = nutritionHabits.foodSensitivities;
    _favoriteFoodsController.text = nutritionHabits.favoriteFoods;
    _avoidedFoodsController.text = nutritionHabits.avoidedFoods;
    _waterIntakeController.text = nutritionHabits.waterIntake;
    _pastDietsController.text = nutritionHabits.pastDiets;
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      // Create NutritionHabits and update cubit
      final nutritionHabits = NutritionHabits(
        mealFrequency: _mealFrequencyController.text,
        foodSensitivities: _foodSensitivitiesController.text,
        favoriteFoods: _favoriteFoodsController.text,
        avoidedFoods: _avoidedFoodsController.text,
        waterIntake: _waterIntakeController.text,
        pastDiets: _pastDietsController.text,
      );

      context
          .read<NutritionAssessmentCubit>()
          .updateNutritionHabits(nutritionHabits);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BiomarkerUploadScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.precision_nutrition_habits_title),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Frequency Section
                      CustomTextField(
                        label: context.l10n.precision_meal_frequency_label,
                        hintText: context.l10n.precision_meal_frequency_hint,
                        controller: _mealFrequencyController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.precision_meal_frequency_error;
                          }
                          return null;
                        },
                      ),

                      // Food Sensitivities Section
                      CustomTextField(
                        label: context.l10n.precision_food_sensitivities_label,
                        hintText: context.l10n.precision_food_sensitivities_hint,
                        controller: _foodSensitivitiesController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.precision_food_sensitivities_error;
                          }
                          return null;
                        },
                      ),

                      // Favorite Foods Section
                      CustomTextField(
                        label: context.l10n.precision_favorite_foods_label,
                        hintText: context.l10n.precision_favorite_foods_hint,
                        controller: _favoriteFoodsController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.precision_favorite_foods_error;
                          }
                          return null;
                        },
                      ),

                      // Avoided Foods Section
                      CustomTextField(
                        label: context.l10n.precision_avoided_foods_label,
                        hintText: context.l10n.precision_avoided_foods_hint,
                        controller: _avoidedFoodsController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.precision_avoided_foods_error;
                          }
                          return null;
                        },
                      ),

                      // Water Intake Section
                      CustomTextField(
                        label: context.l10n.precision_water_intake_label,
                        hintText: context.l10n.precision_water_intake_hint,
                        controller: _waterIntakeController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.precision_water_intake_error;
                          }
                          return null;
                        },
                      ),

                      // Past Diets Section
                      CustomTextField(
                        label: context.l10n.precision_past_diets_label,
                        hintText: context.l10n.precision_past_diets_hint,
                        controller: _pastDietsController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.precision_past_diets_error;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Next Button
              PrimaryButton(
                text: context.l10n.common_next,
                onPressed: _onNextPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
