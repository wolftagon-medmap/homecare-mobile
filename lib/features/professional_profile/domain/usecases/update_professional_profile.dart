import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';

class UpdateProfessionalProfile {
  final ProfessionalProfileRepository repository;

  UpdateProfessionalProfile(this.repository);

  Future<Either<Failure, Unit>> call(
      UpdateProfessionalProfileParams params) async {
    return await repository.updateProfessionalProfile(params);
  }
}

class UpdateProfessionalProfileParams extends Equatable {
  final String role;
  final String? name;
  final String? countryCode;
  final String? about;
  final String? jobTitle;
  final String? workHours;
  final String? workPlace;
  final int? experience;
  final File? avatar;
  final int? serviceRadiusPreference;
  final String? gender;
  final String? emergencyContactName;
  final String? emergencyContactRelationship;
  final String? emergencyContactPhone;

  const UpdateProfessionalProfileParams({
    required this.role,
    this.name,
    this.countryCode,
    this.about,
    this.jobTitle,
    this.workHours,
    this.workPlace,
    this.experience,
    this.avatar,
    this.serviceRadiusPreference,
    this.gender,
    this.emergencyContactName,
    this.emergencyContactRelationship,
    this.emergencyContactPhone,
  });

  @override
  List<Object?> get props => [
        role,
        name,
        countryCode,
        about,
        jobTitle,
        workHours,
        workPlace,
        experience,
        avatar,
        serviceRadiusPreference,
        gender,
        emergencyContactName,
        emergencyContactRelationship,
        emergencyContactPhone,
      ];

  UpdateProfessionalProfileParams copyWith({
    String? role,
    String? name,
    String? countryCode,
    String? about,
    String? jobTitle,
    String? workHours,
    String? workPlace,
    int? experience,
    File? avatar,
    int? serviceRadiusPreference,
    String? gender,
    String? emergencyContactName,
    String? emergencyContactRelationship,
    String? emergencyContactPhone,
  }) {
    return UpdateProfessionalProfileParams(
      role: role ?? this.role,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      about: about ?? this.about,
      jobTitle: jobTitle ?? this.jobTitle,
      workHours: workHours ?? this.workHours,
      workPlace: workPlace ?? this.workPlace,
      experience: experience ?? this.experience,
      avatar: avatar ?? this.avatar,
      serviceRadiusPreference:
          serviceRadiusPreference ?? this.serviceRadiusPreference,
      gender: gender ?? this.gender,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactRelationship:
          emergencyContactRelationship ?? this.emergencyContactRelationship,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }
}
