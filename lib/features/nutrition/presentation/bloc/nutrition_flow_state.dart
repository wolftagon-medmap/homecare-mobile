part of 'nutrition_flow_bloc.dart';

class NutritionFlowState extends Equatable {
  // 0=MainConcern, 1=InfoPage, 2=HealthHistory, 3=SelfRatedHealth,
  // 4=LifestyleHabits, 5=NutritionHabits, 6=BiomarkerUpload
  final int assessmentStep;

  // Assessment data (bundled)
  final int? questionnaireResponseId;
  final NutritionAssessmentData assessment;

  // Booking data
  final ProfessionalEntity? selectedProfessional;
  final TimeSlot? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;

  // Status
  final bool isInitializing;
  final bool isSubmittingAssessment;
  final bool isBookingAppointment;
  final String? errorMessage;

  /// Incremented on every successful assessment submission (initial or edit).
  final int submissionCount;

  bool get isAssessmentSubmitted => questionnaireResponseId != null;
  bool get isLoading =>
      isInitializing || isSubmittingAssessment || isBookingAppointment;

  const NutritionFlowState({
    this.assessmentStep = 0,
    this.questionnaireResponseId,
    this.assessment = const NutritionAssessmentData(),
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.isInitializing = false,
    this.isSubmittingAssessment = false,
    this.isBookingAppointment = false,
    this.errorMessage,
    this.submissionCount = 0,
  });

  NutritionFlowState copyWith({
    int? assessmentStep,
    int? questionnaireResponseId,
    NutritionAssessmentData? assessment,
    ProfessionalEntity? selectedProfessional,
    TimeSlot? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    bool? isInitializing,
    bool? isSubmittingAssessment,
    bool? isBookingAppointment,
    String? errorMessage,
    int? submissionCount,
    bool clearError = false,
    bool clearAppointment = false,
    bool clearSelectedProfessional = false,
  }) {
    return NutritionFlowState(
      assessmentStep: assessmentStep ?? this.assessmentStep,
      questionnaireResponseId:
          questionnaireResponseId ?? this.questionnaireResponseId,
      assessment: assessment ?? this.assessment,
      selectedProfessional: clearSelectedProfessional
          ? null
          : (selectedProfessional ?? this.selectedProfessional),
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      createdAppointment: clearAppointment
          ? null
          : (createdAppointment ?? this.createdAppointment),
      isInitializing: isInitializing ?? this.isInitializing,
      isSubmittingAssessment:
          isSubmittingAssessment ?? this.isSubmittingAssessment,
      isBookingAppointment: isBookingAppointment ?? this.isBookingAppointment,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      submissionCount: submissionCount ?? this.submissionCount,
    );
  }

  @override
  List<Object?> get props => [
        assessmentStep,
        questionnaireResponseId,
        assessment,
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        isInitializing,
        isSubmittingAssessment,
        isBookingAppointment,
        errorMessage,
        submissionCount,
      ];
}
