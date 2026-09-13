import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';
import 'package:m2health/features/appointment/data/patient_inbox_service.dart';
import 'package:m2health/features/appointment/data/fixtures/inbox_demo_fixture.dart';

part 'patient_inbox_state.dart';

/// Drives the patient Pending tab: loads the pre-acceptance care-task inbox.
/// Items are tap-to-detail only; cancel/reschedule/pay live on the care-task
/// detail page once a booking has an appointment behind it.
class PatientInboxCubit extends Cubit<PatientInboxState> {
  final PatientInboxService _inbox;

  PatientInboxCubit(Dio dio)
      : _inbox = PatientInboxService(dio),
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
}
