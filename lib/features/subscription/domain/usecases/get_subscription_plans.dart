import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/repositories/subscription_repository.dart';

class GetSubscriptionPlans {
  final SubscriptionRepository repository;

  GetSubscriptionPlans(this.repository);

  Future<Either<Failure, List<SubscriptionPlanEntity>>> call() async {
    return await repository.getSubscriptionPlans();
  }
}
