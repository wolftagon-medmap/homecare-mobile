import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';

/// The account holder's own profile plus any family members they book for.
class GetProfiles {
  ProfileRepository repository;

  GetProfiles(this.repository);

  Future<Either<Failure, List<Profile>>> call() async {
    return await repository.getProfiles();
  }
}
