import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';
import 'package:m2health/features/health_profile/domain/repositories/health_profile_repository.dart';

Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
  try {
    return Right(await run());
  } on Failure catch (failure) {
    return Left(failure);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

class HealthProfileRepositoryImpl implements HealthProfileRepository {
  final HealthProfileDataSource dataSource;
  final HealthAttachmentDataSource attachments;

  HealthProfileRepositoryImpl(this.dataSource, this.attachments);

  @override
  Future<Either<Failure, List<HealthSectionSummary>>> getSections(
          int? patientProfileId) =>
      _guard(() => dataSource.fetchSections(patientProfileId));

  @override
  Future<Either<Failure, HealthSection>> getSection(
          String code, int? patientProfileId) =>
      _guard(() => dataSource.fetchSection(code, patientProfileId));

  @override
  Future<Either<Failure, HealthSection>> saveSection({
    required String code,
    required Map<String, dynamic> answers,
    int? patientProfileId,
  }) =>
      _guard(() => dataSource.saveSection(
            code: code,
            answers: answers,
            patientProfileId: patientProfileId,
          ));

  @override
  Future<Either<Failure, int>> uploadAttachment(String filePath) =>
      _guard(() => attachments.upload(filePath));
}
