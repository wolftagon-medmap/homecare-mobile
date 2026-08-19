import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/professional_profile/data/models/professional_profile_model.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';

/// Built by hand from the shape `GET /v1/professionals/my-profile` assembles in
/// ProfessionalController. The migrations have not run yet, so this is not a
/// captured response.
Map<String, dynamic> _payload() => {
      'id': 7,
      'user_id': 42,
      'name': 'Siti Rahmawati',
      'country_code': 'sg',
      'gender': 'Female',
      'job_title': 'Registered Nurse',
      'is_verified': true,
      'verification_status': 'verified',
      'service_radius_preference': 25,
      'working_hours': 'Mon–Fri 09:00–17:00',
      'services': [
        {'id': 3, 'name': 'Wound Care', 'price': 40, 'proficiency_level': 4},
        {'id': 9, 'name': 'Injection', 'price': 10, 'proficiency_level': null},
      ],
      'condition_experience': [
        {'code': 'dementia', 'label': 'Dementia', 'level': 4},
        {'code': 'stroke', 'label': 'Stroke', 'level': 3},
      ],
      'languages': [
        {'code': 'en', 'label': 'English', 'level': 5},
      ],
      'care_style': [
        {'code': 'patience', 'label': 'Patience'},
      ],
      'work_preferences': {
        'target_weekly_hours': 30,
        'night_shift': true,
        'weekend_public_holiday': false,
        'long_term_client': true,
        'hospital_escort': false,
        'emergency_replacement': false,
        'client_gender_preference': 'female',
        'dementia_clients': true,
        'palliative_clients': false,
        'bedbound_clients': false,
        'lift_transfer': false,
        'pet_friendly': true,
        'smoking_household': false,
      },
      'service_areas': [
        {'code': 'BM', 'name': 'Bukit Merah', 'parent_name': 'Central Region'},
      ],
      'residential_area': {
        'code': 'QT',
        'name': 'Queenstown',
        'parent_name': 'Central Region',
      },
      'emergency_contact': {
        'name': 'Budi',
        'relationship': 'Spouse',
        'phone': '+6591234567',
      },
    };

void main() {
  group('ProfessionalProfileModel.fromJson', () {
    test('reads the expertise lists', () {
      final profile = ProfessionalProfileModel.fromJson(_payload());

      expect(profile.conditionExperience.length, 2);
      expect(profile.conditionExperience.first.code, 'dementia');
      expect(profile.conditionExperience.first.level, 4);
      expect(profile.languages.single.label, 'English');
      expect(profile.careStyle.single.code, 'patience');
    });

    test('reads work preferences from snake_case', () {
      final prefs =
          ProfessionalProfileModel.fromJson(_payload()).workPreferences;

      expect(prefs.targetWeeklyHours, 30);
      expect(prefs.nightShift, isTrue);
      expect(prefs.weekendPublicHoliday, isFalse);
      expect(prefs.clientGenderPreference, ClientGenderPreference.female);
      expect(prefs.petFriendly, isTrue);
    });

    test('reads areas and the emergency contact', () {
      final profile = ProfessionalProfileModel.fromJson(_payload());

      expect(profile.serviceAreas.single.code, 'BM');
      expect(profile.serviceAreas.single.parentName, 'Central Region');
      expect(profile.residentialArea?.name, 'Queenstown');
      expect(profile.emergencyContact.phone, '+6591234567');
      expect(profile.emergencyContact.isSet, isTrue);
    });

    test('keys proficiency by service id and skips unrated services', () {
      final profile = ProfessionalProfileModel.fromJson(_payload());

      expect(profile.serviceProficiency, {3: 4});
      expect(profile.providedServices.length, 2);
    });

    test('falls back to empty values when the new keys are absent', () {
      final profile = ProfessionalProfileModel.fromJson(const {
        'id': 1,
        'user_id': 2,
        'name': 'Nobody',
      });

      expect(profile.conditionExperience, isEmpty);
      expect(profile.languages, isEmpty);
      expect(profile.careStyle, isEmpty);
      expect(profile.serviceAreas, isEmpty);
      expect(profile.residentialArea, isNull);
      expect(profile.serviceProficiency, isEmpty);
      expect(profile.emergencyContact.isSet, isFalse);
      expect(profile.workPreferences.targetWeeklyHours, isNull);
      expect(profile.workPreferences.nightShift, isFalse);
      expect(profile.workPreferences.clientGenderPreference,
          ClientGenderPreference.any);
    });
  });
}
