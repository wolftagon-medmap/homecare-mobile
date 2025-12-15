import 'package:equatable/equatable.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';

enum SubscriptionStatus { initial, loading, loaded, error }

enum SubscriptionPurchaseStatus { initial, submitting, success, failure }

class SubscriptionState extends Equatable {
  final SubscriptionStatus status;
  final List<SubscriptionPlanEntity> plans;
  final List<UserSubscriptionEntity> userSubscriptions;
  final SubscriptionPurchaseStatus purchaseStatus;
  final String? errorMessage;
  final String? purchaseErrorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.plans = const [],
    this.userSubscriptions = const [],
    this.purchaseStatus = SubscriptionPurchaseStatus.initial,
    this.errorMessage,
    this.purchaseErrorMessage,
  });

  // Helper to get total balance (assuming logic: sum of remainingUnits of active subscriptions)
  int get totalBalance {
    // Filter active and non-expired subscriptions
    final active = userSubscriptions.where((sub) {
      final now = DateTime.now();
      return sub.isActive && sub.expiresAt.isAfter(now);
    });
    // Sum remaining units
    return active.fold(0, (sum, sub) => sum + sub.remainingUnits);
  }

  // Helper to check if user has active subscription
  bool get hasActiveSubscription => totalBalance > 0;

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<SubscriptionPlanEntity>? plans,
    List<UserSubscriptionEntity>? userSubscriptions,
    SubscriptionPurchaseStatus? purchaseStatus,
    String? errorMessage,
    String? purchaseErrorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      userSubscriptions: userSubscriptions ?? this.userSubscriptions,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      purchaseErrorMessage: purchaseErrorMessage ?? this.purchaseErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        plans,
        userSubscriptions,
        purchaseStatus,
        errorMessage,
        purchaseErrorMessage,
      ];
}
