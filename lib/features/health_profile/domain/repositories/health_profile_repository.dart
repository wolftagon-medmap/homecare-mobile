import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

abstract class HealthProfileRepository {
  Future<Either<Failure, List<HealthSectionSummary>>> getSections(
      int? patientProfileId);

  Future<Either<Failure, HealthSection>> getSection(
      String code, int? patientProfileId);

  Future<Either<Failure, HealthSection>> saveSection({
    required String code,
    required Map<String, dynamic> answers,
    int? patientProfileId,
  });

  Future<Either<Failure, int>> uploadAttachment(String filePath);
}
