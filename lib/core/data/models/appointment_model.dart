import 'package:m2health/features/home_health_screening/data/models/screening_request_data.dart';
import 'package:m2health/features/homecare_elderly/data/model/homecare_request_data_model.dart';
import 'package:m2health/features/payment/data/model/payment_model.dart';
import 'package:m2health/features/booking_appointment/nursing/data/models/nursing_personal_case.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/pharmacy/data/models/pharmacy_personal_case.dart';
import 'package:m2health/features/booking_appointment/professional_directory/data/models/professional_model.dart';
import 'package:m2health/features/profiles/data/models/profile_model.dart';
import 'package:m2health/features/physiotherapy/data/models/physiotherapy_request_data_model.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.id,
    super.userId,
    required super.type,
    required super.status,
    required super.startDatetime,
    required super.endDatetime,
    required super.summary,
    required super.payTotal,
    required super.createdAt,
    required super.updatedAt,
    super.providerId,
    super.provider,
    super.nursingCase,
    super.pharmacyCase,
    super.screeningRequestData,
    super.homecareRequestData,
    super.physiotherapyRequestData,
    super.patientProfile,
    super.payment,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> appointmentJson) {
    final provider = appointmentJson['provider'] != null
        ? ProfessionalModel.fromJson(appointmentJson['provider'])
        : null;
    final patient = appointmentJson['patient'] != null
        ? ProfileModel.fromJson(appointmentJson['patient'])
        : null;
    final payment = appointmentJson['payment'] != null
        ? PaymentModel.fromJson(appointmentJson['payment'])
        : null;
    final nursingCase = appointmentJson['nursing_request_data'] != null
        ? NursingPersonalCaseModel.fromJson(
            appointmentJson['nursing_request_data'])
        : null;
    final pharmacyCase = appointmentJson['pharmacy_request_data'] != null
        ? PharmacyPersonalCaseModel.fromJson(
            appointmentJson['pharmacy_request_data'])
        : null;
    final screeningRequest = appointmentJson['screening_request_data'] != null
        ? ScreeningRequestData.fromJson(
            appointmentJson['screening_request_data'])
        : null;
    final homecareRequest = appointmentJson['homecare_request_data'] != null
        ? HomecareRequestDataModel.fromJson(appointmentJson['homecare_request_data'])
        : null;
    final physiotherapyRequest = appointmentJson['physiotherapy_request_data'] != null
        ? PhysiotherapyRequestDataModel.fromJson(appointmentJson['physiotherapy_request_data'])
        : null;

    return AppointmentModel(
      id: appointmentJson['id'],
      userId: appointmentJson['user_id'],
      type: appointmentJson['type'],
      status: appointmentJson['status'],
      startDatetime: DateTime.parse(appointmentJson['start_datetime']),
      endDatetime: DateTime.parse(appointmentJson['end_datetime']),
      summary: appointmentJson['summary'] ?? 'N/A',
      payTotal: double.parse(appointmentJson['pay_total'].toString()),
      createdAt: DateTime.parse(appointmentJson['created_at']),
      updatedAt: DateTime.parse(appointmentJson['updated_at']),
      providerId: appointmentJson['provider_id'],
      provider: provider,
      nursingCase: nursingCase,
      pharmacyCase: pharmacyCase,
      screeningRequestData: screeningRequest,
      homecareRequestData: homecareRequest,
      physiotherapyRequestData: physiotherapyRequest,
      patientProfile: patient,
      payment: payment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'status': status,
      'start_datetime': startDatetime.toIso8601String(),
      // 'end_datetime': endDatetime.toIso8601String(),
      'summary': summary,
      'pay_total': payTotal,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'provider_id': providerId,
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
      payTotal: entity.payTotal,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      providerId: entity.providerId,
      provider: entity.provider,
      nursingCase: entity.nursingCase,
      patientProfile: entity.patientProfile,
    );
  }
}
