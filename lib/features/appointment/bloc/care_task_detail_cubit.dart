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
