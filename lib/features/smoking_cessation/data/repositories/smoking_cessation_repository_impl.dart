import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/smoking_cessation/data/datasources/smoking_cessation_datasource.dart';
import 'package:m2health/features/smoking_cessation/data/models/smoking_cessation_plan_model.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_plan.dart';
import 'package:m2health/features/smoking_cessation/domain/repositories/smoking_cessation_repository.dart';

class SmokingCessationRepositoryImpl implements SmokingCessationRepository {
  final SmokingCessationRemoteDatasource remoteDatasource;
  final AppointmentService appointmentService;

  SmokingCessationRepositoryImpl({
    required this.remoteDatasource,
    required this.appointmentService,
  });

  @override
  Future<Either<Failure, SmokingCessationPlan?>> getSmokingCessationPlan(
      int appointmentId) async {
    try {
      final result =
          await remoteDatasource.getSmokingCessationPlan(appointmentId);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.response?.data['message'] ?? e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createSmokingCessationCarePlan(
      int appointmentId, SmokingCessationPlan plan) async {
    try {
      final activities = <Map<String, dynamic>>[];
      if (plan.targetQuitDate != null) {
        activities.add({
          'type': 'advice',
          'description':
              'Target quit date: ${plan.targetQuitDate!.toIso8601String().split('T').first}',
          'scheduled_date': plan.targetQuitDate!.toIso8601String(),
          'status': 'not_started',
        });
      }
      if (plan.medicationName != null) {
        activities.add({
          'type': 'medication',
          'description':
              '${plan.medicationName}${plan.medicationInstructions != null ? ': ${plan.medicationInstructions}' : ''}',
          'status': 'not_started',
        });
      }
      if (plan.adviceNote != null) {
        activities.add({
          'type': 'advice',
          'description': plan.adviceNote!,
          'status': 'not_started',
        });
      }
      if (plan.followUpDate != null) {
        activities.add({
          'type': 'follow_up',
          'description': 'Follow-up appointment',
          'scheduled_date': plan.followUpDate!.toIso8601String(),
          'status': 'not_started',
        });
      }
      await appointmentService.createCarePlan(appointmentId, {
        'type': 'smoking_cessation',
        'title': 'Smoking Cessation Plan',
        'status': 'active',
        if (activities.isNotEmpty) 'activities': activities,
      });
      return const Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.response?.data['message'] ?? e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @Deprecated('Use createSmokingCessationCarePlan. TODO: delete.')
  Future<Either<Failure, Unit>> submitSmokingCessationPlan(
      int appointmentId, SmokingCessationPlan plan) async {
    try {
      final model = SmokingCessationPlanModel.fromEntity(plan);
      await remoteDatasource.submitSmokingCessationPlan(appointmentId, model);
      return const Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.response?.data['message'] ?? e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
