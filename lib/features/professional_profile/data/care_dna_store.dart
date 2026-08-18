import 'package:flutter/foundation.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/professional_profile/data/care_dna_catalog.dart';
import 'package:m2health/features/professional_profile/domain/care_dna.dart';

/// In-memory store for the prototype.
///
/// Deliberately not a Cubit and not registered with get_it: this is throwaway
/// demo state, and keeping it out of the DI graph makes it trivial to delete.
/// It is seeded part-filled so the demo opens on a profile that already has
/// something to show but visibly has room to grow.
class CareDnaStore extends ValueNotifier<CareDnaProfile> {
  CareDnaStore._() : super(_seed());

  static final CareDnaStore instance = CareDnaStore._();

  static CareDnaProfile _seed() {
    return CareDnaProfile(
      role: 'Registered Nurse',
      languages: _withLevels(CareDnaCatalog.languages, {
        'en': 4,
        'zh': 5,
        'nan': 3,
      }),
      conditions: _withLevels(CareDnaCatalog.conditions, {
        'dementia': 4,
        'stroke': 4,
        'diabetes': 3,
      }),
      serviceExpertise: const [],
      styleTraits: const ['Patience', 'Family Communication'],
      preferences: const WorkPreferences(),
      serviceAreas: const ['Jakarta Selatan', 'Jakarta Pusat'],
    );
  }

  static List<LeveledTag> _withLevels(
      List<LeveledTag> catalog, Map<String, int> levels) {
    return catalog.map((t) => t.copyWith(level: levels[t.id] ?? 0)).toList();
  }

  /// Bring the proficiency list in line with the services the professional
  /// actually offers, keeping any level already set. There is no skills
  /// catalogue to fall back on, so this is the only source of what can be rated.
  void syncServices(List<ServiceEntity> services) {
    final existing = {for (final t in value.serviceExpertise) t.id: t.level};
    final next = [
      for (final s in services)
        LeveledTag(
          id: '${s.id}',
          label: s.name,
          group: s.category,
          level: existing['${s.id}'] ?? 0,
        ),
    ];

    final unchanged = next.length == value.serviceExpertise.length &&
        next.every((t) => existing[t.id] == t.level);
    if (unchanged) return;

    value = value.copyWith(serviceExpertise: next);
  }

  void setGender(String v) => value = value.copyWith(gender: v);
  void setResidentialArea(String v) =>
      value = value.copyWith(residentialArea: v);
  void setEmergencyContact(EmergencyContact v) =>
      value = value.copyWith(emergencyContact: v);

  void setLanguages(List<LeveledTag> next) =>
      value = value.copyWith(languages: next);
  void setConditions(List<LeveledTag> next) =>
      value = value.copyWith(conditions: next);
  void setServiceExpertise(List<LeveledTag> next) =>
      value = value.copyWith(serviceExpertise: next);
  void setStyleTraits(List<String> next) =>
      value = value.copyWith(styleTraits: next);
  void setPreferences(WorkPreferences next) =>
      value = value.copyWith(preferences: next);
  void setServiceAreas(List<String> next) =>
      value = value.copyWith(serviceAreas: next);
}
