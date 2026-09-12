import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/user_profiles/domain/repositories/profile_repository.dart';

class UpdateProfile {
  ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, Unit>> call(UpdateProfileParams params) async {
    return await repository.update(params);
  }
}

class UpdateProfileParams {
  /// Which profile to edit — the account holder's own or a family member's.
  final int profileId;
  final String? name;
  final String? countryCode;

  /// The backend derives `age` from this, so the form no longer collects age.
  final DateTime? dateOfBirth;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? gender;

  /// One of PROFILE_RELATIONS; 'self' is reserved for the account holder.
  final String? relation;
  final File? avatar;

  UpdateProfileParams({
    required this.profileId,
    this.name,
    this.countryCode,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.phoneNumber,
    this.gender,
    this.relation,
    this.avatar,
  });

  UpdateProfileParams copyWith({
    int? profileId,
    String? name,
    String? countryCode,
    DateTime? dateOfBirth,
    double? weight,
    double? height,
    String? phoneNumber,
    String? gender,
    String? relation,
    File? avatar,
  }) {
    return UpdateProfileParams(
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      relation: relation ?? this.relation,
      avatar: avatar ?? this.avatar,
    );
  }
}
