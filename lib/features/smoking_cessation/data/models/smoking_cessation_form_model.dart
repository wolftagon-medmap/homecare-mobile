import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_form.dart';

class SmokingCessationFormModel extends SmokingCessationForm {
  const SmokingCessationFormModel({
    required super.isSmoking,
    super.productTypes,
    super.sticksPerDay,
    required super.hasTriedQuitting,
  });

  factory SmokingCessationFormModel.fromJson(Map<String, dynamic> json) {
    return SmokingCessationFormModel(
      isSmoking: json['is_smoking'] ?? false,
      productTypes: json['product_types'] != null
          ? List<String>.from(json['product_types'])
          : null,
      sticksPerDay: json['sticks_per_day'],
      hasTriedQuitting: json['has_tried_quitting'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_smoking': isSmoking,
      'product_types': productTypes,
      'sticks_per_day': sticksPerDay,
      'has_tried_quitting': hasTriedQuitting,
    };
  }

  factory SmokingCessationFormModel.fromEntity(SmokingCessationForm entity) {
    return SmokingCessationFormModel(
      isSmoking: entity.isSmoking,
      productTypes: entity.productTypes,
      sticksPerDay: entity.sticksPerDay,
      hasTriedQuitting: entity.hasTriedQuitting,
    );
  }
}
