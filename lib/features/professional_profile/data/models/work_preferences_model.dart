import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';

class WorkPreferencesModel extends WorkPreferences {
  const WorkPreferencesModel({
    super.targetWeeklyHours,
    super.nightShift,
    super.weekendPublicHoliday,
    super.longTermClient,
    super.hospitalEscort,
    super.emergencyReplacement,
    super.clientGenderPreference,
    super.dementiaClients,
    super.palliativeClients,
    super.bedboundClients,
    super.liftTransfer,
    super.petFriendly,
    super.smokingHousehold,
  });

  factory WorkPreferencesModel.fromJson(Map<String, dynamic> json) {
    bool flag(String key) => json[key] == true;

    return WorkPreferencesModel(
      targetWeeklyHours: (json['target_weekly_hours'] as num?)?.toInt(),
      nightShift: flag('night_shift'),
      weekendPublicHoliday: flag('weekend_public_holiday'),
      longTermClient: flag('long_term_client'),
      hospitalEscort: flag('hospital_escort'),
      emergencyReplacement: flag('emergency_replacement'),
      clientGenderPreference: json['client_gender_preference'] as String? ??
          ClientGenderPreference.any,
      dementiaClients: flag('dementia_clients'),
      palliativeClients: flag('palliative_clients'),
      bedboundClients: flag('bedbound_clients'),
      liftTransfer: flag('lift_transfer'),
      petFriendly: flag('pet_friendly'),
      smokingHousehold: flag('smoking_household'),
    );
  }

  factory WorkPreferencesModel.fromEntity(WorkPreferences p) {
    return WorkPreferencesModel(
      targetWeeklyHours: p.targetWeeklyHours,
      nightShift: p.nightShift,
      weekendPublicHoliday: p.weekendPublicHoliday,
      longTermClient: p.longTermClient,
      hospitalEscort: p.hospitalEscort,
      emergencyReplacement: p.emergencyReplacement,
      clientGenderPreference: p.clientGenderPreference,
      dementiaClients: p.dementiaClients,
      palliativeClients: p.palliativeClients,
      bedboundClients: p.bedboundClients,
      liftTransfer: p.liftTransfer,
      petFriendly: p.petFriendly,
      smokingHousehold: p.smokingHousehold,
    );
  }

  /// The server validates every boolean as required, so all thirteen keys go
  /// on the wire whether or not they changed.
  Map<String, dynamic> toJson() => {
        'target_weekly_hours': targetWeeklyHours,
        'night_shift': nightShift,
        'weekend_public_holiday': weekendPublicHoliday,
        'long_term_client': longTermClient,
        'hospital_escort': hospitalEscort,
        'emergency_replacement': emergencyReplacement,
        'client_gender_preference': clientGenderPreference,
        'dementia_clients': dementiaClients,
        'palliative_clients': palliativeClients,
        'bedbound_clients': bedboundClients,
        'lift_transfer': liftTransfer,
        'pet_friendly': petFriendly,
        'smoking_household': smokingHousehold,
      };
}
