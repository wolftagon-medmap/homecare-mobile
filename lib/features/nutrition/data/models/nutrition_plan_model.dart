import 'package:m2health/features/nutrition/domain/entities/nutrition_plan.dart';

class NutritionPlanModel extends NutritionPlan {
  const NutritionPlanModel({
    super.appointmentId,
    DietaryPlanModel? super.dietaryPlan,
    List<SupplementModel> super.supplements = const [],
    List<LifeStyleAdjustmentModel> super.lifestyleAdjustments = const [],
    Map<String, DailyMealPlanModel> super.weeklyMealPlan = const {},
  });

  factory NutritionPlanModel.fromJson(Map<String, dynamic> json) {
    return NutritionPlanModel(
      appointmentId: json['appointment_id'] as int?,
      // Server returns dietary fields flat at the top level (not nested)
      dietaryPlan:
          json['dietary_goal'] != null ? DietaryPlanModel.fromJson(json) : null,
      supplements: (json['supplements'] as List?)
              ?.map((e) => SupplementModel.fromJson(e))
              .toList() ??
          [],
      lifestyleAdjustments: (json['lifestyle_adjustments'] as List?)
              ?.map((e) => LifeStyleAdjustmentModel.fromJson(e))
              .toList() ??
          [],
      weeklyMealPlan: (json['meal_plan'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key,
                  DailyMealPlanModel.fromJson(value as Map<String, dynamic>)))
              .cast<String, DailyMealPlanModel>() ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
        // Spread dietary plan fields flat — backend expects them at the top level
        if (dietaryPlan != null) ...(dietaryPlan as DietaryPlanModel).toJson(),
        'supplements':
            supplements.map((e) => (e as SupplementModel).toJson()).toList(),
        'lifestyle_adjustments': lifestyleAdjustments
            .map((e) => (e as LifeStyleAdjustmentModel).toJson())
            .toList(),
        'meal_plan': weeklyMealPlan.isEmpty
            ? null
            : weeklyMealPlan.map((key, value) =>
                MapEntry(key, (value as DailyMealPlanModel).toJson())),
      };

  factory NutritionPlanModel.fromEntity(NutritionPlan entity) {
    return NutritionPlanModel(
      appointmentId: entity.appointmentId,
      dietaryPlan: entity.dietaryPlan != null
          ? DietaryPlanModel.fromEntity(entity.dietaryPlan!)
          : null,
      supplements:
          entity.supplements.map((e) => SupplementModel.fromEntity(e)).toList(),
      lifestyleAdjustments: entity.lifestyleAdjustments
          .map((e) => LifeStyleAdjustmentModel.fromEntity(e))
          .toList(),
      weeklyMealPlan: entity.weeklyMealPlan.map(
          (key, value) => MapEntry(key, DailyMealPlanModel.fromEntity(value))),
    );
  }
}

class DietaryPlanModel extends DietaryPlan {
  const DietaryPlanModel({
    required super.goal,
    required super.strategy,
    required super.dailyCaloryTarget,
    required super.recommendedFoods,
    required super.foodsToLimit,
  });

  factory DietaryPlanModel.fromJson(Map<String, dynamic> json) {
    return DietaryPlanModel(
      goal: json['dietary_goal'] as String? ?? '',
      strategy: json['dietary_strategy'] as String? ?? '',
      dailyCaloryTarget: json['daily_calory_target'] as int? ?? 0,
      recommendedFoods:
          (json['recommended_foods'] as List?)?.cast<String>() ?? [],
      foodsToLimit: (json['foods_to_limit'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'dietary_goal': goal,
        'dietary_strategy': strategy,
        'daily_calory_target': dailyCaloryTarget,
        'recommended_foods': recommendedFoods,
        'foods_to_limit': foodsToLimit,
      };

  factory DietaryPlanModel.fromEntity(DietaryPlan entity) {
    return DietaryPlanModel(
      goal: entity.goal,
      strategy: entity.strategy,
      dailyCaloryTarget: entity.dailyCaloryTarget,
      recommendedFoods: entity.recommendedFoods,
      foodsToLimit: entity.foodsToLimit,
    );
  }
}

class SupplementModel extends Supplement {
  const SupplementModel({required super.name, required super.dosage});

  factory SupplementModel.fromJson(Map<String, dynamic> json) {
    return SupplementModel(
      name: json['name'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'dosage': dosage};

  factory SupplementModel.fromEntity(Supplement entity) {
    return SupplementModel(name: entity.name, dosage: entity.dosage);
  }
}

class LifeStyleAdjustmentModel extends LifestyleAdjustment {
  const LifeStyleAdjustmentModel({
    required super.title,
    required super.description,
  });

  factory LifeStyleAdjustmentModel.fromJson(Map<String, dynamic> json) {
    return LifeStyleAdjustmentModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'description': description};

  factory LifeStyleAdjustmentModel.fromEntity(LifestyleAdjustment entity) {
    return LifeStyleAdjustmentModel(
      title: entity.title,
      description: entity.description,
    );
  }
}

class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.name,
    required super.imageUrl,
    super.isLocalImage = false,
    required super.calories,
    required super.grams,
    required super.protein,
    required super.carbs,
    required super.fat,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      grams: json['grams'] as int? ?? 0,
      protein: json['protein'] as int? ?? 0,
      carbs: json['carbs'] as int? ?? 0,
      fat: json['fat'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'image_url': imageUrl,
        'calories': calories,
        'grams': grams,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

  factory FoodItemModel.fromEntity(FoodItem entity) {
    return FoodItemModel(
      name: entity.name,
      imageUrl: entity.imageUrl,
      calories: entity.calories,
      grams: entity.grams,
      protein: entity.protein,
      carbs: entity.carbs,
      fat: entity.fat,
    );
  }
}

class DailyMealPlanModel extends DailyMealPlan {
  const DailyMealPlanModel({
    List<FoodItemModel> breakfast = const [],
    List<FoodItemModel> lunch = const [],
    List<FoodItemModel> dinner = const [],
  }) : super(breakfast: breakfast, lunch: lunch, dinner: dinner);

  factory DailyMealPlanModel.fromJson(Map<String, dynamic> json) {
    List<FoodItemModel> parseItems(dynamic items) {
      if (items == null) return [];
      return (items as List)
          .map((i) => FoodItemModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return DailyMealPlanModel(
      breakfast: parseItems(json['breakfast']),
      lunch: parseItems(json['lunch']),
      dinner: parseItems(json['dinner']),
    );
  }

  Map<String, dynamic> toJson() => {
        'breakfast':
            breakfast.map((f) => (f as FoodItemModel).toJson()).toList(),
        'lunch': lunch.map((f) => (f as FoodItemModel).toJson()).toList(),
        'dinner': dinner.map((f) => (f as FoodItemModel).toJson()).toList(),
      };

  factory DailyMealPlanModel.fromEntity(DailyMealPlan entity) {
    return DailyMealPlanModel(
      breakfast:
          entity.breakfast.map((f) => FoodItemModel.fromEntity(f)).toList(),
      lunch: entity.lunch.map((f) => FoodItemModel.fromEntity(f)).toList(),
      dinner: entity.dinner.map((f) => FoodItemModel.fromEntity(f)).toList(),
    );
  }
}
