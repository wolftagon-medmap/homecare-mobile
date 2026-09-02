import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';

class GetScreeningServices {
  final HomeHealthScreeningRepository repository;

  GetScreeningServices(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call() async {
    return await repository.getScreeningServices();
  }
}