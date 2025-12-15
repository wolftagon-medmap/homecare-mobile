import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:m2health/features/subscription/domain/entities/user_subscription_entity.dart';
import 'package:m2health/features/subscription/domain/usecases/get_subscription_plans.dart';
import 'package:m2health/features/subscription/domain/usecases/get_user_subscriptions.dart';
import 'package:m2health/features/subscription/domain/usecases/purchase_subscription.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetSubscriptionPlans getSubscriptionPlans;
  final GetUserSubscriptions getUserSubscriptions;
  final PurchaseSubscription purchaseSubscription;

  SubscriptionCubit({
    required this.getSubscriptionPlans,
    required this.getUserSubscriptions,
    required this.purchaseSubscription,
  }) : super(const SubscriptionState());

  Future<void> fetchSubscriptionData() async {
    emit(state.copyWith(status: SubscriptionStatus.loading));

    final results = await Future.wait([
      getSubscriptionPlans(),
      getUserSubscriptions(),
    ]);

    final plansResult = results[0]
        as Either<Failure, List<SubscriptionPlanEntity>>;
    final subsResult = results[1]
        as Either<Failure, List<UserSubscriptionEntity>>;

    List<SubscriptionPlanEntity> plans = state.plans;
    List<UserSubscriptionEntity> subs = state.userSubscriptions;
    String? error;

    plansResult.fold(
      (l) => error = l.message,
      (r) => plans = r,
    );

    subsResult.fold(
      (l) => error ??= l.message, // Keep first error
      (r) => subs = r,
    );

    if (error != null) {
      emit(state.copyWith(
          status: SubscriptionStatus.error, errorMessage: error));
    } else {
      emit(state.copyWith(
        status: SubscriptionStatus.loaded,
        plans: plans,
        userSubscriptions: subs,
      ));
    }
  }

  Future<void> refreshBalance() async {
      // Just refresh user subs, silent update
      final subsResult = await getUserSubscriptions();
      subsResult.fold(
        (l) => null,
        (r) => emit(state.copyWith(userSubscriptions: r)),
      );
  }

  Future<void> purchase(int planId) async {
    emit(state.copyWith(
        purchaseStatus: SubscriptionPurchaseStatus.submitting,
        purchaseErrorMessage: null));

    final result = await purchaseSubscription(
        PurchaseSubscriptionParams(planId: planId));

    result.fold(
      (l) => emit(state.copyWith(
        purchaseStatus: SubscriptionPurchaseStatus.failure,
        purchaseErrorMessage: l.message,
      )),
      (r) async {
        // Success
        emit(state.copyWith(purchaseStatus: SubscriptionPurchaseStatus.success));
        
        // Refresh subscriptions to update balance
        await refreshBalance();

        // Reset status after a delay to allow UI to show success
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(
            purchaseStatus: SubscriptionPurchaseStatus.initial));
      },
    );
  }
}
