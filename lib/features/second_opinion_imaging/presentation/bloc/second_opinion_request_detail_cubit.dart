import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/features/second_opinion_imaging/domain/repositories/second_opinion_imaging_repository.dart';

part 'second_opinion_request_detail_state.dart';

class SecondOpinionRequestDetailCubit
    extends Cubit<SecondOpinionRequestDetailState> {
  final SecondOpinionImagingRepository repository;

  SecondOpinionRequestDetailCubit({required this.repository})
      : super(const SecondOpinionRequestDetailState());

  Future<void> submitFeedback({
    required int appointmentId,
    required String diagnosticOpinion,
    required String recommendationOpinion,
  }) async {
    log('Submitting medical opinion for appointment $appointmentId',
        name: 'SecondOpinionRequestDetailCubit');
    emit(state.copyWith(submissionStatus: ActionStatus.loading));

    final result = await repository.createDiagnosticReport(
      appointmentId: appointmentId,
      conclusion: diagnosticOpinion,
      recommendation: recommendationOpinion,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        submissionStatus: ActionStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(submissionStatus: ActionStatus.success)),
    );
  }
}
