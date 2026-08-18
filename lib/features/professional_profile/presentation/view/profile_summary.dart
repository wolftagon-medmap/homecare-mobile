import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';

/// What the PRD calls Care DNA: the professional profile seen whole. It is a
/// view over fields other chapters own, so it lives here rather than as an
/// entity of its own.
class ProfileSummary {
  ProfileSummary._({
    required this.role,
    required this.languages,
    required this.conditions,
    required this.services,
    required this.styleTraits,
    required this.serviceAreas,
    required this.preferenceHighlights,
  });

  factory ProfileSummary.of(ProfessionalProfile profile) {
    return ProfileSummary._(
      role: profile.jobTitle ?? '',
      languages: _claimed(profile.languages),
      conditions: _claimed(profile.conditionExperience),
      services: _ratedServices(profile),
      styleTraits: [for (final t in profile.careStyle) t.label],
      serviceAreas: [for (final a in profile.serviceAreas) a.name],
      preferenceHighlights: _highlights(profile.workPreferences),
    );
  }

  final String role;
  final List<LeveledEntry> languages;
  final List<LeveledEntry> conditions;
  final List<LeveledEntry> services;
  final List<String> styleTraits;
  final List<String> serviceAreas;
  final List<String> preferenceHighlights;

  static const int totalChapters = 6;

  /// Deliberately separate from verification, which asks whether someone may
  /// work at all. This asks whether their profile is compelling enough to get
  /// chosen, so a fully licensed nurse can sit at two of six.
  int get completedChapters {
    var done = 0;
    if (languages.isNotEmpty) done++;
    if (conditions.isNotEmpty) done++;
    if (services.isNotEmpty) done++;
    if (styleTraits.isNotEmpty) done++;
    if (serviceAreas.isNotEmpty) done++;
    if (preferenceHighlights.isNotEmpty) done++;
    return done;
  }

  /// The PRD's summary line, e.g.
  /// `RN | Mandarin L5 | Dementia E4 | Wound Care S4 | Proactive | Day Shift`.
  List<String> summaryChips({int perCategory = 2}) => [
        if (role.isNotEmpty) role,
        ...languages.take(perCategory).map((e) => e.badge(LevelScale.language)),
        ...conditions
            .take(perCategory)
            .map((e) => e.badge(LevelScale.experience)),
        ...services
            .take(perCategory)
            .map((e) => e.badge(LevelScale.proficiency)),
        ...styleTraits.take(1),
        ...serviceAreas.take(1),
        ...preferenceHighlights.take(1),
      ];

  static List<LeveledEntry> _claimed(List<LeveledEntry> all) {
    final claimed = all.where((e) => e.isClaimed).toList()
      ..sort((a, b) => b.level.compareTo(a.level));
    return claimed;
  }

  static List<LeveledEntry> _ratedServices(ProfessionalProfile profile) {
    final rated = [
      for (final service in profile.providedServices)
        if (profile.serviceProficiency[service.id] != null)
          LeveledEntry(
            code: '${service.id}',
            label: service.name,
            level: profile.serviceProficiency[service.id]!,
          ),
    ]..sort((a, b) => b.level.compareTo(a.level));
    return rated;
  }

  /// F10 moves this rule to the server so the patient view and this preview
  /// cannot drift apart.
  static List<String> _highlights(WorkPreferences p) => [
        if (p.longTermClient) 'Long-term clients',
        if (p.hospitalEscort) 'Hospital escort',
        if (p.emergencyReplacement) 'Emergency cover',
        if (p.nightShift) 'Night shift' else 'Day shift',
        if (p.weekendPublicHoliday) 'Weekends & holidays',
        if (p.petFriendly) 'Pet-friendly',
      ];
}
