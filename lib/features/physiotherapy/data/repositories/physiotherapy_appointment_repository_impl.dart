import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/physiotherapy/domain/repositories/physiotherapy_appointment_repository.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/physiotherapy/domain/usecases/create_physiotherapy_appointment.dart';

class PhysiotherapyAppointmentRepositoryImpl extends PhysiotherapyAppointmentRepository {
  final AppointmentService appointmentService;

  PhysiotherapyAppointmentRepositoryImpl({required this.appointmentService});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreatePhysiotherapyAppointmentParams params) async {
    try {
      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'provider_type': params.providerType,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': params.summary,
        'pay_total': params.payTotal,
        'physiotherapy_request_data': {
          'duration': params.duration,
          'service_code': params.serviceCode,
        },
      };
      final response = await appointmentService.createAppointment(payload);
      final result = AppointmentModel.fromJson(response);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
