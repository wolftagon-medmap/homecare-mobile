import 'package:m2health/features/professional_profile/domain/care_dna.dart';

/// The catalogues the PRD defines that are genuinely their own.
///
/// The PRD's "Clinical & Service Skills" list is deliberately absent. Per ADR
/// 0006 its procedural entries are services the professional already offers and
/// are rated there, and its Daily Care entries describe what a visit includes,
/// which is [serviceScope] below.
class CareDnaCatalog {
  const CareDnaCatalog._();

  /// PRD section 4.
  static const List<LeveledTag> languages = [
    LeveledTag(id: 'en', label: 'English'),
    LeveledTag(id: 'zh', label: 'Mandarin'),
    LeveledTag(id: 'yue', label: 'Cantonese'),
    LeveledTag(id: 'nan', label: 'Hokkien'),
    LeveledTag(id: 'ms', label: 'Malay'),
    LeveledTag(id: 'ta', label: 'Tamil'),
    LeveledTag(id: 'other', label: 'Others'),
  ];

  /// PRD section 5.
  static const List<LeveledTag> conditions = [
    LeveledTag(id: 'dementia', label: 'Dementia'),
    LeveledTag(id: 'stroke', label: 'Stroke'),
    LeveledTag(id: 'parkinsons', label: "Parkinson's Disease"),
    LeveledTag(id: 'palliative', label: 'Palliative Care'),
    LeveledTag(id: 'diabetes', label: 'Diabetes'),
    LeveledTag(id: 'post_op', label: 'Post-operative Recovery'),
    LeveledTag(id: 'frailty', label: 'Frailty'),
    LeveledTag(id: 'bedbound', label: 'Bedbound Client'),
    LeveledTag(id: 'chronic_pain', label: 'Chronic Pain'),
    LeveledTag(id: 'mental_health', label: 'Mental Health'),
    LeveledTag(id: 'cancer', label: 'Cancer Care'),
    LeveledTag(id: 'ortho_rehab', label: 'Orthopedic Rehabilitation'),
    LeveledTag(id: 'fall_prevention', label: 'Fall Prevention'),
  ];

  /// PRD section 7. Unleveled — these are claimed, not rated, because nothing
  /// scores off them yet and self-rating "Empathy 5/5" reads as noise.
  static const List<String> styleTraits = [
    'Patience',
    'Communication',
    'Empathy',
    'Initiative',
    'Family Communication',
    'Companionship',
    'Dementia Communication',
    'Behavior Management',
    'Documentation Quality',
    'Cultural Sensitivity',
  ];

  /// Admin-level-2 regions. Indonesian kabupaten/kota granularity, which is the
  /// agreed target tier; the real list gets seeded from the shared dataset.
  static const List<String> serviceAreas = [
    'Jakarta Selatan',
    'Jakarta Pusat',
    'Jakarta Barat',
    'Jakarta Timur',
    'Jakarta Utara',
    'Kota Depok',
    'Kota Bekasi',
    'Kota Tangerang',
    'Kota Tangerang Selatan',
    'Kota Bogor',
  ];

  static const List<String> genderPreferences = [
    'No preference',
    'Female clients only',
    'Male clients only',
  ];
}
