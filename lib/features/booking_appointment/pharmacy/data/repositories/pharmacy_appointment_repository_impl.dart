import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/repositories/pharmacy_appointment_repository.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/usecases/create_pharmacy_appointment.dart';

class PharmacyAppointmentRepositoryImpl extends PharmacyAppointmentRepository {
  final AppointmentService appointmentService;

  PharmacyAppointmentRepositoryImpl({required this.appointmentService});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreatePharmacyAppointmentParams params) async {
    try {
      final pharmacyCase = params.pharmacyCase;
      final isSmokingCessation =
          pharmacyCase.serviceType == 'smoking_cessation';

      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': isSmokingCessation ? 'Smoking Cessation' : params.summary,
        'request_data': {
          'service_type': pharmacyCase.serviceType,
          if (isSmokingCessation) ...{
            if (params.questionnaireResponseId != null)
              'questionnaire_response_id': params.questionnaireResponseId,
          } else ...{
            'service_ids': pharmacyCase.addOnServices
                .map((service) => service.id)
                .toList(),
            'personal_issue_ids':
                pharmacyCase.issues.map((issue) => issue.id).toList(),
            'mobility_status': pharmacyCase.mobilityStatus?.apiValue,
            'related_health_record_id': pharmacyCase.relatedHealthRecordId,
          },
        },
      };
      final response = await appointmentService.createAppointment(payload);
      final result = AppointmentModel.fromJson(
          response['appointment'] as Map<String, dynamic>);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
