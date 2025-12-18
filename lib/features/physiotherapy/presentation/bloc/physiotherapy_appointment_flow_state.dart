part of 'physiotherapy_appointment_flow_bloc.dart';

enum PhysiotherapyFlowStep {
  searchProfessional,
  viewProfessionalDetail,
  scheduling,
}

enum AppointmentSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class PhysiotherapyAppointmentFlowState extends Equatable {
  final PhysiotherapyFlowStep currentStep;
  final PhysiotherapyType type;
  
  final ProfessionalEntity? selectedProfessional;
  final DateTime? selectedTimeSlot;
  final int? selectedDuration;
  final AppointmentEntity? createdAppointment;
  
  final AppointmentSubmissionStatus submissionStatus;
  final String? errorMessage;

  const PhysiotherapyAppointmentFlowState({
    this.currentStep = PhysiotherapyFlowStep.searchProfessional,
    required this.type,
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.selectedDuration,
    this.createdAppointment,
    this.submissionStatus = AppointmentSubmissionStatus.initial,
    this.errorMessage,
  });

  factory PhysiotherapyAppointmentFlowState.initial(PhysiotherapyType type) {
    return PhysiotherapyAppointmentFlowState(type: type);
  }

  PhysiotherapyAppointmentFlowState copyWith({
    PhysiotherapyFlowStep? currentStep,
    PhysiotherapyType? type,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    int? selectedDuration,
    AppointmentEntity? createdAppointment,
    AppointmentSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return PhysiotherapyAppointmentFlowState(
      currentStep: currentStep ?? this.currentStep,
      type: type ?? this.type,
      selectedProfessional: selectedProfessional ?? this.selectedProfessional,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        type,
        selectedProfessional,
        selectedTimeSlot,
        selectedDuration,
        createdAppointment,
        submissionStatus,
        errorMessage,
      ];
}
