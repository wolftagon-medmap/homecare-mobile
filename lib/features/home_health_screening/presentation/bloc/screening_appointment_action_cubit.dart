import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';

part 'screening_appointment_action_state.dart';

class ScreeningAppointmentActionCubit
    extends Cubit<ScreeningAppointmentActionState> {
  final HomeHealthScreeningRepository repository;

  ScreeningAppointmentActionCubit({required this.repository})
      : super(ScreeningAppointmentActionInitial());

  Future<void> acceptScreeningRequest(int screeningRequestId) async {
    log('Accepting appointment of screening request (id: $screeningRequestId)',
        name: 'ScreeningAppointmentActionCubit');
    emit(ScreeningAppointmentActionLoading());
    final result = await repository.acceptScreeningRequest(screeningRequestId);
    result.fold(
      (failure) {
        log('Failed to accept screening request: ${failure.toString()}',
            name: 'ScreeningAppointmentActionCubit');
        emit(const ScreeningAppointmentActionError(
            "Failed to accept appointment"));
      },
      (_) {
        emit(const ScreeningAppointmentActionSuccess(
          message: "Appointment accepted successfully",
        ));
      },
    );
  }

  Future<void> confirmSampleCollected(int screeningRequestId) async {
    log('Confirming sample collected for screening request (id: $screeningRequestId)',
        name: 'ScreeningAppointmentActionCubit');
    emit(ScreeningAppointmentActionLoading());
    final result = await repository.confirmSampleCollected(screeningRequestId);
    result.fold(
      (failure) {
        log('Failed to confirm sample collection: ${failure.toString()}',
            name: 'ScreeningAppointmentActionCubit');
        emit(const ScreeningAppointmentActionError(
            "Failed to confirm sample collection"));
      },
      (_) {
        emit(const ScreeningAppointmentActionSuccess(
          message: "Sample collection confirmed successfully",
        ));
      },
    );
  }

  Future<void> markScreeningReportReady(int screeningRequestId) async {
    log('Marking screening report ready for screening request (id: $screeningRequestId)',
        name: 'ScreeningAppointmentActionCubit');
    emit(ScreeningAppointmentActionLoading());
    final result =
        await repository.markScreeningReportReady(screeningRequestId);
    result.fold(
      (failure) {
        log('Failed to mark report ready: ${failure.toString()}',
            name: 'ScreeningAppointmentActionCubit');
        emit(const ScreeningAppointmentActionError(
            "Failed to mark report as ready"));
      },
      (_) {
        emit(const ScreeningAppointmentActionSuccess(
          message: "Report marked as ready successfully",
        ));
      },
    );
  }
}
