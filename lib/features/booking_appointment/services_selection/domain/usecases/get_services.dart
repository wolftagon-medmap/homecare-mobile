import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/services_selection/domain/repositories/services_repository.dart';

class GetServices {
  final ServicesRepository repository;

  GetServices(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call({required String category, String? subCategory}) async {
    return await repository.getServices(category: category, subCategory: subCategory);
  }
}
