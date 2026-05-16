import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_assessment_data.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_plan.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';

abstract class NutritionRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateNutritionAppointmentParams data);

  Future<Either<Failure, int>> getLatestNutritionAppointmentId();
  Future<Either<Failure, NutritionPlan>> getNutritionPlan(int appointmentId);
  Future<Either<Failure, Unit>> submitNutritionPlan(
      int appointmentId, NutritionPlan plan);
  Future<Either<Failure, NutritionAssessmentData>> getPatientAssessmentData(
      int questionnaireResponseId);
}
