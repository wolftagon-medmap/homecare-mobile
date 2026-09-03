import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';
import 'package:m2health/features/appointment/data/patient_inbox_service.dart';
import 'package:m2health/features/appointment/data/fixtures/inbox_demo_fixture.dart';

part 'patient_inbox_state.dart';

/// Drives the patient Pending tab: loads the unified inbox (v1 pending
/// appointments + v2 pre-acceptance care tasks). Appointment actions go through
/// [AppointmentService]; care-task items are tap-to-detail only.
class PatientInboxCubit extends Cubit<PatientInboxState> {
  final PatientInboxService _inbox;
  final AppointmentService _appointments;

  PatientInboxCubit(Dio dio)
      : _inbox = PatientInboxService(dio),
        _appointments = AppointmentService(dio),
        super(PatientInboxInitial());

  Future<void> fetchInbox() async {
    if (!AppFlags.remote(Feature.timeProposal)) {
      emit(PatientInboxLoaded(
          kPatientInboxDemoFixture().map(PatientInboxItem.fromJson).toList()));
      return;
    }
    try {
      emit(PatientInboxLoading());
      emit(PatientInboxLoaded(await _inbox.fetchInbox()));
    } catch (e, stackTrace) {
      log('Error fetching patient inbox: $e',
          name: 'PatientInboxCubit', error: e, stackTrace: stackTrace);
      emit(PatientInboxError('Failed to load pending bookings'));
    }
  }

  Future<void> cancelAppointment(
    int appointmentId, {
    required String cancellationReason,
    String? otherReason,
  }) async {
    try {
      await _appointments.cancelAppointment(
        appointmentId,
        cancellationReason: cancellationReason,
        otherReason: otherReason,
      );
      emit(PatientInboxActionSucceed('Booking cancelled'));
      await fetchInbox();
    } catch (e, stackTrace) {
      log('Error cancelling appointment: $e',
          name: 'PatientInboxCubit', error: e, stackTrace: stackTrace);
      emit(PatientInboxError('Cancellation failed. Please try again.'));
    }
  }

  /// The full appointment entity behind an inbox item — reschedule and payment
  /// navigation need more than the inbox summary carries.
  Future<AppointmentEntity?> loadAppointment(int appointmentId) async {
    try {
      return await _appointments.fetchAppointmentDetail(appointmentId);
    } catch (e, stackTrace) {
      log('Error loading appointment $appointmentId: $e',
          name: 'PatientInboxCubit', error: e, stackTrace: stackTrace);
      emit(PatientInboxError('Failed to open booking. Please try again.'));
      return null;
    }
  }
}
