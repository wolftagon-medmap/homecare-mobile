import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/user_profiles/domain/entities/profile.dart';
import 'package:m2health/features/user_profiles/domain/repositories/profile_repository.dart';

/// Adds a family member to the account. The account holder's own profile is
/// created at registration, so anything added here is a dependent.
class CreateProfile {
  ProfileRepository repository;

  CreateProfile(this.repository);

  Future<Either<Failure, Profile>> call(CreateProfileParams params) async {
    return await repository.create(params);
  }
}

class CreateProfileParams {
  final String name;
  final String countryCode;
  final DateTime dateOfBirth;
  final String gender;

  /// One of PROFILE_RELATIONS except 'self', which the backend reserves for
  /// the account holder.
  final String relation;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final File? avatar;

  CreateProfileParams({
    required this.name,
    required this.countryCode,
    required this.dateOfBirth,
    required this.gender,
    required this.relation,
    this.weight,
    this.height,
    this.phoneNumber,
    this.avatar,
  });
}
