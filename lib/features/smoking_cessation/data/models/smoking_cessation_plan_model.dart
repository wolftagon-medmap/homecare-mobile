import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_plan.dart';

class SmokingCessationPlanModel extends SmokingCessationPlan {
  const SmokingCessationPlanModel({
    super.targetQuitDate,
    super.medicationName,
    super.medicationInstructions,
    super.adviceNote,
    super.followUpDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'target_quit_date': targetQuitDate?.toIso8601String().split('T').first,
      'medication_name': medicationName,
      'medication_instructions': medicationInstructions,
      'advice_note': adviceNote,
      'follow_up_date': followUpDate?.toIso8601String().split('T').first,
    };
  }

  factory SmokingCessationPlanModel.fromJson(Map<String, dynamic> json) {
    return SmokingCessationPlanModel(
      targetQuitDate: json['target_quit_date'] != null
          ? DateTime.parse(json['target_quit_date'])
          : null,
      medicationName: json['medication_name'],
      medicationInstructions: json['medication_instructions'],
      adviceNote: json['advice_note'],
      followUpDate: json['follow_up_date'] != null
          ? DateTime.parse(json['follow_up_date'])
          : null,
    );
  }

  factory SmokingCessationPlanModel.fromEntity(SmokingCessationPlan entity) {
    return SmokingCessationPlanModel(
      targetQuitDate: entity.targetQuitDate,
      medicationName: entity.medicationName,
      medicationInstructions: entity.medicationInstructions,
      adviceNote: entity.adviceNote,
      followUpDate: entity.followUpDate,
    );
  }
}
