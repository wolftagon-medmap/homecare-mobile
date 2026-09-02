import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_form.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/usecases/create_pharmacy_appointment.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

part 'smoking_cessation_flow_state.dart';

class SmokingCessationFlowCubit extends Cubit<SmokingCessationFlowState> {
  final CreatePharmacyAppointment createPharmacyAppointment;
  final QuestionnaireService questionnaireService;

  SmokingCessationFlowCubit({
    required this.createPharmacyAppointment,
    required this.questionnaireService,
  }) : super(const SmokingCessationFlowState());

  void setStep(SmokingCessationFlowStep step) {
    emit(state.copyWith(currentStep: step));
  }

  // v2: submit form as questionnaire response, then advance to professional search.
  Future<void> updateForm(SmokingCessationForm form) async {
    emit(state.copyWith(
      submissionStatus: SmokingCessationSubmissionStatus.submitting,
    ));
    try {
      final responseId = await questionnaireService.submitQuestionnaireResponse(
        questionnaireCode: 'smoking-cessation-intake',
        answers: {
          'is_smoking': form.isSmoking,
          'product_types': form.productTypes,
          'cigarettes_per_day': form.sticksPerDay,
          'has_tried_quitting': form.hasTriedQuitting,
        },
      );
      emit(state.copyWith(
        form: form,
        questionnaireResponseId: responseId,
        submissionStatus: SmokingCessationSubmissionStatus.initial,
        currentStep: SmokingCessationFlowStep.searchProfessional,
      ));
    } catch (e) {
      log('Error submitting smoking cessation intake questionnaire: $e',
          name: 'SmokingCessationFlowCubit');
      emit(state.copyWith(
        submissionStatus: SmokingCessationSubmissionStatus.failure,
        errorMessage: 'Failed to submit intake form. Please try again.',
      ));
    }
  }

  void selectProfessional(ProfessionalEntity professional) {
    emit(state.copyWith(
      selectedProfessional: professional,
      currentStep: SmokingCessationFlowStep.professionalDetail,
    ));
  }

  void selectTimeSlot(DateTime timeSlot) {
    emit(state.copyWith(selectedTimeSlot: timeSlot));
    submitAppointment();
  }

  Future<void> submitAppointment() async {
    if (state.selectedProfessional == null || state.selectedTimeSlot == null) {
      return;
    }

    emit(state.copyWith(
        submissionStatus: SmokingCessationSubmissionStatus.submitting));

    final params = CreatePharmacyAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!,
      pharmacyCase: const PharmacyCase(serviceType: 'smoking_cessation'),
      questionnaireResponseId: state.questionnaireResponseId,
    );

    final result = await createPharmacyAppointment(params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: SmokingCessationSubmissionStatus.failure,
          errorMessage: 'Failed to create appointment',
        ));
      },
      (appointment) {
        emit(state.copyWith(
          submissionStatus: SmokingCessationSubmissionStatus.success,
          createdAppointment: appointment,
        ));
      },
    );
  }
}
