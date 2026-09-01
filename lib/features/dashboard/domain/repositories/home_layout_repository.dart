import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';

abstract class HomeLayoutRepository {
  /// The layout this device last chose, falling back to the grid.
  Future<Either<Failure, HomeServicesLayout>> getLayout();

  Future<Either<Failure, Unit>> setLayout(HomeServicesLayout layout);
}
