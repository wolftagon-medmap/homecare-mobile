import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nutrition/domain/repositories/nutrition_appointment_repository.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';

class NutritionAppointmentRepositoryImpl
    extends NutritionAppointmentRepository {
  final AppointmentService appointmentService;

  NutritionAppointmentRepositoryImpl({required this.appointmentService});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateNutritionAppointmentParams params) async {
    try {
      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': params.summary,
        'request_data': {
          'questionnaire_response_id': params.questionnaireResponseId,
        },
      };
      final response = await appointmentService.createAppointment(payload);
      final result = AppointmentModel.fromJson({
        ...response['appointment'] as Map<String, dynamic>,
        if (response['order'] != null) 'order': response['order'],
      });
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
