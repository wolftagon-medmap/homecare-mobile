import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionPlanEntity>>> getSubscriptionPlans();
  Future<Either<Failure, List<UserSubscriptionEntity>>> getUserSubscriptions();
  Future<Either<Failure, UserSubscriptionEntity>> purchaseSubscription(int planId);
  
  // Admin
  Future<Either<Failure, SubscriptionPlanEntity>> createSubscriptionPlan(Map<String, dynamic> body);
  Future<Either<Failure, SubscriptionPlanEntity>> updateSubscriptionPlan(int id, Map<String, dynamic> body);
  Future<Either<Failure, SubscriptionPlanEntity>> toggleSubscriptionPlanActive(int id);
}
