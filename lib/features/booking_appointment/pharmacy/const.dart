enum PharmacyCoachingTopic {
  weightManagement('weight_management', 'Weight Management'),
  diabetesManagement('diabetes_management', 'Diabetes Management'),
  bloodPressureManagement(
    'blood_pressure_management',
    'High Blood Pressure Management',
  ),
  cholesterolManagement(
    'cholesterol_management',
    'High Cholesterol Management',
  );

  const PharmacyCoachingTopic(this.code, this.label);

  final String code;
  final String label;

  static PharmacyCoachingTopic? fromCode(String? code) {
    for (final topic in PharmacyCoachingTopic.values) {
      if (topic.code == code) return topic;
    }
    return null;
  }
}

enum PharmacyServiceType {
  medicationReviewCounseling,
  smokingCessation;

  String get category => 'pharmacy';

  String get subCategory {
    switch (this) {
      case PharmacyServiceType.medicationReviewCounseling:
        return 'medication_review_counseling';
      case PharmacyServiceType.smokingCessation:
        return 'smoking_cessation';
    }
  }
}
