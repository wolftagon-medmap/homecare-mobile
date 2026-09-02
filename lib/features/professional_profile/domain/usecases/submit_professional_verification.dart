import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';

class SubmitProfessionalVerification {
  final ProfessionalProfileRepository repository;

  SubmitProfessionalVerification(this.repository);

  Future<Either<Failure, ProfessionalProfile>> call() async {
    return await repository.submitProfessionalVerification();
  }
}
