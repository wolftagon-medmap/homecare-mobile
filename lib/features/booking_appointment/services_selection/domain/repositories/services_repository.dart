import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';

abstract class ServicesRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServices(String serviceType);
}
