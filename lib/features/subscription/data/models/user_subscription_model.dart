import 'package:m2health/features/subscription/data/models/subscription_plan_model.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';

class UserSubscriptionModel extends UserSubscriptionEntity {
  const UserSubscriptionModel({
    required super.id,
    required super.userId,
    required super.subscriptionPlanId,
    required super.totalPurchasedUnits,
    required super.remainingUnits,
    required super.startsAt,
    required super.expiresAt,
    required super.isActive,
    super.plan,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionModel(
      id: json['id'],
      userId: json['user_id'],
      subscriptionPlanId: json['subscription_plan_id'],
      totalPurchasedUnits: json['total_purchased_units'],
      remainingUnits: json['remaining_units'],
      startsAt: DateTime.parse(json['starts_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      isActive: json['is_active'],
      plan: json['plan'] != null
          ? SubscriptionPlanModel.fromJson(json['plan'])
          : null,
    );
  }
}
