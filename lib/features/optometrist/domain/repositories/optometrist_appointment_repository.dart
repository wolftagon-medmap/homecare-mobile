import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/optometrist/domain/usecases/create_optometry_appointment.dart';

abstract class OptometristAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateOptometryAppointmentParams params);
}
