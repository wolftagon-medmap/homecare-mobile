import 'package:m2health/features/health_profile/data/models/health_profile_models.dart';

abstract class HealthProfileDataSource {
  Future<List<HealthSectionSummaryModel>> fetchSections(int? patientProfileId);

  Future<HealthSectionModel> fetchSection(String code, int? patientProfileId);

  Future<HealthSectionModel> saveSection({
    required String code,
    required Map<String, Object> answers,
    int? patientProfileId,
  });
}
