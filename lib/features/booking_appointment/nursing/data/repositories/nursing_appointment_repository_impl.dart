import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/usecases/create_nursing_appointment.dart';

class NursingAppointmentRepositoryImpl extends NursingAppointmentRepository {
  final AppointmentService appointmentService;

  NursingAppointmentRepositoryImpl({required this.appointmentService});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateNursingAppointmentParams params) async {
    try {
      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': params.summary,
        'request_data': {
          'service_ids': params.nursingCase.addOnServices
              .map((service) => service.id)
              .toList(),
          'personal_issue_ids':
              params.nursingCase.issues.map((issue) => issue.id).toList(),
          'mobility_status': params.nursingCase.mobilityStatus?.apiValue,
          'mobility_status_detail': params.nursingCase.mobilityStatusDetail,
          'related_health_record_id': params.nursingCase.relatedHealthRecordId,
        },
      };
      final response = await appointmentService.createAppointment(payload);
      final result = AppointmentModel.fromJson(
          response['appointment'] as Map<String, dynamic>);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
