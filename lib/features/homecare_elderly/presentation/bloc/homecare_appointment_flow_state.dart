part of 'homecare_appointment_flow_bloc.dart';

enum AppointmentSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

enum HomecareFlowStep {
  searchProfessional,
  professionalDetails,
  schedule,
  review,
}

class HomecareAppointmentFlowState extends Equatable {
  final HomecareFlowStep currentStep;
  final List<String> selectedTasks;
  final ProfessionalEntity? selectedProvider;
  final TimeSlot? selectedTimeSlot;
  final BillingType billingType;
  final AppointmentSubmissionStatus submissionStatus;
  final AppointmentEntity? createdAppointment;
  final String? errorMessage;

  const HomecareAppointmentFlowState({
    this.currentStep = HomecareFlowStep.searchProfessional,
    required this.selectedTasks,
    this.selectedProvider,
    this.selectedTimeSlot,
    this.billingType = BillingType.hourly,
    this.submissionStatus = AppointmentSubmissionStatus.initial,
    this.createdAppointment,
    this.errorMessage,
  });

  HomecareAppointmentFlowState copyWith({
    HomecareFlowStep? currentStep,
    List<String>? selectedTasks,
    ProfessionalEntity? selectedProvider,
    TimeSlot? selectedTimeSlot,
    BillingType? billingType,
    AppointmentSubmissionStatus? submissionStatus,
    AppointmentEntity? createdAppointment,
    String? errorMessage,
  }) {
    return HomecareAppointmentFlowState(
      currentStep: currentStep ?? this.currentStep,
      selectedTasks: selectedTasks ?? this.selectedTasks,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      billingType: billingType ?? this.billingType,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        selectedTasks,
        selectedProvider,
        selectedTimeSlot,
        billingType,
        submissionStatus,
        createdAppointment,
        errorMessage,
      ];
}