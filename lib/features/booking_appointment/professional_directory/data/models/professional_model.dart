import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';
import 'package:m2health/features/professional_profile/data/models/expertise_model.dart';
import 'package:m2health/features/professional_profile/data/models/service_area_model.dart';
import 'package:m2health/features/booking_appointment/professional_directory/data/models/review_model.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/professional_profile/data/models/certificate_model.dart';

class ProfessionalModel extends ProfessionalEntity {
  const ProfessionalModel({
    required super.id,
    required super.name,
    required super.avatar,
    super.countryCode,
    required super.experience,
    required super.rating,
    required super.about,
    required super.workingInformation,
    required super.jobTitle,
    required super.workingHours,
    required super.workplace,
    required super.certificates,
    required super.reviews,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
    required super.isFavorite,
    required super.role,
    required super.providerType,
    required super.completedAppointmentsCount,
    super.conditionExperience,
    super.languages,
    super.careStyle,
    super.serviceAreas,
    super.preferenceHighlights,
    super.services,
    super.serviceProficiency,
    super.workplaceAddress,
  });

  static List<LeveledEntryModel> _leveled(dynamic raw) =>
      (raw as List<dynamic>? ?? [])
          .map((e) => LeveledEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();

  /// The API serialises model columns in camelCase and hand-assembled keys in
  /// snake_case, so both spellings have to be accepted.
  static dynamic _pick(Map<String, dynamic> json, String snake, String camel) =>
      json[snake] ?? json[camel];

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      countryCode: _pick(json, 'country_code', 'countryCode') as String?,
      experience: json['experience'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      about: json['about'],
      jobTitle: _pick(json, 'job_title', 'jobTitle') ?? json['role'],
      workingInformation:
          _pick(json, 'working_information', 'workingInformation') ?? '',
      workingHours: _pick(json, 'working_hours', 'workingHours') as String?,
      workplace: json['workplace'],
      certificates: (json['certificates'] as List<dynamic>?)
              ?.map((e) => CertificateModel.fromJson(e))
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
      userId: _pick(json, 'user_id', 'userId') as int? ?? 0,
      createdAt: _pick(json, 'created_at', 'createdAt') as String? ?? '',
      updatedAt: _pick(json, 'updated_at', 'updatedAt') as String? ?? '',
      isFavorite: _pick(json, 'is_favorite', 'isFavorite') ?? false,
      role: json['role'],
      providerType:
          _pick(json, 'provider_type', 'providerType') ?? json['role'],
      completedAppointmentsCount: (_pick(json, 'completed_appointments_count',
                  'completedAppointmentsCount') as num?)
              ?.toInt() ??
          0,
      conditionExperience: _leveled(json['condition_experience']),
      languages: _leveled(json['languages']),
      careStyle: (json['care_style'] as List<dynamic>? ?? [])
          .map((e) => CareStyleTraitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceAreas: (json['service_areas'] as List<dynamic>? ?? [])
          .map((e) => ServiceAreaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferenceHighlights: [
        for (final h in (json['preference_highlights'] as List<dynamic>? ?? []))
          h.toString(),
      ],
      services: (json['services'] as List<dynamic>? ?? [])
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceProficiency: {
        for (final s in (json['services'] as List<dynamic>? ?? []))
          if ((s as Map<String, dynamic>)['proficiency_level'] != null)
            s['id'] as int: (s['proficiency_level'] as num).toInt(),
      },
      workplaceAddress: json['workplaceAddress'] != null
          ? AddressModel.fromJson(
              json['workplaceAddress'] as Map<String, dynamic>)
          : (json['workplace_address'] != null
              ? AddressModel.fromJson(
                  json['workplace_address'] as Map<String, dynamic>)
              : null),
    );
  }
}
