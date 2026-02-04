import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/smoking_cessation/data/datasources/smoking_cessation_datasource.dart';
import 'package:m2health/features/smoking_cessation/data/models/smoking_cessation_plan_model.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_plan.dart';
import 'package:m2health/features/smoking_cessation/domain/repositories/smoking_cessation_repository.dart';

class SmokingCessationRepositoryImpl implements SmokingCessationRepository {
  final SmokingCessationRemoteDatasource remoteDatasource;

  SmokingCessationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, SmokingCessationPlan?>> getSmokingCessationPlan(
      int appointmentId) async {
    try {
      final result = await remoteDatasource.getSmokingCessationPlan(appointmentId);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.response?.data['message'] ?? e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
