import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/smoking_cessation/data/models/smoking_cessation_form_model.dart';
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
        'provider_type': params.providerType,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': isSmokingCessation ? 'Smoking Cessation' : params.summary,
        'pay_total': params.payTotal,
        'pharmacy_request_data': {
          'service_type': pharmacyCase.serviceType,
          if (!isSmokingCessation) ...{
            'mobility_status': pharmacyCase.mobilityStatus?.apiValue,
            'related_health_record_id': pharmacyCase.relatedHealthRecordId,
            'add_on_service_ids': pharmacyCase.addOnServices
                .map((service) => service.id)
                .toList(),
            'personal_issue_ids':
                pharmacyCase.issues.map((issue) => issue.id).toList(),
          },
          if (isSmokingCessation && pharmacyCase.smokingCessationForm != null)
            'smoking_cessation_form': SmokingCessationFormModel.fromEntity(
                    pharmacyCase.smokingCessationForm!)
                .toJson(),
        },
      };
      final response = await appointmentService.createAppointment(payload);
      final result = AppointmentModel.fromJson(response);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
