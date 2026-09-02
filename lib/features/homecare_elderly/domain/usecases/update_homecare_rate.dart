import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_repository.dart';

class UpdateHomecareRate {
  final HomecareRepository repository;

  UpdateHomecareRate(this.repository);

  Future<Either<Failure, ServiceEntity>> call(UpdateHomecareRateParams params) async {
    return await repository.updateHomecareRate(params.id, params.price);
  }
}

class UpdateHomecareRateParams extends Equatable {
  final int id;
  final double price;

  const UpdateHomecareRateParams({required this.id, required this.price});

  @override
  List<Object?> get props => [id, price];
}
