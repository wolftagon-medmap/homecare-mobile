import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_repository.dart';

class GetHomecareRates {
  final HomecareRepository repository;

  GetHomecareRates(this.repository);

  Future<Either<Failure, List<AddOnService>>> call() async {
    return await repository.getHomecareRates();
  }
}
