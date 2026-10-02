import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/data/models/health_profile_models.dart';

/// Section JSON shaped like contract C3, trimmed to what the tests need.
Map<String, dynamic> myHealthJson({Map<String, dynamic> answers = const {}}) =>
    {
      'code': 'my_health',
      'title': 'My Health',
      'opens_route': null,
      'updated_at': answers.isEmpty ? null : '2026-09-28T03:00:00.000Z',
      'questions': [
        {
          'code': 'conditions',
          'text': 'Do you have any of the following conditions?',
          'type': 'multi_choice',
          'allows_custom': true,
          'custom_label': 'Add another condition',
          'options': [
            {'code': 'high_blood_pressure', 'label': 'High Blood Pressure'},
            {'code': 'diabetes', 'label': 'Diabetes'},
            {
              'code': 'no_known_conditions',
              'label': "I don't have any known conditions",
              'exclusive': true,
            },
            {'code': 'not_sure', 'label': "I'm not sure", 'exclusive': true},
          ],
        },
        {
          'code': 'notes',
          'text': "Anything else you'd like to add?",
          'type': 'long_text',
          'hint': 'Optional.',
        },
      ],
      'answers': answers,
    };

Map<String, dynamic> myLifestyleJson(
        {Map<String, dynamic> answers = const {}}) =>
    {
      'code': 'my_lifestyle',
      'title': 'My Lifestyle',
      'opens_route': null,
      'updated_at': null,
      'questions': [
        {
          'code': 'smoke_or_vape',
          'text': 'Do you currently smoke or vape?',
          'type': 'single_choice',
          'options': [
            {'code': 'no', 'label': 'No'},
            {'code': 'daily', 'label': 'Daily'},
          ],
        },
        {
          'code': 'cigarettes_per_day',
          'text': 'How many cigarettes do you typically smoke per day?',
          'type': 'single_choice',
          'layout': 'chips',
          'enable_when': {
            'question': 'smoke_or_vape',
            'not_in': ['no'],
          },
          'options': [
            {'code': '1_5', 'label': '1–5 sticks'},
            {'code': '6_10', 'label': '6–10 sticks'},
          ],
        },
        {
          'code': 'activities',
          'text': 'What activities do you usually do?',
          'type': 'multi_choice',
          'layout': 'grid',
          'group': 'Exercise',
          'allows_custom': true,
          'custom_label': 'Other',
          'options': [
            {'code': 'walking', 'label': 'Walking', 'icon': 'walk'},
            {'code': 'gym', 'label': 'Gym', 'icon': 'gym'},
          ],
        },
        {
          'code': 'diet',
          'text': 'How would you describe your usual diet?',
          'type': 'single_choice',
          'group': 'Exercise',
          'allows_custom': true,
          'custom_label': 'Others',
          'options': [
            {'code': 'mostly_balanced', 'label': 'Mostly balanced'},
          ],
        },
      ],
      'answers': answers,
    };

class FakeHealthProfileDataSource implements HealthProfileDataSource {
  FakeHealthProfileDataSource({
    List<Map<String, dynamic>>? sections,
    Map<String, Map<String, dynamic>>? sectionJson,
  })  : sections = sections ?? const [],
        sectionJson = sectionJson ?? {};

  final List<Map<String, dynamic>> sections;
  final Map<String, Map<String, dynamic>> sectionJson;
  Failure? failNext;
  Map<String, Object>? lastSaved;
  int? lastProfileId;

  @override
  Future<List<HealthSectionSummaryModel>> fetchSections(
      int? patientProfileId) async {
    lastProfileId = patientProfileId;
    _throwIfFailing();
    return sections.map(HealthSectionSummaryModel.fromJson).toList();
  }

  @override
  Future<HealthSectionModel> fetchSection(
      String code, int? patientProfileId) async {
    lastProfileId = patientProfileId;
    _throwIfFailing();
    return HealthSectionModel.fromJson(sectionJson[code]!);
  }

  @override
  Future<HealthSectionModel> saveSection({
    required String code,
    required Map<String, Object> answers,
    int? patientProfileId,
  }) async {
    lastProfileId = patientProfileId;
    _throwIfFailing();
    lastSaved = answers;
    return HealthSectionModel.fromJson({
      ...sectionJson[code]!,
      'answers': answers,
      'updated_at': '2026-10-02T03:00:00.000Z',
    });
  }

  void _throwIfFailing() {
    final failure = failNext;
    failNext = null;
    if (failure != null) throw failure;
  }
}
