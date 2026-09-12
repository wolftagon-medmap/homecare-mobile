import 'package:equatable/equatable.dart';

class SubscriptionPlanEntity extends Equatable {
  final int id;
  final String name;
  final double price;
  final int quotaAmount;
  final String quotaUnit;
  final int validityDays;
  final bool isActive;

  const SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.quotaAmount,
    required this.quotaUnit,
    required this.validityDays,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        quotaAmount,
        quotaUnit,
        validityDays,
        isActive,
      ];
}
