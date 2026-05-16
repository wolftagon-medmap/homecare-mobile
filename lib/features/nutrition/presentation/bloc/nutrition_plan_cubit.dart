import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_plan.dart';
import 'package:m2health/features/nutrition/domain/repositories/nutrition_repository.dart';

// --- ENUMS ---

enum NutritionPlanStatus {
  initial,
  loading,
  noAppointment,
  notFound,
  submitting,
  submitted,
  success,
  failure,
}

// --- STATE ---

class NutritionPlanState extends Equatable {
  final NutritionPlanStatus status;
  final int? appointmentId;
  final NutritionPlan? nutritionPlan;
  final String? errorMessage;

  const NutritionPlanState({
    this.status = NutritionPlanStatus.initial,
    this.appointmentId,
    this.nutritionPlan,
    this.errorMessage,
  });

  NutritionPlanState copyWith({
    NutritionPlanStatus? status,
    int? appointmentId,
    NutritionPlan? nutritionPlan,
    String? errorMessage,
  }) {
    return NutritionPlanState(
      status: status ?? this.status,
      appointmentId: appointmentId ?? this.appointmentId,
      nutritionPlan: nutritionPlan ?? this.nutritionPlan,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, appointmentId, nutritionPlan, errorMessage];
}

// --- CUBIT ---

class NutritionPlanCubit extends Cubit<NutritionPlanState> {
  final NutritionRepository repository;

  NutritionPlanCubit(this.repository) : super(const NutritionPlanState());

  Future<void> loadNutritionPlan({int? knownAppointmentId}) async {
    emit(state.copyWith(status: NutritionPlanStatus.loading));
    try {
      final int appointmentId;
      if (knownAppointmentId != null) {
        appointmentId = knownAppointmentId;
      } else {
        final idResult = await repository.getLatestNutritionAppointmentId();
        final resolved = idResult.fold((_) => null, (id) => id);
        if (resolved == null) {
          emit(state.copyWith(status: NutritionPlanStatus.noAppointment));
          return;
        }
        appointmentId = resolved;
      }

      final planResult = await repository.getNutritionPlan(appointmentId);
      planResult.fold(
        (failure) {
          if (failure is NotFoundFailure) {
            emit(state.copyWith(
              status: NutritionPlanStatus.notFound,
              appointmentId: appointmentId,
            ));
          } else {
            log(failure.message, name: 'NutritionPlanCubit');
            emit(state.copyWith(
              status: NutritionPlanStatus.failure,
              errorMessage: failure.message,
            ));
          }
        },
        (plan) => emit(state.copyWith(
          status: NutritionPlanStatus.success,
          appointmentId: appointmentId,
          nutritionPlan: plan,
        )),
      );
    } catch (e, stackTrace) {
      log('Unexpected error loading nutrition plan',
          name: 'NutritionPlanCubit', error: e, stackTrace: stackTrace);
      emit(state.copyWith(
        status: NutritionPlanStatus.failure,
        errorMessage: 'Failed to load nutrition plan.',
      ));
    }
  }

  Future<void> submitNutritionPlan(
      int appointmentId, NutritionPlan plan) async {
    emit(state.copyWith(status: NutritionPlanStatus.submitting));
    final result = await repository.submitNutritionPlan(appointmentId, plan);
    result.fold(
      (failure) {
        log(failure.message, name: 'NutritionPlanCubit');
        emit(state.copyWith(
          status: NutritionPlanStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (_) => emit(state.copyWith(status: NutritionPlanStatus.submitted)),
    );
  }
}
