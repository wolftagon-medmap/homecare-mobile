import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/repositories/subscription_repository.dart';

class UpdateSubscriptionPlan {
  final SubscriptionRepository repository;

  UpdateSubscriptionPlan(this.repository);

  Future<Either<Failure, SubscriptionPlanEntity>> call(UpdateSubscriptionPlanParams params) async {
    return await repository.updateSubscriptionPlan(params.id, params.body);
  }
}

class UpdateSubscriptionPlanParams extends Equatable {
  final int id;
  final Map<String, dynamic> body;

  const UpdateSubscriptionPlanParams({required this.id, required this.body});

  @override
  List<Object?> get props => [id, body];
}
