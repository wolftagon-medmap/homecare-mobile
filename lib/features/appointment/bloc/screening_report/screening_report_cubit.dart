import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:meta/meta.dart';

part 'screening_report_state.dart';

class ScreeningReportCubit extends Cubit<ScreeningReportState> {
  final AppointmentService appointmentService;

  ScreeningReportCubit({required this.appointmentService})
      : super(ScreeningReportInitial());

  Future<void> fetchReports(int appointmentId) async {
    try {
      emit(ScreeningReportLoading());
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      emit(ScreeningReportError('Failed to fetch reports: $e'));
    }
  }

  Future<void> uploadReport(int appointmentId, File file) async {
    try {
      emit(ScreeningReportLoading());
      await appointmentService.uploadDiagnosticReport(appointmentId, file);
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportActionSuccess(
        'Report uploaded successfully',
        updatedAppointment: appointment,
        action: ScreeningReportAction.upload,
      ));
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      log('Error uploading: $e');
      emit(ScreeningReportError('Failed to upload report: $e'));
      fetchReports(appointmentId);
    }
  }

  Future<void> deleteReport(int appointmentId, int reportId) async {
    try {
      emit(ScreeningReportLoading());
      await appointmentService.deleteDiagnosticReport(reportId);
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportActionSuccess(
        'Report deleted successfully',
        updatedAppointment: appointment,
        action: ScreeningReportAction.delete,
      ));
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      log('Error deleting: $e');
      emit(ScreeningReportError('Failed to delete report: $e'));
      fetchReports(appointmentId);
    }
  }

  Future<void> markReady(int appointmentId) async {
    try {
      emit(ScreeningReportLoading());
      await appointmentService.updateServiceRequestStatus(
          appointmentId, 'report_ready');
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportActionSuccess(
        'Reports marked as ready',
        updatedAppointment: appointment,
        action: ScreeningReportAction.finalize,
      ));
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      log('Error marking ready: $e');
      emit(ScreeningReportError('Failed to mark ready: $e'));
      fetchReports(appointmentId);
    }
  }
}
