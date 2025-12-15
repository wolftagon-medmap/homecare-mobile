import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';
import 'package:m2health/features/subscription/domain/repositories/subscription_repository.dart';

class PurchaseSubscription {
  final SubscriptionRepository repository;

  PurchaseSubscription(this.repository);

  Future<Either<Failure, UserSubscriptionEntity>> call(
      PurchaseSubscriptionParams params) async {
    return await repository.purchaseSubscription(params.planId);
  }
}

class PurchaseSubscriptionParams extends Equatable {
  final int planId;

  const PurchaseSubscriptionParams({required this.planId});

  @override
  List<Object?> get props => [planId];
}
