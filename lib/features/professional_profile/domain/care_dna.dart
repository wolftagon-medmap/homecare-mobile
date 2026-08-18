/// Prototype domain model for the Professional Care DNA.
///
/// Disposable: this is demo scaffolding with no repository or API behind it.
/// The level scales come from the PRD (L0-L5 languages, E0-E5 condition
/// experience, S0-S5 for what the PRD called skills). The PRD never defines what
/// 1-4 mean, so the word labels here are a proposal, not a spec.
///
/// There is no skills catalogue: competence is a level on a service the
/// professional already offers. See ADR 0006 in the backend repository.
library;

enum LevelScale { language, experience, proficiency }

extension LevelScaleX on LevelScale {
  /// Single-letter prefix shown in a chip, e.g. the `E` in `Dementia E4`.
  /// Proficiency keeps `S` for service, which is what the PRD's own example
  /// line uses (`Wound Care S4`).
  String get prefix => switch (this) {
        LevelScale.language => 'L',
        LevelScale.experience => 'E',
        LevelScale.proficiency => 'S',
      };

  String labelFor(int level) {
    if (level <= 0) return 'None';
    if (this == LevelScale.language) {
      return const [
        'Basic',
        'Elementary',
        'Conversational',
        'Fluent',
        'Native'
      ][level - 1];
    }
    return const [
      'Some exposure',
      'Basic',
      'Competent',
      'Experienced',
      'Expert'
    ][level - 1];
  }
}

/// One catalogue entry the professional may claim, at a level of 0-5.
class LeveledTag {
  const LeveledTag({
    required this.id,
    required this.label,
    this.group,
    this.level = 0,
  });

  final String id;
  final String label;

  /// Category heading, e.g. 'Clinical Nursing'. Null for flat catalogues.
  final String? group;

  /// 0 means not claimed. Anything above 0 puts it on the public profile.
  final int level;

  bool get isClaimed => level > 0;

  LeveledTag copyWith({int? level}) => LeveledTag(
        id: id,
        label: label,
        group: group,
        level: level ?? this.level,
      );

  /// Compact form for a chip: `Dementia E4`.
  String badge(LevelScale scale) => '$label ${scale.prefix}$level';
}

/// Client-type and shift preferences (PRD section 8).
///
/// Stored and displayed only — nothing scores off these yet, by decision.
class WorkPreferences {
  const WorkPreferences({
    this.targetWeeklyHours = 30,
    this.maxTravelMinutes = 45,
    this.nightShift = false,
    this.weekendPublicHoliday = true,
    this.longTermClient = true,
    this.hospitalEscort = false,
    this.emergencyReplacement = false,
    this.clientGenderPreference = 'No preference',
    this.dementiaClients = true,
    this.palliativeClients = false,
    this.bedboundClients = true,
    this.liftTransfer = true,
    this.petFriendly = true,
    this.smokingHousehold = false,
  });

  final int targetWeeklyHours;
  final int maxTravelMinutes;
  final bool nightShift;
  final bool weekendPublicHoliday;
  final bool longTermClient;
  final bool hospitalEscort;
  final bool emergencyReplacement;
  final String clientGenderPreference;
  final bool dementiaClients;
  final bool palliativeClients;
  final bool bedboundClients;
  final bool liftTransfer;
  final bool petFriendly;
  final bool smokingHousehold;

  WorkPreferences copyWith({
    int? targetWeeklyHours,
    int? maxTravelMinutes,
    bool? nightShift,
    bool? weekendPublicHoliday,
    bool? longTermClient,
    bool? hospitalEscort,
    bool? emergencyReplacement,
    String? clientGenderPreference,
    bool? dementiaClients,
    bool? palliativeClients,
    bool? bedboundClients,
    bool? liftTransfer,
    bool? petFriendly,
    bool? smokingHousehold,
  }) =>
      WorkPreferences(
        targetWeeklyHours: targetWeeklyHours ?? this.targetWeeklyHours,
        maxTravelMinutes: maxTravelMinutes ?? this.maxTravelMinutes,
        nightShift: nightShift ?? this.nightShift,
        weekendPublicHoliday: weekendPublicHoliday ?? this.weekendPublicHoliday,
        longTermClient: longTermClient ?? this.longTermClient,
        hospitalEscort: hospitalEscort ?? this.hospitalEscort,
        emergencyReplacement: emergencyReplacement ?? this.emergencyReplacement,
        clientGenderPreference:
            clientGenderPreference ?? this.clientGenderPreference,
        dementiaClients: dementiaClients ?? this.dementiaClients,
        palliativeClients: palliativeClients ?? this.palliativeClients,
        bedboundClients: bedboundClients ?? this.bedboundClients,
        liftTransfer: liftTransfer ?? this.liftTransfer,
        petFriendly: petFriendly ?? this.petFriendly,
        smokingHousehold: smokingHousehold ?? this.smokingHousehold,
      );

  /// The preference highlights worth putting on a public profile.
  List<String> get publicHighlights => [
        if (longTermClient) 'Long-term clients',
        if (hospitalEscort) 'Hospital escort',
        if (emergencyReplacement) 'Emergency cover',
        if (nightShift) 'Night shift' else 'Day shift',
        if (weekendPublicHoliday) 'Weekends & holidays',
        if (petFriendly) 'Pet-friendly',
      ];
}

/// PRD section 3 identity fields the backend has no column for yet, held here
/// so the prototype shows the whole profile the PRD describes.
class EmergencyContact {
  const EmergencyContact(
      {this.name = '', this.relationship = '', this.phone = ''});

  final String name;
  final String relationship;
  final String phone;

  bool get isSet => name.isNotEmpty && phone.isNotEmpty;

  EmergencyContact copyWith(
          {String? name, String? relationship, String? phone}) =>
      EmergencyContact(
        name: name ?? this.name,
        relationship: relationship ?? this.relationship,
        phone: phone ?? this.phone,
      );
}

/// Everything the PRD calls "Care DNA", which is a view over these fields
/// rather than a record of its own.
class CareDnaProfile {
  const CareDnaProfile({
    required this.role,
    required this.languages,
    required this.conditions,
    required this.serviceExpertise,
    required this.styleTraits,
    required this.preferences,
    required this.serviceAreas,
    this.gender = '',
    this.residentialArea = '',
    this.emergencyContact = const EmergencyContact(),
  });

  final String role;
  final List<LeveledTag> languages;
  final List<LeveledTag> conditions;

  /// Proficiency per service the professional offers, keyed by service id.
  /// Populated from the real service list rather than a catalogue of its own.
  final List<LeveledTag> serviceExpertise;

  final List<String> styleTraits;
  final WorkPreferences preferences;
  final List<String> serviceAreas;
  final String gender;
  final String residentialArea;
  final EmergencyContact emergencyContact;

  List<LeveledTag> get claimedLanguages => _claimed(languages);
  List<LeveledTag> get claimedConditions => _claimed(conditions);
  List<LeveledTag> get ratedServices => _claimed(serviceExpertise);

  static List<LeveledTag> _claimed(List<LeveledTag> all) {
    final claimed = all.where((t) => t.isClaimed).toList()
      ..sort((a, b) => b.level.compareTo(a.level));
    return claimed;
  }

  /// The six chapters that make a profile feel complete. Deliberately separate
  /// from verification, which asks a different question: verification is about
  /// whether someone may work at all, this is about whether their profile is
  /// compelling enough to get picked.
  int get completedChapters {
    var done = 0;
    if (claimedLanguages.isNotEmpty) done++;
    if (claimedConditions.isNotEmpty) done++;
    if (ratedServices.isNotEmpty) done++;
    if (styleTraits.isNotEmpty) done++;
    if (serviceAreas.isNotEmpty) done++;
    if (preferences.publicHighlights.isNotEmpty) done++;
    return done;
  }

  static const int totalChapters = 6;

  /// The PRD's summary line, e.g.
  /// `RN | Mandarin L5 | Dementia E4 | Wound Care S4 | Proactive | Day Shift`.
  List<String> summaryChips({int perCategory = 2}) => [
        role,
        ...claimedLanguages
            .take(perCategory)
            .map((t) => t.badge(LevelScale.language)),
        ...claimedConditions
            .take(perCategory)
            .map((t) => t.badge(LevelScale.experience)),
        ...ratedServices
            .take(perCategory)
            .map((t) => t.badge(LevelScale.proficiency)),
        ...styleTraits.take(1),
        ...serviceAreas.take(1),
        ...preferences.publicHighlights.take(1),
      ];

  CareDnaProfile copyWith({
    List<LeveledTag>? languages,
    List<LeveledTag>? conditions,
    List<LeveledTag>? serviceExpertise,
    List<String>? styleTraits,
    WorkPreferences? preferences,
    List<String>? serviceAreas,
    String? gender,
    String? residentialArea,
    EmergencyContact? emergencyContact,
  }) =>
      CareDnaProfile(
        role: role,
        languages: languages ?? this.languages,
        conditions: conditions ?? this.conditions,
        serviceExpertise: serviceExpertise ?? this.serviceExpertise,
        styleTraits: styleTraits ?? this.styleTraits,
        preferences: preferences ?? this.preferences,
        serviceAreas: serviceAreas ?? this.serviceAreas,
        gender: gender ?? this.gender,
        residentialArea: residentialArea ?? this.residentialArea,
        emergencyContact: emergencyContact ?? this.emergencyContact,
      );
}
