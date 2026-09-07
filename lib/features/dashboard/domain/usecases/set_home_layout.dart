import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/domain/repositories/home_layout_repository.dart';

class SetHomeLayout {
  final HomeLayoutRepository repository;

  SetHomeLayout(this.repository);

  Future<Either<Failure, Unit>> call(HomeServicesLayout layout) async {
    return await repository.setLayout(layout);
  }
}
