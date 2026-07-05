import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';
import 'package:m2health/features/profiles/data/models/certificate_model.dart';
import 'package:m2health/features/profiles/data/models/onboarding_status_model.dart';
import 'package:m2health/features/profiles/domain/entities/onboarding_status.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/schedule/data/models/provider_availability_model.dart';

class ProfessionalProfileModel extends ProfessionalProfile {
  const ProfessionalProfileModel({
    required super.id,
    required super.userId,
    super.name,
    super.countryCode,
    super.avatar,
    super.experience,
    super.rating,
    super.about,
    super.jobTitle,
    super.workingHours,
    super.workPlace,
    super.isVerified,
    super.verifiedAt,
    super.verificationStatus,
    super.submittedAt,
    super.onboarding,
    super.isHomeScreeningAuthorized,
    super.serviceRadiusPreference,
    super.createdAt,
    super.updatedAt,
    super.certificates = const [],
    super.providedServices = const [],
    super.weeklyAvailabilities = const [],
    super.workplaceAddress,
  });

  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      countryCode: json['country_code']?.toString().toUpperCase(),
      avatar: json['avatar'],
      experience: json['experience'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      about: json['about'] ?? '',
      jobTitle: json['job_title'],
      workingHours: json['working_hours'] ?? '',
      workPlace: json['workplace'] ?? '',
      isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'])
          : null,
      verificationStatus:
          verificationStatusFromString(json['verification_status']),
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : null,
      onboarding: json['onboarding'] != null
          ? OnboardingStatusModel.fromJson(json['onboarding'])
          : null,
      isHomeScreeningAuthorized: json['is_home_screening_authorized'],
      serviceRadiusPreference: json['service_radius_preference'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      certificates: (json['certificates'] as List<dynamic>?)
              ?.map((e) => CertificateModel.fromJson(e))
              .toList() ??
          [],
      providedServices: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weeklyAvailabilities: (json['availabilities'] as List<dynamic>?)
              ?.map((e) =>
                  ProviderAvailabilityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      workplaceAddress: json['workplaceAddress'] != null
          ? AddressModel.fromJson(json['workplaceAddress'])
          : (json['workplace_address'] != null
              ? AddressModel.fromJson(json['workplace_address'])
              : null),
    );
  }
}
