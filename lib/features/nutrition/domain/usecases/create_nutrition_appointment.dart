import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nutrition/domain/repositories/nutrition_appointment_repository.dart';

class CreateNutritionAppointment {
  final NutritionAppointmentRepository repository;

  CreateNutritionAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateNutritionAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateNutritionAppointmentParams extends Equatable {
  final String type = 'nutrition';
  final int providerId;
  final DateTime startDatetime;
  final int questionnaireResponseId;

  String get summary => 'Precision Nutrition Consultation';

  const CreateNutritionAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.questionnaireResponseId,
  });

  @override
  List<Object?> get props =>
      [type, providerId, startDatetime, questionnaireResponseId];
}
