/// ADR 0006 makes scope a property of a category, so this belongs beside the
/// catalogue on the server. No endpoint serves it yet.
class ServiceCategoryCopy {
  const ServiceCategoryCopy._();

  /// What a visit in each category includes, whatever else is booked.
  static const Map<String, List<String>> scope = {
    'nursing': [
      'Vital signs',
      'Medication support',
      'Clinical documentation',
    ],
    'homecare_elderly': [
      'Personal hygiene',
      'Feeding assistance',
      'Toileting',
      'Companionship',
      'Family communication',
    ],
    'physiotherapy': [
      'Mobility assessment',
      'Exercise programme',
      'Progress notes',
    ],
  };

  static const Map<String, String> labels = {
    'nursing': 'Nursing',
    'homecare_elderly': 'Elderly homecare',
    'physiotherapy': 'Physiotherapy',
    'pharmacy': 'Pharmacy',
    'screening': 'Health screening',
    'nutrition': 'Nutrition',
    'psychology': 'Psychology',
    'optometry': 'Optometry',
    'second_opinion_imaging': 'Second opinion',
  };
}
