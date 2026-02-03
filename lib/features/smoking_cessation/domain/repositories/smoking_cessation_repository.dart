import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_plan.dart';

abstract class SmokingCessationRepository {
  Future<Either<Failure, SmokingCessationPlan?>> getSmokingCessationPlan(
      int appointmentId);
  Future<Either<Failure, Unit>> submitSmokingCessationPlan(
      int appointmentId, SmokingCessationPlan plan);
}
