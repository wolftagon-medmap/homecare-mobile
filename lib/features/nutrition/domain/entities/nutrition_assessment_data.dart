import 'dart:io';

class HealthProfile {
  final String? knownCondition;
  final List<String> specialConsiderations;
  final String? medicationHistory;
  final String? familyHistory;

  HealthProfile({
    this.knownCondition,
    this.specialConsiderations = const [],
    this.medicationHistory,
    this.familyHistory,
  });
}

class LifestyleHabits {
  final double? sleepHours;
  final String? activityLevel;
  final String? exerciseFrequency;
  final String? stressLevel;
  final String? smokingAlcoholHabits;

  LifestyleHabits({
    this.sleepHours,
    this.activityLevel,
    this.exerciseFrequency,
    this.stressLevel,
    this.smokingAlcoholHabits,
  });
}

class NutritionHabits {
  final String? mealFrequency;
  final String? foodSensitivities;
  final String? favoriteFoods;
  final String? avoidedFoods;
  final String? waterIntake;
  final String? pastDiets;

  NutritionHabits({
    this.mealFrequency,
    this.foodSensitivities,
    this.favoriteFoods,
    this.avoidedFoods,
    this.waterIntake,
    this.pastDiets,
  });
}

class NutritionAssessmentData {
  final String? mainConcern;
  final double selfRatedHealth;
  final HealthProfile? healthProfile;
  final LifestyleHabits? lifestyleHabits;
  final NutritionHabits? nutritionHabits;
  final List<File> files;
  final List<String> fileUrls;

  const NutritionAssessmentData({
    this.mainConcern,
    this.selfRatedHealth = 1.0,
    this.healthProfile,
    this.lifestyleHabits,
    this.nutritionHabits,
    this.files = const [],
    this.fileUrls = const [],
  });

  NutritionAssessmentData copyWith({
    String? mainConcern,
    double? selfRatedHealth,
    HealthProfile? healthProfile,
    LifestyleHabits? lifestyleHabits,
    NutritionHabits? nutritionHabits,
    List<File>? files,
    List<String>? fileUrls,
  }) {
    return NutritionAssessmentData(
      mainConcern: mainConcern ?? this.mainConcern,
      selfRatedHealth: selfRatedHealth ?? this.selfRatedHealth,
      healthProfile: healthProfile ?? this.healthProfile,
      lifestyleHabits: lifestyleHabits ?? this.lifestyleHabits,
      nutritionHabits: nutritionHabits ?? this.nutritionHabits,
      files: files ?? this.files,
      fileUrls: fileUrls ?? this.fileUrls,
    );
  }

  factory NutritionAssessmentData.fromAnswers(Map<String, dynamic> answers) {
    return NutritionAssessmentData(
      mainConcern: answers['main_concern'] as String?,
      selfRatedHealth:
          (answers['self_rated_health'] as num?)?.toDouble() ?? 1.0,
      healthProfile: HealthProfile(
        knownCondition: answers['known_condition'] as String?,
        specialConsiderations: answers['special_considerations'] is List
            ? List<String>.from(answers['special_considerations'] as List)
            : const [],
        medicationHistory: answers['medication_history'] as String?,
        familyHistory: answers['family_health_history'] as String?,
      ),
      lifestyleHabits: LifestyleHabits(
        sleepHours: (answers['sleep_hours'] as num?)?.toDouble(),
        activityLevel: answers['activity_level'] as String?,
        exerciseFrequency: answers['exercise_frequency'] as String?,
        stressLevel: answers['stress_level'] as String?,
        smokingAlcoholHabits: answers['smoking_alcohol_habit'] as String?,
      ),
      nutritionHabits: NutritionHabits(
        mealFrequency: answers['meal_frequency'] as String?,
        foodSensitivities: answers['food_sensitivities'] as String?,
        favoriteFoods: answers['favorite_foods'] as String?,
        avoidedFoods: answers['avoided_foods'] as String?,
        waterIntake: answers['water_intake'] as String?,
        pastDiets: answers['past_diet'] as String?,
      ),
    );
  }
}
