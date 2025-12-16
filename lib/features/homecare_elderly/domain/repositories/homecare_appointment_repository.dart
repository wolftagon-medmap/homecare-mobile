import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/create_homecare_appointment.dart';

abstract class HomecareAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateHomecareAppointmentParams params);
}
