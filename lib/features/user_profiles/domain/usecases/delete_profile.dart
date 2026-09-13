import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/user_profiles/domain/repositories/profile_repository.dart';

/// Removes a family member. The backend refuses the account holder's own
/// profile, and the UI hides the button for it.
class DeleteProfile {
  ProfileRepository repository;

  DeleteProfile(this.repository);

  Future<Either<Failure, Unit>> call(int profileId) async {
    return await repository.delete(profileId);
  }
}
