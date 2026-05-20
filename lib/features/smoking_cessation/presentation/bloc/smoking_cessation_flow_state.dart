part of 'smoking_cessation_flow_cubit.dart';

enum SmokingCessationFlowStep {
  form,
  searchProfessional,
  professionalDetail,
  scheduling,
}

enum SmokingCessationSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class SmokingCessationFlowState extends Equatable {
  final SmokingCessationFlowStep currentStep;
  // Kept for display purposes only — no longer sent in booking payload.
  final SmokingCessationForm? form;
  // v2: questionnaire response id returned after submitting the intake form.
  final int? questionnaireResponseId;
  final ProfessionalEntity? selectedProfessional;
  final DateTime? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;
  final SmokingCessationSubmissionStatus submissionStatus;
  final String? errorMessage;

  const SmokingCessationFlowState({
    this.currentStep = SmokingCessationFlowStep.form,
    this.form,
    this.questionnaireResponseId,
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.submissionStatus = SmokingCessationSubmissionStatus.initial,
    this.errorMessage,
  });

  SmokingCessationFlowState copyWith({
    SmokingCessationFlowStep? currentStep,
    SmokingCessationForm? form,
    int? questionnaireResponseId,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    SmokingCessationSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return SmokingCessationFlowState(
      currentStep: currentStep ?? this.currentStep,
      form: form ?? this.form,
      questionnaireResponseId:
          questionnaireResponseId ?? this.questionnaireResponseId,
      selectedProfessional: selectedProfessional ?? this.selectedProfessional,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        form,
        questionnaireResponseId,
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        submissionStatus,
        errorMessage,
      ];
}
