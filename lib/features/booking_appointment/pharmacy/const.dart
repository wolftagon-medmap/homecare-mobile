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
