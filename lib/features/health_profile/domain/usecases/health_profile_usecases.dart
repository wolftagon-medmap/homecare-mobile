import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';
import 'package:m2health/features/health_profile/domain/repositories/health_profile_repository.dart';

class GetHealthSections {
  final HealthProfileRepository repository;

  GetHealthSections(this.repository);

  Future<Either<Failure, List<HealthSectionSummary>>> call(
          int? patientProfileId) =>
      repository.getSections(patientProfileId);
}

class GetHealthSection {
  final HealthProfileRepository repository;

  GetHealthSection(this.repository);

  Future<Either<Failure, HealthSection>> call(
          String code, int? patientProfileId) =>
      repository.getSection(code, patientProfileId);
}

class SaveHealthSection {
  final HealthProfileRepository repository;

  SaveHealthSection(this.repository);

  Future<Either<Failure, HealthSection>> call({
    required String code,
    required Map<String, dynamic> answers,
    int? patientProfileId,
  }) =>
      repository.saveSection(
        code: code,
        answers: answers,
        patientProfileId: patientProfileId,
      );
}

class UploadHealthAttachment {
  final HealthProfileRepository repository;

  UploadHealthAttachment(this.repository);

  Future<Either<Failure, int>> call(String filePath) =>
      repository.uploadAttachment(filePath);
}
