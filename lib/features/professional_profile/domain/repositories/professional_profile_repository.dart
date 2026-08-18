import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';

abstract class ProfessionalProfileRepository {
  Future<Either<Failure, ProfessionalProfile>> getProfessionalProfile();
  Future<Either<Failure, Unit>> updateProfessionalProfile(
      UpdateProfessionalProfileParams params);
  Future<Either<Failure, ProfessionalProfile>> submitProfessionalVerification();
}
