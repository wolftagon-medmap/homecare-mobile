import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:m2health/features/appointment/data/models/patient_care_task_detail.dart';
import 'package:m2health/features/appointment/data/patient_inbox_service.dart';

part 'care_task_detail_state.dart';

/// Drives the pre-acceptance care-task detail page.
class CareTaskDetailCubit extends Cubit<CareTaskDetailState> {
  final PatientInboxService _inbox;

  CareTaskDetailCubit(Dio dio)
      : _inbox = PatientInboxService(dio),
        super(CareTaskDetailInitial());

  /// Ask again at a new time. Reloads either way: the booking is unchanged
  /// when nobody is found, and the page has to say so rather than look busy.
  Future<CareTaskRetryOutcome> retryAtNewTime(
    int careTaskId, {
    required DateTime start,
  }) async {
    try {
      final asked = await _inbox.retryAtNewTime(careTaskId, start: start);
      await fetchDetail(careTaskId);
      return asked > 0
          ? CareTaskRetryOutcome.asked
          : CareTaskRetryOutcome.nobodyAvailable;
    } catch (e, stackTrace) {
      log('Error retrying care task: $e',
          name: 'CareTaskDetailCubit', error: e, stackTrace: stackTrace);
      await fetchDetail(careTaskId);
      return CareTaskRetryOutcome.failed;
    }
  }

  Future<void> fetchDetail(int careTaskId) async {
    try {
      emit(CareTaskDetailLoading());
      final detail = await _inbox.fetchCareTaskDetail(careTaskId);
      emit(CareTaskDetailLoaded(detail));
    } catch (e, stackTrace) {
      log('Error fetching care task detail: $e',
          name: 'CareTaskDetailCubit', error: e, stackTrace: stackTrace);
      emit(CareTaskDetailError('Failed to load booking detail'));
    }
  }
}
