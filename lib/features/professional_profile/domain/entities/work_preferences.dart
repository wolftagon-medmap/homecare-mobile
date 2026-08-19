import 'package:equatable/equatable.dart';

/// What the server accepts for `client_gender_preference`.
class ClientGenderPreference {
  const ClientGenderPreference._();

  static const String any = 'any';
  static const String female = 'female';
  static const String male = 'male';

  static const List<String> values = [any, female, male];
}

/// Captured and displayed only. Nothing here filters or scores yet, by
/// decision, and the preferences screen says so on itself.
class WorkPreferences extends Equatable {
  const WorkPreferences({
    this.targetWeeklyHours,
    this.nightShift = false,
    this.weekendPublicHoliday = false,
    this.longTermClient = false,
    this.hospitalEscort = false,
    this.emergencyReplacement = false,
    this.clientGenderPreference = ClientGenderPreference.any,
    this.dementiaClients = false,
    this.palliativeClients = false,
    this.bedboundClients = false,
    this.liftTransfer = false,
    this.petFriendly = false,
    this.smokingHousehold = false,
  });

  /// Null means the professional has not said. Distinct from zero.
  final int? targetWeeklyHours;
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
    bool clearTargetWeeklyHours = false,
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
        targetWeeklyHours: clearTargetWeeklyHours
            ? null
            : targetWeeklyHours ?? this.targetWeeklyHours,
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

  @override
  List<Object?> get props => [
        targetWeeklyHours,
        nightShift,
        weekendPublicHoliday,
        longTermClient,
        hospitalEscort,
        emergencyReplacement,
        clientGenderPreference,
        dementiaClients,
        palliativeClients,
        bedboundClients,
        liftTransfer,
        petFriendly,
        smokingHousehold,
      ];
}
