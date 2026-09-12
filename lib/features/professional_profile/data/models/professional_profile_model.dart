import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/features/user_profiles/data/models/address_model.dart';
import 'package:m2health/features/professional_profile/data/models/certificate_model.dart';
import 'package:m2health/features/professional_profile/data/models/emergency_contact_model.dart';
import 'package:m2health/features/professional_profile/data/models/expertise_model.dart';
import 'package:m2health/features/professional_profile/data/models/onboarding_status_model.dart';
import 'package:m2health/features/professional_profile/data/models/service_area_model.dart';
import 'package:m2health/features/professional_profile/data/models/work_preferences_model.dart';
import 'package:m2health/features/professional_profile/domain/entities/onboarding_status.dart';
import 'package:m2health/features/professional_profile/domain/entities/professional_profile.dart';
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
    super.rejectionReason,
    super.rejectionCategory,
    super.onboarding,
    super.isHomeScreeningAuthorized,
    super.serviceRadiusPreference,
    super.createdAt,
    super.updatedAt,
    super.certificates = const [],
    super.providedServices = const [],
    super.weeklyAvailabilities = const [],
    super.workplaceAddress,
    super.gender,
    super.conditionExperience,
    super.languages,
    super.careStyle,
    super.workPreferences,
    super.serviceAreas,
    super.residentialArea,
    super.emergencyContact,
    super.serviceProficiency,
    super.preferenceHighlights,
  });

  static List<LeveledEntryModel> _leveled(dynamic raw) =>
      (raw as List<dynamic>? ?? [])
          .map((e) => LeveledEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();

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
      rejectionReason: json['rejection_reason'],
      rejectionCategory: json['rejection_category'],
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
      gender: json['gender'] as String?,
      conditionExperience: _leveled(json['condition_experience']),
      languages: _leveled(json['languages']),
      careStyle: (json['care_style'] as List<dynamic>? ?? [])
          .map((e) => CareStyleTraitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      workPreferences: WorkPreferencesModel.fromJson(
          (json['work_preferences'] as Map<String, dynamic>?) ?? const {}),
      serviceAreas: (json['service_areas'] as List<dynamic>? ?? [])
          .map((e) => ServiceAreaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      residentialArea: json['residential_area'] != null
          ? ServiceAreaModel.fromJson(
              json['residential_area'] as Map<String, dynamic>)
          : null,
      emergencyContact: json['emergency_contact'] != null
          ? EmergencyContactModel.fromJson(
              json['emergency_contact'] as Map<String, dynamic>)
          : const EmergencyContactModel(),
      serviceProficiency: {
        for (final s in (json['services'] as List<dynamic>? ?? []))
          if ((s as Map<String, dynamic>)['proficiency_level'] != null)
            s['id'] as int: (s['proficiency_level'] as num).toInt(),
      },
      preferenceHighlights: [
        for (final h in (json['preference_highlights'] as List<dynamic>? ?? []))
          h.toString(),
      ],
      workplaceAddress: json['workplaceAddress'] != null
          ? AddressModel.fromJson(json['workplaceAddress'])
          : (json['workplace_address'] != null
              ? AddressModel.fromJson(json['workplace_address'])
              : null),
    );
  }
}
