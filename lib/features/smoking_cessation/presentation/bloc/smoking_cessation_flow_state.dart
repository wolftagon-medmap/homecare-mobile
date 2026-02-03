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
  final SmokingCessationForm? form;
  final ProfessionalEntity? selectedProfessional;
  final DateTime? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;
  final SmokingCessationSubmissionStatus submissionStatus;
  final String? errorMessage;

  const SmokingCessationFlowState({
    this.currentStep = SmokingCessationFlowStep.form,
    this.form,
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.submissionStatus = SmokingCessationSubmissionStatus.initial,
    this.errorMessage,
  });

  SmokingCessationFlowState copyWith({
    SmokingCessationFlowStep? currentStep,
    SmokingCessationForm? form,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    SmokingCessationSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return SmokingCessationFlowState(
      currentStep: currentStep ?? this.currentStep,
      form: form ?? this.form,
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
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        submissionStatus,
        errorMessage,
      ];
}
