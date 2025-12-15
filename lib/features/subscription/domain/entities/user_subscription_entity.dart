import 'package:equatable/equatable.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';

class UserSubscriptionEntity extends Equatable {
  final int id;
  final int userId;
  final int subscriptionPlanId;
  final int totalPurchasedUnits;
  final int remainingUnits;
  final DateTime startsAt;
  final DateTime expiresAt;
  final bool isActive;
  final SubscriptionPlanEntity? plan;

  const UserSubscriptionEntity({
    required this.id,
    required this.userId,
    required this.subscriptionPlanId,
    required this.totalPurchasedUnits,
    required this.remainingUnits,
    required this.startsAt,
    required this.expiresAt,
    required this.isActive,
    this.plan,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        subscriptionPlanId,
        totalPurchasedUnits,
        remainingUnits,
        startsAt,
        expiresAt,
        isActive,
        plan,
      ];
}
