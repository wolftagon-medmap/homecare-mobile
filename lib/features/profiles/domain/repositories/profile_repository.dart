import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/mental_health_state.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';

abstract class ProfileRepository {
  /// The account holder's own profile plus any family members, primary first.
  Future<Either<Failure, List<Profile>>> getProfiles();
  /// Returns the created profile so callers can make it active.
  Future<Either<Failure, Profile>> create(CreateProfileParams profile);
  Future<Either<Failure, Unit>> update(UpdateProfileParams profile);
  Future<Either<Failure, Unit>> delete(int profileId);
  Future<Either<Failure, ProfessionalProfile>> getProfessionalProfile();
  Future<Either<Failure, Unit>> updateProfessionalProfile(
      UpdateProfessionalProfileParams params);
  Future<Either<Failure, ProfessionalProfile>> submitProfessionalVerification();

  // Mental Health
  Future<Either<Failure, MentalHealthState>> getMentalHealthState();
  Future<Either<Failure, Unit>> updateMentalHealthState(
      MentalHealthState state);
}
