import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_plan.dart';
import 'package:m2health/features/smoking_cessation/domain/repositories/smoking_cessation_repository.dart';
import 'package:equatable/equatable.dart';

part 'smoking_cessation_plan_state.dart';

class SmokingCessationPlanCubit extends Cubit<SmokingCessationPlanState> {
  final SmokingCessationRepository _repository;

  final int appointmentId;

  SmokingCessationPlanCubit(this._repository, this.appointmentId)
      : super(const SmokingCessationPlanState());

  void updatePlan(SmokingCessationPlan plan) {
    emit(state.copyWith(plan: plan));
  }

  void togglePrescribeMedication(bool value) {
    emit(state.copyWith(prescribeMedication: value));
  }

  Future<void> fetchPlan() async {
    emit(state.copyWith(fetchStatus: SmokingCessationPlanStatus.loading));

    final result = await _repository.getSmokingCessationPlan(appointmentId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          fetchStatus: SmokingCessationPlanStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (plan) {
        if (plan != null) {
          emit(state.copyWith(
            plan: plan,
            prescribeMedication: plan.medicationName != null,
            fetchStatus: SmokingCessationPlanStatus.success,
          ));
        } else {
          emit(state.copyWith(fetchStatus: SmokingCessationPlanStatus.success));
        }
      },
    );
  }

  Future<void> submitPlan() async {
    emit(state.copyWith(submitStatus: SmokingCessationPlanStatus.loading));

    var planToSubmit = state.plan;

    if (!state.prescribeMedication) {
      planToSubmit = planToSubmit.copyWith(
        medicationName: null,
        medicationInstructions: null,
      );
    }

    final result = await _repository.submitSmokingCessationPlan(
        appointmentId, planToSubmit);

    result.fold(
      (failure) {
        emit(state.copyWith(
          submitStatus: SmokingCessationPlanStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(submitStatus: SmokingCessationPlanStatus.success));
      },
    );
  }
}
