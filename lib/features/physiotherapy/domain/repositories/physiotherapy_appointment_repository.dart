import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/physiotherapy/domain/usecases/create_physiotherapy_appointment.dart';

abstract class PhysiotherapyAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreatePhysiotherapyAppointmentParams data);
}
