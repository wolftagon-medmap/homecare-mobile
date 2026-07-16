import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';

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
  final int? age;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? homeAddress;
  final String? gender;
  final String? drugAllergy; // Added
  final File? avatar;

  UpdateProfileParams({
    required this.profileId,
    this.name,
    this.countryCode,
    this.age,
    this.weight,
    this.height,
    this.phoneNumber,
    this.homeAddress,
    this.gender,
    this.drugAllergy,
    this.avatar,
  });

  UpdateProfileParams copyWith({
    int? profileId,
    String? name,
    String? countryCode,
    int? age,
    double? weight,
    double? height,
    String? phoneNumber,
    String? homeAddress,
    String? gender,
    String? drugAllergy,
    File? avatar,
  }) {
    return UpdateProfileParams(
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      gender: gender ?? this.gender,
      drugAllergy: drugAllergy ?? this.drugAllergy,
      avatar: avatar ?? this.avatar,
    );
  }
}
