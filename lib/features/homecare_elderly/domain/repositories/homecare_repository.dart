import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';

abstract class HomecareRepository {
  Future<Either<Failure, List<ServiceEntity>>> getHomecareRates();
  Future<Either<Failure, ServiceEntity>> updateHomecareRate(int id, double price);
}
