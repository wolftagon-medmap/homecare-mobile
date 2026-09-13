import 'package:equatable/equatable.dart';

class NutritionPlan extends Equatable {
  final int? appointmentId;
  final DietaryPlan? dietaryPlan;
  final List<Supplement> supplements;
  final List<LifestyleAdjustment> lifestyleAdjustments;
  final Map<String, DailyMealPlan> weeklyMealPlan;

  const NutritionPlan({
    this.appointmentId,
    this.dietaryPlan,
    this.supplements = const [],
    this.lifestyleAdjustments = const [],
    this.weeklyMealPlan = const {},
  });

  NutritionPlan copyWith({
    int? appointmentId,
    DietaryPlan? dietaryPlan,
    List<Supplement>? supplements,
    List<LifestyleAdjustment>? lifestyleAdjustments,
    Map<String, DailyMealPlan>? weeklyMealPlan,
  }) {
    return NutritionPlan(
      appointmentId: appointmentId ?? this.appointmentId,
      dietaryPlan: dietaryPlan ?? this.dietaryPlan,
      supplements: supplements ?? this.supplements,
      lifestyleAdjustments: lifestyleAdjustments ?? this.lifestyleAdjustments,
      weeklyMealPlan: weeklyMealPlan ?? this.weeklyMealPlan,
    );
  }

  @override
  List<Object?> get props => [
        appointmentId,
        dietaryPlan,
        supplements,
        lifestyleAdjustments,
        weeklyMealPlan,
      ];
}

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

  DietaryPlan copyWith({
    String? goal,
    String? strategy,
    int? dailyCaloryTarget,
    List<String>? recommendedFoods,
    List<String>? foodsToLimit,
  }) {
    return DietaryPlan(
      goal: goal ?? this.goal,
      strategy: strategy ?? this.strategy,
      dailyCaloryTarget: dailyCaloryTarget ?? this.dailyCaloryTarget,
      recommendedFoods: recommendedFoods ?? this.recommendedFoods,
      foodsToLimit: foodsToLimit ?? this.foodsToLimit,
    );
  }

  @override
  List<Object?> get props =>
      [goal, strategy, dailyCaloryTarget, recommendedFoods, foodsToLimit];
}

class Supplement extends Equatable {
  final String name;
  final String dosage;

  const Supplement({required this.name, required this.dosage});

  Supplement copyWith({
    String? name,
    String? dosage,
  }) {
    return Supplement(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
    );
  }

  @override
  List<Object?> get props => [name, dosage];
}

class LifestyleAdjustment extends Equatable {
  final String title;
  final String description;

  const LifestyleAdjustment({required this.title, required this.description});

  LifestyleAdjustment copyWith({
    String? title,
    String? description,
  }) {
    return LifestyleAdjustment(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [title, description];
}

class FoodItem extends Equatable {
  final String name;
  final String imageUrl;
  final bool isLocalImage;
  final int calories;
  final int grams;
  final int protein;
  final int carbs;
  final int fat;

  const FoodItem({
    required this.name,
    required this.imageUrl,
    this.isLocalImage = false,
    required this.calories,
    required this.grams,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  FoodItem copyWith({
    String? name,
    String? imageUrl,
    bool? isLocalImage,
    int? calories,
    int? grams,
    int? protein,
    int? carbs,
    int? fat,
  }) {
    return FoodItem(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isLocalImage: isLocalImage ?? this.isLocalImage,
      calories: calories ?? this.calories,
      grams: grams ?? this.grams,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }

  @override
  List<Object?> get props =>
      [name, imageUrl, isLocalImage, calories, grams, protein, carbs, fat];
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

  DailyMealPlan copyWith({
    List<FoodItem>? breakfast,
    List<FoodItem>? lunch,
    List<FoodItem>? dinner,
  }) {
    return DailyMealPlan(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
    );
  }

  @override
  List<Object?> get props => [breakfast, lunch, dinner];
}
