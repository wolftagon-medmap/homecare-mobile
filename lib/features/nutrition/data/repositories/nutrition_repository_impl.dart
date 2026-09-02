import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nutrition/data/datasources/nutrition_datasource.dart';
import 'package:m2health/features/nutrition/data/models/nutrition_plan_model.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_assessment_data.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_plan.dart';
import 'package:m2health/features/nutrition/domain/repositories/nutrition_repository.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';

class NutritionRepositoryImpl extends NutritionRepository {
  final AppointmentService appointmentService;
  final NutritionDatasource nutritionDatasource;

  NutritionRepositoryImpl(
      {required this.appointmentService, required this.nutritionDatasource});

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

  @override
  Future<Either<Failure, int>> getLatestNutritionAppointmentId() async {
    try {
      final id = await nutritionDatasource.getLatestNutritionAppointmentId();
      if (id == null) {
        return const Left(NotFoundFailure('No nutrition appointment found'));
      }
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionPlan>> getNutritionPlan(
      int appointmentId) async {
    try {
      final response =
          await nutritionDatasource.getNutritionPlan(appointmentId);
      log('Raw response for appointmentId $appointmentId: ${response.toString()}',
          name: 'NutritionRepositoryImpl.getNutritionPlan');
      final plan = NutritionPlanModel.fromJson(response);
      log('After mapping $appointmentId: ${plan.toString()}',
          name: 'NutritionRepositoryImpl.getNutritionPlan');
      return Right(plan);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const Left(NotFoundFailure());
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitNutritionPlan(
      int appointmentId, NutritionPlan plan) async {
    try {
      final payload = NutritionPlanModel.fromEntity(plan).toJson();
      await nutritionDatasource.submitNutritionPlan(appointmentId, payload);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionAssessmentData>> getPatientAssessmentData(
      int questionnaireResponseId) async {
    try {
      final data = await nutritionDatasource
          .getPatientAssessmentData(questionnaireResponseId);
      if (data == null) {
        return const Left(NotFoundFailure('No assessment data found'));
      }
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
