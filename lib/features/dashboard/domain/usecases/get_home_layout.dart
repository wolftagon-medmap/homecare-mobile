import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/domain/repositories/home_layout_repository.dart';

class GetHomeLayout {
  final HomeLayoutRepository repository;

  GetHomeLayout(this.repository);

  Future<Either<Failure, HomeServicesLayout>> call() async {
    return await repository.getLayout();
  }
}
