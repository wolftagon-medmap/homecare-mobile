import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';

abstract class NutritionAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateNutritionAppointmentParams data);
}
