part of 'home_health_screening_flow_bloc.dart';

enum HomeHealthScreeningStep {
  selectServices,
  searchProfessional,
  viewProfessionalDetail,
  scheduling,
}

enum ScreeningSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class HomeHealthScreeningFlowState extends Equatable {
  final HomeHealthScreeningStep currentStep;
  final List<ServiceEntity> selectedServices;
  final ProfessionalEntity? selectedProfessional;
  final DateTime? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;
  final ScreeningSubmissionStatus submissionStatus;
  final String? errorMessage;

  const HomeHealthScreeningFlowState({
    this.currentStep = HomeHealthScreeningStep.selectServices,
    this.selectedServices = const [],
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.submissionStatus = ScreeningSubmissionStatus.initial,
    this.errorMessage,
  });

  factory HomeHealthScreeningFlowState.initial() {
    return const HomeHealthScreeningFlowState();
  }

  HomeHealthScreeningFlowState copyWith({
    HomeHealthScreeningStep? currentStep,
    List<ServiceEntity>? selectedServices,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    ScreeningSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return HomeHealthScreeningFlowState(
      currentStep: currentStep ?? this.currentStep,
      selectedServices: selectedServices ?? this.selectedServices,
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
        selectedServices,
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        submissionStatus,
        errorMessage,
      ];
}