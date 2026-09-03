import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/data/fixtures/health_profile_fixture.dart';
import 'package:m2health/features/health_profile/data/models/health_profile_models.dart';

const Duration _fixtureLatency = Duration(milliseconds: 250);

class HealthProfileLocalDataSource implements HealthProfileDataSource {
  final Map<int, Map<String, Map<String, dynamic>>> _answers = {};
  final Map<int, Map<String, DateTime>> _savedAt = {};

  static const int _noProfile = 0;

  @override
  Future<List<HealthSectionSummaryModel>> fetchSections(
      int? patientProfileId) async {
    await Future.delayed(_fixtureLatency);
    final saved = _savedAt[patientProfileId ?? _noProfile] ?? const {};

    return kHealthProfileSectionsFixture.map((section) {
      final code = section['code'] as String;
      return HealthSectionSummaryModel.fromJson({
        ...section,
        'question_count': (section['questions'] as List).length,
        'updated_at': saved[code]?.toIso8601String(),
      });
    }).toList();
  }

  @override
  Future<HealthSectionModel> fetchSection(
      String code, int? patientProfileId) async {
    await Future.delayed(_fixtureLatency);
    final json = _sectionJson(code);
    final key = patientProfileId ?? _noProfile;

    return HealthSectionModel.fromJson({
      ...json,
      'answers': _answers[key]?[code] ?? const <String, dynamic>{},
      'updated_at': _savedAt[key]?[code]?.toIso8601String(),
    });
  }

  @override
  Future<HealthSectionModel> saveSection({
    required String code,
    required Map<String, dynamic> answers,
    int? patientProfileId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final json = _sectionJson(code);
    final key = patientProfileId ?? _noProfile;
    final savedAt = DateTime.now();

    (_answers[key] ??= {})[code] = Map<String, dynamic>.from(answers);
    (_savedAt[key] ??= {})[code] = savedAt;

    return HealthSectionModel.fromJson({
      ...json,
      'answers': answers,
      'updated_at': savedAt.toIso8601String(),
    });
  }

  Map<String, dynamic> _sectionJson(String code) {
    for (final section in kHealthProfileSectionsFixture) {
      if (section['code'] == code) return section;
    }
    throw NotFoundFailure('No health profile section "$code"');
  }
}

class HealthAttachmentLocalDataSource implements HealthAttachmentDataSource {
  int _nextId = 1;

  @override
  Future<int> upload(String filePath) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _nextId++;
  }
}
