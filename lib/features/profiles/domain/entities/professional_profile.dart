import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/entities/certificate.dart';
import 'package:m2health/features/profiles/domain/entities/onboarding_status.dart';

class ProfessionalProfile extends Equatable {
  final int id;
  final int userId;
  final String? name;
  final String? countryCode;
  final String? avatar;
  final int? experience;
  final double? rating;
  final String? about;
  final String? jobTitle;
  final String? workingHours;
  final String? workPlace;
  final bool isVerified;
  final DateTime? verifiedAt;
  final VerificationStatus verificationStatus;
  final DateTime? submittedAt;
  final OnboardingStatus? onboarding;
  final bool? isHomeScreeningAuthorized;
  final int? serviceRadiusPreference;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Certificate> certificates;
  final List<ServiceEntity> providedServices;
  final Address? workplaceAddress;

  const ProfessionalProfile({
    required this.id,
    required this.userId,
    this.name,
    this.countryCode,
    this.avatar,
    this.experience,
    this.rating,
    this.about,
    this.jobTitle,
    this.workingHours,
    this.workPlace,
    this.isVerified = false,
    this.verifiedAt,
    this.verificationStatus = VerificationStatus.incomplete,
    this.submittedAt,
    this.onboarding,
    this.isHomeScreeningAuthorized,
    this.serviceRadiusPreference,
    this.createdAt,
    this.updatedAt,
    this.certificates = const [],
    this.providedServices = const [],
    this.workplaceAddress,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        countryCode,
        avatar,
        experience,
        rating,
        about,
        jobTitle,
        workingHours,
        workPlace,
        isVerified,
        verifiedAt,
        verificationStatus,
        submittedAt,
        onboarding,
        isHomeScreeningAuthorized,
        serviceRadiusPreference,
        createdAt,
        updatedAt,
        certificates,
        providedServices,
        workplaceAddress,
      ];

  ProfessionalProfile copyWith({
    int? id,
    int? userId,
    String? name,
    String? countryCode,
    String? avatar,
    int? experience,
    double? rating,
    String? about,
    String? jobTitle,
    String? workingHours,
    String? workPlace,
    bool? isVerified,
    DateTime? verifiedAt,
    VerificationStatus? verificationStatus,
    DateTime? submittedAt,
    OnboardingStatus? onboarding,
    bool? isHomeScreeningAuthorized,
    int? serviceRadiusPreference,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Certificate>? certificates,
    List<ServiceEntity>? providedServices,
    Address? workplaceAddress,
  }) {
    return ProfessionalProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        countryCode: countryCode ?? this.countryCode,
        avatar: avatar ?? this.avatar,
        experience: experience ?? this.experience,
        rating: rating ?? this.rating,
        about: about ?? this.about,
        jobTitle: jobTitle ?? this.jobTitle,
        workingHours: workingHours ?? this.workingHours,
        workPlace: workPlace ?? this.workPlace,
        isVerified: isVerified ?? this.isVerified,
        verifiedAt: verifiedAt ?? this.verifiedAt,
        verificationStatus: verificationStatus ?? this.verificationStatus,
        submittedAt: submittedAt ?? this.submittedAt,
        onboarding: onboarding ?? this.onboarding,
        isHomeScreeningAuthorized:
            isHomeScreeningAuthorized ?? this.isHomeScreeningAuthorized,
        serviceRadiusPreference:
            serviceRadiusPreference ?? this.serviceRadiusPreference,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        certificates: certificates ?? this.certificates,
        providedServices: providedServices ?? this.providedServices,
        workplaceAddress: workplaceAddress ?? this.workplaceAddress);
  }
}
