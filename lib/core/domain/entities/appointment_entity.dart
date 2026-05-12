import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/care_plan_entity.dart';
import 'package:m2health/core/domain/entities/diagnostic_report_entity.dart';
import 'package:m2health/core/domain/entities/order_entity.dart';
import 'package:m2health/core/domain/entities/service_request_entity.dart';
import 'package:m2health/features/home_health_screening/data/models/screening_request_data.dart';
import 'package:m2health/features/homecare_elderly/domain/entities/homecare_request_data.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/physiotherapy/domain/entities/physiotherapy_request_data.dart';
import 'package:m2health/features/second_opinion_imaging/domain/entities/second_opinion_imaging_feedback.dart';
import 'package:m2health/features/second_opinion_imaging/domain/entities/second_opinion_imaging_request_data.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';

class AppointmentEntity extends Equatable {
  final int? id;
  final int? userId;
  final String type;
  final String status;
  final DateTime startDatetime;
  final DateTime? endDatetime;
  final String summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? providerId;
  final String? cancelledBy;
  final String? cancellationReason;

  // v2 unified fields
  final OrderEntity? order;
  final ServiceRequestEntity? serviceRequest;
  final List<CarePlanEntity> carePlans;
  final List<DiagnosticReportEntity> diagnosticReports;

  final ProfessionalEntity? provider;
  final Profile? patientProfile;

  // TODO: Remove in next refactor cycle — replaced by order.total
  @Deprecated('Use order.total instead. TODO: delete after migration.')
  final double payTotal;

  // TODO: Remove in next refactor cycle — replaced by serviceRequest.asNursingDetail()
  @Deprecated('Use serviceRequest.asNursingDetail() instead. TODO: delete.')
  final NursingCase? nursingCase;

  // TODO: Remove in next refactor cycle — replaced by serviceRequest.asPharmacyDetail()
  @Deprecated('Use serviceRequest.asPharmacyDetail() instead. TODO: delete.')
  final PharmacyCase? pharmacyCase;

  // TODO: Remove in next refactor cycle — replaced by serviceRequest + diagnosticReports
  @Deprecated(
      'Use serviceRequest.status and diagnosticReports instead. TODO: delete.')
  final ScreeningRequestData? screeningRequestData;

  // TODO: Remove in next refactor cycle — replaced by serviceRequest.asHomecareDetail()
  @Deprecated('Use serviceRequest.asHomecareDetail() instead. TODO: delete.')
  final HomecareRequestData? homecareRequestData;

  // TODO: Remove in next refactor cycle — replaced by serviceRequest.asPhysiotherapyDetail()
  @Deprecated(
      'Use serviceRequest.asPhysiotherapyDetail() instead. TODO: delete.')
  final PhysiotherapyRequestData? physiotherapyRequestData;

  // TODO: Remove in next refactor cycle — replaced by serviceRequest.asSecondOpinionDetail()
  @Deprecated(
      'Use serviceRequest.asSecondOpinionDetail() instead. TODO: delete.')
  final SecondOpinionImagingRequestData? secondOpinionImagingRequestData;

  // TODO: Remove in next refactor cycle — replaced by diagnosticReports
  @Deprecated('Use diagnosticReports instead. TODO: delete.')
  final SecondOpinionImagingFeedback? secondOpinionImagingFeedback;

  // TODO: Remove in next refactor cycle — replaced by order.isPaid check
  @Deprecated('Use order?.isPaid instead. TODO: delete.')
  final Payment? payment;

  const AppointmentEntity({
    this.id,
    this.userId,
    required this.type,
    required this.status,
    required this.startDatetime,
    this.endDatetime,
    required this.summary,
    // ignore: deprecated_member_use_from_same_package
    this.payTotal = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.providerId,
    this.cancelledBy,
    this.cancellationReason,
    this.order,
    this.serviceRequest,
    this.carePlans = const [],
    this.diagnosticReports = const [],
    this.provider,
    this.patientProfile,
    // ignore: deprecated_member_use_from_same_package
    this.nursingCase,
    // ignore: deprecated_member_use_from_same_package
    this.pharmacyCase,
    // ignore: deprecated_member_use_from_same_package
    this.screeningRequestData,
    // ignore: deprecated_member_use_from_same_package
    this.homecareRequestData,
    // ignore: deprecated_member_use_from_same_package
    this.physiotherapyRequestData,
    // ignore: deprecated_member_use_from_same_package
    this.secondOpinionImagingRequestData,
    // ignore: deprecated_member_use_from_same_package
    this.secondOpinionImagingFeedback,
    // ignore: deprecated_member_use_from_same_package
    this.payment,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        status,
        startDatetime,
        endDatetime,
        summary,
        // ignore: deprecated_member_use_from_same_package
        payTotal,
        createdAt,
        updatedAt,
        providerId,
        cancelledBy,
        cancellationReason,
        order,
        serviceRequest,
        carePlans,
        diagnosticReports,
        provider,
        patientProfile,
        // ignore: deprecated_member_use_from_same_package
        nursingCase,
        // ignore: deprecated_member_use_from_same_package
        pharmacyCase,
        // ignore: deprecated_member_use_from_same_package
        screeningRequestData,
        // ignore: deprecated_member_use_from_same_package
        homecareRequestData,
        // ignore: deprecated_member_use_from_same_package
        physiotherapyRequestData,
        // ignore: deprecated_member_use_from_same_package
        secondOpinionImagingRequestData,
        // ignore: deprecated_member_use_from_same_package
        secondOpinionImagingFeedback,
        // ignore: deprecated_member_use_from_same_package
        payment,
      ];
}
