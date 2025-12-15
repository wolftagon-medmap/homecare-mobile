import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  const SubscriptionPlanModel({
    required super.id,
    required super.name,
    required super.price,
    required super.quotaAmount,
    required super.quotaUnit,
    required super.validityDays,
    required super.isActive,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      quotaAmount: json['quota_amount'],
      quotaUnit: json['quota_unit'],
      validityDays: json['validity_days'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quota_amount': quotaAmount,
      'quota_unit': quotaUnit,
      'validity_days': validityDays,
      'is_active': isActive,
    };
  }
}
