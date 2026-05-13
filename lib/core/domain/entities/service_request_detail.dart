import 'package:equatable/equatable.dart';
import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/models/personal_issue_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';

sealed class ServiceRequestDetail {}

// ─── Nursing ─────────────────────────────────────────────────────────────────

class NursingDetail extends ServiceRequestDetail with EquatableMixin {
  final List<PersonalIssue> personalIssues;
  final List<ServiceEntity> services;
  final MobilityStatus? mobilityStatus;
  final String? mobilityStatusDetail;

  NursingDetail({
    required this.personalIssues,
    required this.services,
    this.mobilityStatus,
    this.mobilityStatusDetail,
  });

  static NursingDetail fromJson(Map<String, dynamic> detail) {
    final rawIssues = detail['personal_issues'] as List? ?? [];
    final rawServices = detail['services'] as List? ?? [];
    final mobilityStatusRaw = detail['mobility_status'] as String?;
    final mobilityStatusDetailRaw = detail['mobility_status_detail'] as String?;
    return NursingDetail(
      personalIssues: rawIssues
          .map((e) => PersonalIssueModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: rawServices
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mobilityStatus: mobilityStatusRaw != null
          ? MobilityStatus.fromApiValue(mobilityStatusRaw)
          : null,
      mobilityStatusDetail: mobilityStatusDetailRaw,
    );
  }

  @override
  List<Object?> get props =>
      [personalIssues, services, mobilityStatus, mobilityStatusDetail];
}

// ─── Pharmacy — General Counseling ───────────────────────────────────────────

class PharmacyGeneralDetail extends ServiceRequestDetail with EquatableMixin {
  final List<PersonalIssue> personalIssues;
  final List<ServiceEntity> services;

  PharmacyGeneralDetail({
    required this.personalIssues,
    required this.services,
  });

  static PharmacyGeneralDetail fromJson(Map<String, dynamic> detail) {
    final rawIssues = detail['personal_issues'] as List? ?? [];
    final rawServices = detail['services'] as List? ?? [];
    return PharmacyGeneralDetail(
      personalIssues: rawIssues
          .map((e) => PersonalIssueModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: rawServices
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [personalIssues, services];
}

// ─── Pharmacy — Smoking Cessation ────────────────────────────────────────────

class PharmacySmokingCessationDetail extends ServiceRequestDetail
    with EquatableMixin {
  // Answers injected by backend enrichDetail: is_smoking, product_types,
  // cigarettes_per_day, has_tried_quitting, years_smoking, …
  final Map<String, dynamic> questionnaireAnswers;
  final List<ServiceEntity> services;

  PharmacySmokingCessationDetail({
    required this.questionnaireAnswers,
    required this.services,
  });

  static PharmacySmokingCessationDetail fromJson(Map<String, dynamic> detail) {
    final rawAnswers = detail['questionnaire_answers'] as Map? ?? {};
    final rawServices = detail['services'] as List? ?? [];
    return PharmacySmokingCessationDetail(
      questionnaireAnswers: Map<String, dynamic>.from(rawAnswers),
      services: rawServices
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [questionnaireAnswers, services];
}

// ─── Screening ────────────────────────────────────────────────────────────────

class ScreeningDetail extends ServiceRequestDetail with EquatableMixin {
  final List<ServiceEntity> services;

  ScreeningDetail({required this.services});

  static ScreeningDetail fromJson(Map<String, dynamic> detail) {
    final rawServices = detail['services'] as List? ?? [];
    return ScreeningDetail(
      services: rawServices
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [services];
}

// ─── Homecare ─────────────────────────────────────────────────────────────────

class HomecareDetail extends ServiceRequestDetail with EquatableMixin {
  final List<String> services;
  final String billingType;

  HomecareDetail({required this.services, required this.billingType});

  static HomecareDetail fromJson(Map<String, dynamic> detail) {
    final rawServices = detail['services'] as List? ?? [];
    final billingType = (detail['billing_type'] as String?) ?? 'hourly';
    return HomecareDetail(
      services: List<String>.from(rawServices),
      billingType: billingType,
    );
  }

  @override
  List<Object?> get props => [services, billingType];
}

// ─── Physiotherapy ────────────────────────────────────────────────────────────

class PhysiotherapyDetail extends ServiceRequestDetail with EquatableMixin {
  final ServiceEntity service;
  final int duration; // minutes

  PhysiotherapyDetail({required this.service, required this.duration});

  static PhysiotherapyDetail fromJson(Map<String, dynamic> detail) {
    final rawService = detail['service'] as Map<String, dynamic>? ?? const {};
    final duration = (detail['duration'] as num?)?.toInt() ?? 0;
    return PhysiotherapyDetail(
      service: ServiceModel.fromJson(rawService),
      duration: duration,
    );
  }

  @override
  List<Object?> get props => [service, duration];
}

// ─── Second Opinion Imaging ───────────────────────────────────────────────────

class SecondOpinionDetail extends ServiceRequestDetail with EquatableMixin {
  final String serviceType; // 'radiology' | 'pathology'
  final String diseaseName;
  final String? diseaseHistory;
  final String? biomarker;
  final List<SecondOpinionImage> images;

  SecondOpinionDetail({
    required this.serviceType,
    required this.diseaseName,
    this.diseaseHistory,
    this.biomarker,
    required this.images,
  });

  static SecondOpinionDetail fromJson(Map<String, dynamic> detail) {
    final rawImages = detail['images'] as List? ?? [];
    return SecondOpinionDetail(
      serviceType: (detail['service_type'] as String?) ?? 'radiology',
      diseaseName: (detail['disease_name'] as String?) ?? '',
      diseaseHistory: detail['disease_history'] as String?,
      biomarker: detail['biomarker'] as String?,
      images: rawImages
          .map((e) => SecondOpinionImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [serviceType, diseaseName, diseaseHistory, biomarker, images];
}

class SecondOpinionImage extends Equatable {
  final String? imageType;
  // Populated after backend enrichDetail call; null if not yet enriched.
  final String? fileUrl;
  final int fileUploadId;

  const SecondOpinionImage({
    this.imageType,
    this.fileUrl,
    required this.fileUploadId,
  });

  static SecondOpinionImage fromJson(Map<String, dynamic> json) {
    return SecondOpinionImage(
      imageType: json['image_type'] as String?,
      fileUrl: json['file_url'] as String?,
      fileUploadId: (json['file_upload_id'] as int?) ?? 0,
    );
  }

  @override
  List<Object?> get props => [imageType, fileUrl, fileUploadId];
}

// ─── Nutrition ────────────────────────────────────────────────────────────────

class NutritionDetail extends ServiceRequestDetail with EquatableMixin {
  NutritionDetail();

  @override
  List<Object?> get props => [];
}
