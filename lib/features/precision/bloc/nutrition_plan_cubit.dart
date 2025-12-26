import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/precision_dummy_data.dart';

// --- ENUMS & MODELS ---

enum NutritionPlanStatus { initial, loading, success, failure }

class DietaryPlan extends Equatable {
  final String goal;
  final String strategy;
  final int dailyCaloryTarget;
  final List<String> recommendedFoods;
  final List<String> foodsToLimit;

  const DietaryPlan({
    required this.goal,
    required this.strategy,
    required this.dailyCaloryTarget,
    required this.recommendedFoods,
    required this.foodsToLimit,
  });

  @override
  List<Object?> get props =>
      [goal, strategy, dailyCaloryTarget, recommendedFoods, foodsToLimit];
}

class Supplement extends Equatable {
  final String name;
  final String dosage;

  const Supplement({required this.name, required this.dosage});

  @override
  List<Object?> get props => [name, dosage];
}

class LifestyleAdjustment extends Equatable {
  final String title;
  final String description;

  const LifestyleAdjustment({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class FoodItem extends Equatable {
  final String name;
  final String imageUrl;
  final int calories;
  final int grams;
  final int protein;
  final int carbs;
  final int fat;

  const FoodItem({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.grams,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  List<Object?> get props =>
      [name, imageUrl, calories, grams, protein, carbs, fat];
}

class DailyMealPlan extends Equatable {
  final List<FoodItem> breakfast;
  final List<FoodItem> lunch;
  final List<FoodItem> dinner;

  const DailyMealPlan({
    this.breakfast = const [],
    this.lunch = const [],
    this.dinner = const [],
  });

  @override
  List<Object?> get props => [breakfast, lunch, dinner];
}

// --- STATE ---

class NutritionPlanState extends Equatable {
  final NutritionPlanStatus status;
  final DietaryPlan? dietaryPlan;
  final List<Supplement> supplements;
  final List<LifestyleAdjustment> lifestyleAdjustments;
  final Map<String, DailyMealPlan> weeklyMealPlan;
  final String? errorMessage;

  const NutritionPlanState({
    this.status = NutritionPlanStatus.initial,
    this.dietaryPlan,
    this.supplements = const [],
    this.lifestyleAdjustments = const [],
    this.weeklyMealPlan = const {},
    this.errorMessage,
  });

  NutritionPlanState copyWith({
    NutritionPlanStatus? status,
    DietaryPlan? dietaryPlan,
    List<Supplement>? supplements,
    List<LifestyleAdjustment>? lifestyleAdjustments,
    Map<String, DailyMealPlan>? weeklyMealPlan,
    String? errorMessage,
  }) {
    return NutritionPlanState(
      status: status ?? this.status,
      dietaryPlan: dietaryPlan ?? this.dietaryPlan,
      supplements: supplements ?? this.supplements,
      lifestyleAdjustments: lifestyleAdjustments ?? this.lifestyleAdjustments,
      weeklyMealPlan: weeklyMealPlan ?? this.weeklyMealPlan,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        dietaryPlan,
        supplements,
        lifestyleAdjustments,
        weeklyMealPlan,
        errorMessage
      ];
}

// --- CUBIT ---

class NutritionPlanCubit extends Cubit<NutritionPlanState> {
  NutritionPlanCubit() : super(const NutritionPlanState());

  Future<void> loadNutritionPlan() async {
    emit(state.copyWith(status: NutritionPlanStatus.loading));
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(
        status: NutritionPlanStatus.success,
        dietaryPlan: dummyDietaryPlan,
        supplements: dummySupplements,
        lifestyleAdjustments: dummyLifestyleAdjustments,
        weeklyMealPlan: dummyWeeklyMealPlan,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: NutritionPlanStatus.failure,
          errorMessage: 'Failed to load nutrition plan.'));
    }
  }
}
