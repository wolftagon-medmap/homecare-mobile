import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/homecare_elderly/admin/bloc/admin_homecare_state.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/get_homecare_rates.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/update_homecare_rate.dart';
import 'package:m2health/features/subscription/domain/usecases/get_subscription_plans.dart';
import 'package:m2health/features/subscription/domain/usecases/toggle_subscription_plan_active.dart';
import 'package:m2health/features/subscription/domain/usecases/update_subscription_plan.dart';

class AdminHomecareCubit extends Cubit<AdminHomecareState> {
  final GetHomecareRates getHomecareRates;
  final UpdateHomecareRate updateHomecareRate;
  final GetSubscriptionPlans getSubscriptionPlans;
  final UpdateSubscriptionPlan updateSubscriptionPlan;
  final ToggleSubscriptionPlanActive toggleSubscriptionPlanActive;

  AdminHomecareCubit({
    required this.getHomecareRates,
    required this.updateHomecareRate,
    required this.getSubscriptionPlans,
    required this.updateSubscriptionPlan,
    required this.toggleSubscriptionPlanActive,
  }) : super(const AdminHomecareState());

  Future<void> fetchData() async {
    emit(state.copyWith(isLoading: true));

    // Fetch Homecare Service Titles
    final serviceTitlesResult = await getHomecareRates();
    
    final newState = state.copyWith(isLoading: false); // Will be updated

    // Fetch Subscription Plans
    final plansResult = await getSubscriptionPlans();

    // Handle results
    serviceTitlesResult.fold(
      (l) => emit(newState.copyWith(error: l.message)),
      (r) => emit(state.copyWith(services: r)),
    );

    plansResult.fold(
      (l) => emit(state.copyWith(error: l.message, isLoading: false)),
      (r) => emit(state.copyWith(plans: r, isLoading: false)),
    );
  }

  Future<void> updateRate(int id, double price) async {
    emit(state.copyWith(actionStatus: AdminActionStatus.submitting));
    final result = await updateHomecareRate(UpdateHomecareRateParams(
      id: id,
      price: price,
    ));

    result.fold(
      (l) => emit(state.copyWith(
        actionStatus: AdminActionStatus.failure,
        actionError: l.message,
      )),
      (r) {
        emit(state.copyWith(actionStatus: AdminActionStatus.success));
        fetchData(); // Refresh
      },
    );
  }

  Future<void> updatePlan(int id, Map<String, dynamic> body) async {
    emit(state.copyWith(actionStatus: AdminActionStatus.submitting));
    final result = await updateSubscriptionPlan(UpdateSubscriptionPlanParams(
      id: id,
      body: body,
    ));

    result.fold(
      (l) => emit(state.copyWith(
        actionStatus: AdminActionStatus.failure,
        actionError: l.message,
      )),
      (r) {
        emit(state.copyWith(actionStatus: AdminActionStatus.success));
        fetchData();
      },
    );
  }

  Future<void> togglePlan(int id) async {
    emit(state.copyWith(actionStatus: AdminActionStatus.submitting));
    final result = await toggleSubscriptionPlanActive(
        ToggleSubscriptionPlanActiveParams(id: id));

    result.fold(
      (l) => emit(state.copyWith(
        actionStatus: AdminActionStatus.failure,
        actionError: l.message,
      )),
      (r) {
        emit(state.copyWith(actionStatus: AdminActionStatus.success));
        fetchData();
      },
    );
  }
}
