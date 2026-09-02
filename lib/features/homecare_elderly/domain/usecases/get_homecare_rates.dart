import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_repository.dart';

class GetHomecareRates {
  final HomecareRepository repository;

  GetHomecareRates(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call() async {
    return await repository.getHomecareRates();
  }
}
