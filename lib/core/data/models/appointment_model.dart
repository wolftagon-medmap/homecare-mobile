import 'package:m2health/core/data/models/care_plan_model.dart';
import 'package:m2health/core/data/models/diagnostic_report_model.dart';
import 'package:m2health/core/data/models/order_model.dart';
import 'package:m2health/core/data/models/service_request_model.dart';
import 'package:m2health/features/home_health_screening/data/models/screening_request_data.dart';
import 'package:m2health/features/homecare_elderly/data/model/homecare_request_data_model.dart';
import 'package:m2health/features/payment/data/model/payment_model.dart';
import 'package:m2health/features/booking_appointment/nursing/data/models/nursing_personal_case.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/pharmacy/data/models/pharmacy_personal_case.dart';
import 'package:m2health/features/booking_appointment/professional_directory/data/models/professional_model.dart';
import 'package:m2health/features/profiles/data/models/profile_model.dart';
import 'package:m2health/features/physiotherapy/data/models/physiotherapy_request_data_model.dart';
import 'package:m2health/features/second_opinion_imaging/data/models/second_opinion_imaging_request_data_model.dart';
import 'package:m2health/features/second_opinion_imaging/data/models/second_opinion_imaging_feedback_model.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.id,
    super.userId,
    required super.type,
    required super.status,
    required super.startDatetime,
    super.endDatetime,
    required super.summary,
    required super.createdAt,
    required super.updatedAt,
    super.providerId,
    super.cancelledBy,
    super.cancellationReason,
    super.order,
    super.serviceRequest,
    super.carePlans,
    super.diagnosticReports,
    super.provider,
    super.patientProfile,
    // // ignore: deprecated_member_use_from_same_package
    // super.payTotal,
    // // ignore: deprecated_member_use_from_same_package
    // super.nursingCase,
    // // ignore: deprecated_member_use_from_same_package
    // super.pharmacyCase,
    // // ignore: deprecated_member_use_from_same_package
    // super.screeningRequestData,
    // // ignore: deprecated_member_use_from_same_package
    // super.homecareRequestData,
    // // ignore: deprecated_member_use_from_same_package
    // super.physiotherapyRequestData,
    // // ignore: deprecated_member_use_from_same_package
    // super.secondOpinionImagingRequestData,
    // // ignore: deprecated_member_use_from_same_package
    // super.secondOpinionImagingFeedback,
    // // ignore: deprecated_member_use_from_same_package
    // super.payment,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? '';

    // v2: provider is nested under 'provider'
    final provider = json['provider'] != null
        ? ProfessionalModel.fromJson(json['provider'] as Map<String, dynamic>)
        : null;

    final patient = json['patient'] != null
        ? ProfileModel.fromJson(json['patient'] as Map<String, dynamic>)
        : null;

    // v2: order is returned alongside appointment
    final order = json['order'] != null
        ? OrderModel.fromJson(json['order'] as Map<String, dynamic>)
        : null;

    // v2: unified service_request replaces per-type *_request_data
    final serviceRequestJson = json['service_request'] as Map<String, dynamic>?;
    final serviceRequest = serviceRequestJson != null
        ? ServiceRequestModel.fromJson(serviceRequestJson, type)
        : null;

    // v2: care_plans array
    final carePlans = (json['care_plans'] as List? ?? [])
        .map((e) => CarePlanModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // v2: diagnostic_reports array
    final diagnosticReports = (json['diagnostic_reports'] as List? ?? [])
        .map((e) => DiagnosticReportModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Backward-compat: populate deprecated per-type fields.
    // Try v2 service_request.detail first; fall back to legacy top-level keys.
    // final detail = serviceRequestJson?['detail'] as Map<String, dynamic>?;

    // // ignore: deprecated_member_use_from_same_package
    // final nursingCase = _orLegacy(
    //   () => detail != null && type == 'nursing'
    //       ? NursingPersonalCaseModel.fromJson(detail)
    //       : null,
    //   () => json['nursing_request_data'] != null
    //       ? NursingPersonalCaseModel.fromJson(
    //           json['nursing_request_data'] as Map<String, dynamic>)
    //       : null,
    // );

    // // ignore: deprecated_member_use_from_same_package
    // final pharmacyCase = _orLegacy(
    //   () => detail != null && type == 'pharmacy'
    //       ? PharmacyPersonalCaseModel.fromJson(detail)
    //       : null,
    //   () => json['pharmacy_request_data'] != null
    //       ? PharmacyPersonalCaseModel.fromJson(
    //           json['pharmacy_request_data'] as Map<String, dynamic>)
    //       : null,
    // );

    // // ignore: deprecated_member_use_from_same_package
    // final screeningRequest = _orLegacy(
    //   () => detail != null && type == 'screening'
    //       ? ScreeningRequestData.fromJson(detail)
    //       : null,
    //   () => json['screening_request_data'] != null
    //       ? ScreeningRequestData.fromJson(
    //           json['screening_request_data'] as Map<String, dynamic>)
    //       : null,
    // );

    // // ignore: deprecated_member_use_from_same_package
    // final homecareRequest = _orLegacy(
    //   () => detail != null && type == 'homecare'
    //       ? HomecareRequestDataModel.fromJson(detail)
    //       : null,
    //   () => json['homecare_request_data'] != null
    //       ? HomecareRequestDataModel.fromJson(
    //           json['homecare_request_data'] as Map<String, dynamic>)
    //       : null,
    // );

    // // ignore: deprecated_member_use_from_same_package
    // final physiotherapyRequest = _orLegacy(
    //   () => detail != null && type == 'physiotherapy'
    //       ? PhysiotherapyRequestDataModel.fromJson(detail)
    //       : null,
    //   () => json['physiotherapy_request_data'] != null
    //       ? PhysiotherapyRequestDataModel.fromJson(
    //           json['physiotherapy_request_data'] as Map<String, dynamic>)
    //       : null,
    // );

    // // ignore: deprecated_member_use_from_same_package
    // final secondOpinionRequest = _orLegacy(
    //   () => detail != null && type == 'second_opinion_imaging'
    //       ? SecondOpinionImagingRequestDataModel.fromJson(detail)
    //       : null,
    //   () => json['second_opinion_imaging_request_data'] != null
    //       ? SecondOpinionImagingRequestDataModel.fromJson(
    //           json['second_opinion_imaging_request_data']
    //               as Map<String, dynamic>)
    //       : null,
    // );

    // // ignore: deprecated_member_use_from_same_package
    // final secondOpinionFeedback =
    //     // ignore: deprecated_member_use_from_same_package
    //     json['second_opinion_imaging_feedback'] != null
    //         ? SecondOpinionImagingFeedbackModel.fromJson(
    //             // ignore: deprecated_member_use_from_same_package
    //             json['second_opinion_imaging_feedback']
    //                 as Map<String, dynamic>)
    //         : null;

    // // ignore: deprecated_member_use_from_same_package
    // final payment = json['payment'] != null
    //     ? PaymentModel.fromJson(json['payment'] as Map<String, dynamic>)
    //     : null;

    // // pay_total: prefer order.total; fall back to legacy pay_total field
    // final payTotal = order != null
    //     ? order.total
    //     : double.parse((json['pay_total'] ?? 0).toString());

    return AppointmentModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      type: type,
      status: json['status'] as String? ?? '',
      startDatetime: DateTime.parse(json['start_datetime'] as String),
      endDatetime: json['end_datetime'] != null
          ? DateTime.parse(json['end_datetime'] as String)
          : null,
      summary: json['summary'] as String? ?? 'N/A',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      providerId: json['provider_id'] as int?,
      cancelledBy: json['cancelled_by'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      order: order,
      serviceRequest: serviceRequest,
      carePlans: carePlans,
      diagnosticReports: diagnosticReports,
      provider: provider,
      patientProfile: patient,
      // payTotal: payTotal,
      // nursingCase: nursingCase,
      // pharmacyCase: pharmacyCase,
      // screeningRequestData: screeningRequest,
      // homecareRequestData: homecareRequest,
      // physiotherapyRequestData: physiotherapyRequest,
      // secondOpinionImagingRequestData: secondOpinionRequest,
      // secondOpinionImagingFeedback: secondOpinionFeedback,
      // payment: payment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'status': status,
      'start_datetime': startDatetime.toIso8601String(),
      'summary': summary,
      // ignore: deprecated_member_use_from_same_package
      'pay_total': payTotal,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'provider_id': providerId,
      'cancelled_by': cancelledBy,
      'cancellation_reason': cancellationReason,
    };
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      status: entity.status,
      startDatetime: entity.startDatetime,
      endDatetime: entity.endDatetime,
      summary: entity.summary,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      providerId: entity.providerId,
      cancelledBy: entity.cancelledBy,
      cancellationReason: entity.cancellationReason,
      order: entity.order,
      serviceRequest: entity.serviceRequest,
      carePlans: entity.carePlans,
      diagnosticReports: entity.diagnosticReports,
      provider: entity.provider,
      patientProfile: entity.patientProfile,
      // // ignore: deprecated_member_use_from_same_package
      // payTotal: entity.payTotal,
      // // ignore: deprecated_member_use_from_same_package
      // nursingCase: entity.nursingCase,
      // // ignore: deprecated_member_use_from_same_package
      // pharmacyCase: entity.pharmacyCase,
      // // ignore: deprecated_member_use_from_same_package
      // screeningRequestData: entity.screeningRequestData,
      // // ignore: deprecated_member_use_from_same_package
      // homecareRequestData: entity.homecareRequestData,
      // // ignore: deprecated_member_use_from_same_package
      // physiotherapyRequestData: entity.physiotherapyRequestData,
      // // ignore: deprecated_member_use_from_same_package
      // secondOpinionImagingRequestData: entity.secondOpinionImagingRequestData,
      // // ignore: deprecated_member_use_from_same_package
      // secondOpinionImagingFeedback: entity.secondOpinionImagingFeedback,
      // // ignore: deprecated_member_use_from_same_package
      // payment: entity.payment,
    );
  }

  // // Returns the result of primary() if non-null, otherwise calls fallback().
  // static T? _orLegacy<T>(T? Function() primary, T? Function() fallback) {
  //   final p = primary();
  //   if (p != null) return p;
  //   return fallback();
  // }
}
