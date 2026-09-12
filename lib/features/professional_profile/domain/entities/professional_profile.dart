import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/professional_profile/domain/entities/care_style.dart';
import 'package:m2health/features/professional_profile/domain/entities/emergency_contact.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';
import 'package:m2health/features/professional_profile/domain/entities/work_preferences.dart';
import 'package:m2health/features/user_profiles/domain/entities/address.dart';
import 'package:m2health/features/professional_profile/domain/entities/certificate.dart';
import 'package:m2health/features/professional_profile/domain/entities/onboarding_status.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';

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
  final String? rejectionReason;
  final String? rejectionCategory;
  final OnboardingStatus? onboarding;
  final bool? isHomeScreeningAuthorized;
  final int? serviceRadiusPreference;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Certificate> certificates;
  final List<ServiceEntity> providedServices;
  final List<ProviderAvailability> weeklyAvailabilities;
  final Address? workplaceAddress;
  final String? gender;
  final List<LeveledEntry> conditionExperience;
  final List<LeveledEntry> languages;
  final List<CareStyleTrait> careStyle;
  final WorkPreferences workPreferences;
  final List<ServiceArea> serviceAreas;
  final ServiceArea? residentialArea;
  final EmergencyContact emergencyContact;

  /// Level claimed per service the professional offers, keyed by service id.
  /// Kept off ServiceEntity, which booking shares and which has no business
  /// carrying one professional's claim about itself.
  final Map<int, int> serviceProficiency;
  final List<String> preferenceHighlights;

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
    this.rejectionReason,
    this.rejectionCategory,
    this.onboarding,
    this.isHomeScreeningAuthorized,
    this.serviceRadiusPreference,
    this.createdAt,
    this.updatedAt,
    this.certificates = const [],
    this.providedServices = const [],
    this.weeklyAvailabilities = const [],
    this.workplaceAddress,
    this.gender,
    this.conditionExperience = const [],
    this.languages = const [],
    this.careStyle = const [],
    this.workPreferences = const WorkPreferences(),
    this.serviceAreas = const [],
    this.residentialArea,
    this.emergencyContact = const EmergencyContact(),
    this.serviceProficiency = const {},
    this.preferenceHighlights = const [],
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
        rejectionReason,
        rejectionCategory,
        onboarding,
        isHomeScreeningAuthorized,
        serviceRadiusPreference,
        createdAt,
        updatedAt,
        certificates,
        providedServices,
        weeklyAvailabilities,
        workplaceAddress,
        gender,
        conditionExperience,
        languages,
        careStyle,
        workPreferences,
        serviceAreas,
        residentialArea,
        emergencyContact,
        serviceProficiency,
        preferenceHighlights,
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
    String? rejectionReason,
    String? rejectionCategory,
    OnboardingStatus? onboarding,
    bool? isHomeScreeningAuthorized,
    int? serviceRadiusPreference,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Certificate>? certificates,
    List<ServiceEntity>? providedServices,
    List<ProviderAvailability>? weeklyAvailabilities,
    Address? workplaceAddress,
    String? gender,
    List<LeveledEntry>? conditionExperience,
    List<LeveledEntry>? languages,
    List<CareStyleTrait>? careStyle,
    WorkPreferences? workPreferences,
    List<ServiceArea>? serviceAreas,
    ServiceArea? residentialArea,
    bool clearResidentialArea = false,
    EmergencyContact? emergencyContact,
    Map<int, int>? serviceProficiency,
    List<String>? preferenceHighlights,
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
        rejectionReason: rejectionReason ?? this.rejectionReason,
        rejectionCategory: rejectionCategory ?? this.rejectionCategory,
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
        weeklyAvailabilities: weeklyAvailabilities ?? this.weeklyAvailabilities,
        workplaceAddress: workplaceAddress ?? this.workplaceAddress,
        gender: gender ?? this.gender,
        conditionExperience: conditionExperience ?? this.conditionExperience,
        languages: languages ?? this.languages,
        careStyle: careStyle ?? this.careStyle,
        workPreferences: workPreferences ?? this.workPreferences,
        serviceAreas: serviceAreas ?? this.serviceAreas,
        residentialArea: clearResidentialArea
            ? null
            : residentialArea ?? this.residentialArea,
        emergencyContact: emergencyContact ?? this.emergencyContact,
        serviceProficiency: serviceProficiency ?? this.serviceProficiency,
        preferenceHighlights:
            preferenceHighlights ?? this.preferenceHighlights);
  }
}
