import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/reviewer.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/professional_profile/domain/entities/care_style.dart';
import 'package:m2health/features/professional_profile/domain/entities/certificate.dart';
import 'package:m2health/features/professional_profile/domain/entities/expertise.dart';
import 'package:m2health/features/professional_profile/domain/entities/service_area.dart';

class ProfessionalEntity extends Equatable {
  final int id;
  final String name;
  final String? avatar;
  final String? countryCode;
  final int? experience;
  final double? rating;
  final String? about;
  final String? jobTitle;
  final String? workingInformation;
  final String? workingHours;
  final String? workplace;
  final List<Certificate>? certificates;
  final List<ReviewEntity>? reviews;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final bool isFavorite;
  final String role;
  final String providerType;
  final int completedAppointmentsCount;
  final List<LeveledEntry> conditionExperience;
  final List<LeveledEntry> languages;
  final List<CareStyleTrait> careStyle;
  final List<ServiceArea> serviceAreas;
  final List<String> preferenceHighlights;
  final List<ServiceEntity> services;
  final Map<int, int> serviceProficiency;
  final Address? workplaceAddress;

  const ProfessionalEntity({
    required this.id,
    required this.name,
    this.avatar,
    this.countryCode,
    required this.experience,
    required this.rating,
    this.about,
    this.workingInformation,
    this.jobTitle,
    this.workingHours,
    this.workplace,
    required this.certificates,
    required this.reviews,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.role,
    required this.providerType,
    required this.completedAppointmentsCount,
    this.conditionExperience = const [],
    this.languages = const [],
    this.careStyle = const [],
    this.serviceAreas = const [],
    this.preferenceHighlights = const [],
    this.services = const [],
    this.serviceProficiency = const {},
    this.workplaceAddress,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        countryCode,
        experience,
        rating,
        about,
        workingInformation,
        jobTitle,
        workingHours,
        workplace,
        certificates,
        reviews,
        userId,
        createdAt,
        updatedAt,
        isFavorite,
        role,
        providerType,
        completedAppointmentsCount,
        conditionExperience,
        languages,
        careStyle,
        serviceAreas,
        preferenceHighlights,
        services,
        serviceProficiency,
        workplaceAddress,
      ];

  ProfessionalEntity copyWith({bool? isFavorite}) {
    return ProfessionalEntity(
      id: id,
      name: name,
      avatar: avatar,
      countryCode: countryCode,
      experience: experience,
      rating: rating,
      about: about,
      workingInformation: workingInformation,
      jobTitle: jobTitle,
      workingHours: workingHours,
      workplace: workplace,
      certificates: certificates,
      reviews: reviews,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      role: role,
      providerType: providerType,
      completedAppointmentsCount: completedAppointmentsCount,
      conditionExperience: conditionExperience,
      languages: languages,
      careStyle: careStyle,
      serviceAreas: serviceAreas,
      preferenceHighlights: preferenceHighlights,
      services: services,
      serviceProficiency: serviceProficiency,
      workplaceAddress: workplaceAddress,
    );
  }
}
