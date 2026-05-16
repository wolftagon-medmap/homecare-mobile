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

  // ── v2 methods (use appointmentId, not screeningRequestId) ────────────────

  Future<void> acceptRequest(int appointmentId) async {
    log('Accepting screening request for appointment (id: $appointmentId)',
        name: 'ScreeningAppointmentActionCubit');
    emit(ScreeningAppointmentActionLoading());
    final result = await repository.updateServiceRequestStatus(
        appointmentId, 'request_accepted');
    result.fold(
      (failure) => emit(ScreeningAppointmentActionError(failure.message)),
      (_) => emit(const ScreeningAppointmentActionSuccess(
          message: 'Appointment accepted successfully')),
    );
  }

  Future<void> confirmSampleCollected(int appointmentId) async {
    log('Confirming sample collected for appointment (id: $appointmentId)',
        name: 'ScreeningAppointmentActionCubit');
    emit(ScreeningAppointmentActionLoading());
    final result = await repository.updateServiceRequestStatus(
        appointmentId, 'sample_collected');
    result.fold(
      (failure) => emit(ScreeningAppointmentActionError(failure.message)),
      (_) => emit(const ScreeningAppointmentActionSuccess(
          message: 'Sample collection confirmed successfully')),
    );
  }

  Future<void> markReportReady(int appointmentId) async {
    log('Marking report ready for appointment (id: $appointmentId)',
        name: 'ScreeningAppointmentActionCubit');
    emit(ScreeningAppointmentActionLoading());
    final result = await repository.updateServiceRequestStatus(
        appointmentId, 'report_ready');
    result.fold(
      (failure) => emit(ScreeningAppointmentActionError(failure.message)),
      (_) => emit(const ScreeningAppointmentActionSuccess(
          message: 'Report marked as ready successfully')),
    );
  }

  // ── Deprecated (use screeningRequestId — no longer valid in v2) ───────────

  @Deprecated('Use acceptRequest(appointmentId). TODO: delete.')
  Future<void> acceptScreeningRequestV1(int screeningRequestId) async {
    emit(ScreeningAppointmentActionLoading());
    // ignore: deprecated_member_use
    final result = await repository.acceptScreeningRequest(screeningRequestId);
    result.fold(
      (failure) => emit(ScreeningAppointmentActionError(failure.message)),
      (_) => emit(const ScreeningAppointmentActionSuccess(
          message: 'Appointment accepted successfully')),
    );
  }

  @Deprecated('Use confirmSampleCollectedV2(appointmentId). TODO: delete.')
  Future<void> confirmSampleCollectedV1(int screeningRequestId) async {
    emit(ScreeningAppointmentActionLoading());
    // ignore: deprecated_member_use
    final result = await repository.confirmSampleCollected(screeningRequestId);
    result.fold(
      (failure) => emit(ScreeningAppointmentActionError(failure.message)),
      (_) => emit(const ScreeningAppointmentActionSuccess(
          message: 'Sample collection confirmed successfully')),
    );
  }

  @Deprecated('Use markReportReady(appointmentId). TODO: delete.')
  Future<void> markScreeningReportReadyV1(int screeningRequestId) async {
    emit(ScreeningAppointmentActionLoading());
    // ignore: deprecated_member_use
    final result =
        await repository.markScreeningReportReady(screeningRequestId);
    result.fold(
      (failure) => emit(ScreeningAppointmentActionError(failure.message)),
      (_) => emit(const ScreeningAppointmentActionSuccess(
          message: 'Report marked as ready successfully')),
    );
  }
}
