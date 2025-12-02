import 'package:m2health/features/profiles/domain/entities/mental_health_state.dart';

class MentalHealthStateModel extends MentalHealthState {
  MentalHealthStateModel({
    required super.id,
    required super.userId,
    super.overallMood,
    super.anxietyLevel,
    super.stressLevel,
    super.energyLevel,
    super.focusLevel,
    super.sleepQuality,
    super.note,
    super.createdAt,
    super.updatedAt,
  });

  factory MentalHealthStateModel.fromJson(Map<String, dynamic> json) {
    return MentalHealthStateModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      overallMood: json['overall_mood'],
      anxietyLevel: json['anxiety_level'],
      stressLevel: json['stress_level'],
      energyLevel: json['energy_level'],
      focusLevel: json['focus_level'],
      sleepQuality: json['sleep_quality'],
      note: json['note'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'overall_mood': overallMood,
      'anxiety_level': anxietyLevel,
      'stress_level': stressLevel,
      'energy_level': energyLevel,
      'focus_level': focusLevel,
      'sleep_quality': sleepQuality,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory MentalHealthStateModel.fromEntity(MentalHealthState entity) {
    return MentalHealthStateModel(
      id: entity.id,
      userId: entity.userId,
      overallMood: entity.overallMood,
      anxietyLevel: entity.anxietyLevel,
      stressLevel: entity.stressLevel,
      energyLevel: entity.energyLevel,
      focusLevel: entity.focusLevel,
      sleepQuality: entity.sleepQuality,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
