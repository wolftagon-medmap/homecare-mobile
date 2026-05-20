import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/psychologist/domain/usecases/create_psychology_appointment.dart';

abstract class PsychologistAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreatePsychologyAppointmentParams params);
}
