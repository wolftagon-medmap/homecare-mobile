part of 'second_opinion_imaging_flow_bloc.dart';

enum SecondOpinionImagingFlowStep {
  form,
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

class SecondOpinionImagingFlowState extends Equatable {
  final SecondOpinionImagingFlowStep currentStep;
  final String serviceType; // 'radiology' or 'pathology'

  // Data from form
  final String? diseaseName;
  final String? diseaseHistory;
  final String? biomarker;
  final List<SecondOpinionImageFile> images;

  final ProfessionalEntity? selectedProfessional;
  final DateTime? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;

  final AppointmentSubmissionStatus submissionStatus;
  final String? errorMessage;

  const SecondOpinionImagingFlowState({
    this.currentStep = SecondOpinionImagingFlowStep.form,
    required this.serviceType,
    this.diseaseName,
    this.diseaseHistory,
    this.biomarker,
    this.images = const [],
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.submissionStatus = AppointmentSubmissionStatus.initial,
    this.errorMessage,
  });

  factory SecondOpinionImagingFlowState.initial(String serviceType) {
    return SecondOpinionImagingFlowState(serviceType: serviceType);
  }

  SecondOpinionImagingFlowState copyWith({
    SecondOpinionImagingFlowStep? currentStep,
    String? serviceType,
    String? diseaseName,
    String? diseaseHistory,
    String? biomarker,
    List<SecondOpinionImageFile>? images,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    AppointmentSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return SecondOpinionImagingFlowState(
      currentStep: currentStep ?? this.currentStep,
      serviceType: serviceType ?? this.serviceType,
      diseaseName: diseaseName ?? this.diseaseName,
      diseaseHistory: diseaseHistory ?? this.diseaseHistory,
      biomarker: biomarker ?? this.biomarker,
      images: images ?? this.images,
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
        serviceType,
        diseaseName,
        diseaseHistory,
        biomarker,
        images,
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        submissionStatus,
        errorMessage,
      ];
}
