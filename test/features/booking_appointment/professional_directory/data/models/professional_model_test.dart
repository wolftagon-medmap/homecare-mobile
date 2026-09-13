import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/data/models/professional_model.dart';

/// `GET /v1/professionals/:id` spreads `professional.serialize()`, which Lucid
/// emits in camelCase, and then adds its own keys in snake_case. Both spellings
/// therefore arrive in one payload.
const _detailPayload = <String, dynamic>{
  'id': 7,
  'userId': 10,
  'role': 'physiotherapist',
  'name': 'Ryan Cheong',
  'countryCode': null,
  'avatar': null,
  'experience': 10,
  'rating': 4.9,
  'jobTitle': 'Physiotherapist',
  'createdAt': '2026-09-03T10:14:16.000+00:00',
  'updatedAt': '2026-09-03T10:20:07.000+00:00',
  'certificates': <dynamic>[],
  'services': <dynamic>[
    {
      'id': 28,
      'name': 'Musculoskeletal Physiotherapy - 45 Minutes Session',
      'category': 'physiotherapy',
      'subCategory': 'muskuloskeletal',
      'price': 25,
      'pricingModel': 'per_package',
      'detail': {'duration': 45},
      'isPublished': true,
      'proficiency_level': null,
    },
  ],
  'workplaceAddress': {
    'id': 5,
    'latitude': '1.31870000',
    'longitude': '103.84480000',
    'formattedAddress': null,
    'isDefault': false,
  },
  'working_hours': 'Mon–Fri 09:00–18:00',
  'completed_appointments_count': 3,
  'condition_experience': <dynamic>[],
  'languages': <dynamic>[],
  'care_style': <dynamic>[],
  'service_areas': <dynamic>[],
  'preference_highlights': <dynamic>['Day shift'],
};

void main() {
  group('ProfessionalModel.fromJson', () {
    test('reads the camelCase keys the API actually sends', () {
      final professional = ProfessionalModel.fromJson(_detailPayload);

      expect(professional.userId, 10);
      expect(professional.createdAt, '2026-09-03T10:14:16.000+00:00');
      expect(professional.jobTitle, 'Physiotherapist');
      expect(professional.services.single.subCategory, 'muskuloskeletal');
      expect(professional.services.single.pricingModel, 'per_package');
      expect(professional.workplaceAddress?.latitude, 1.3187);
    });

    test('still reads the snake_case keys the controller adds itself', () {
      final professional = ProfessionalModel.fromJson(_detailPayload);

      expect(professional.workingHours, 'Mon–Fri 09:00–18:00');
      expect(professional.completedAppointmentsCount, 3);
      expect(professional.preferenceHighlights, ['Day shift']);
    });
  });
}
