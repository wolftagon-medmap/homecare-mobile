import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/repositories/subscription_repository.dart';

class ToggleSubscriptionPlanActive {
  final SubscriptionRepository repository;

  ToggleSubscriptionPlanActive(this.repository);

  Future<Either<Failure, SubscriptionPlanEntity>> call(ToggleSubscriptionPlanActiveParams params) async {
    return await repository.toggleSubscriptionPlanActive(params.id);
  }
}

class ToggleSubscriptionPlanActiveParams extends Equatable {
  final int id;

  const ToggleSubscriptionPlanActiveParams({required this.id});

  @override
  List<Object?> get props => [id];
}
