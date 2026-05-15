part of 'nutrition_flow_bloc.dart';

class HealthProfile {
  final String? knownCondition;
  final List<String> specialConsiderations;
  final String? medicationHistory;
  final String? familyHistory;

  HealthProfile({
    this.knownCondition,
    this.specialConsiderations = const [],
    this.medicationHistory,
    this.familyHistory,
  });
}

class LifestyleHabits {
  final double? sleepHours;
  final String? activityLevel;
  final String? exerciseFrequency;
  final String? stressLevel;
  final String? smokingAlcoholHabits;

  LifestyleHabits({
    this.sleepHours,
    this.activityLevel,
    this.exerciseFrequency,
    this.stressLevel,
    this.smokingAlcoholHabits,
  });
}

class NutritionHabits {
  final String? mealFrequency;
  final String? foodSensitivities;
  final String? favoriteFoods;
  final String? avoidedFoods;
  final String? waterIntake;
  final String? pastDiets;

  NutritionHabits({
    this.mealFrequency,
    this.foodSensitivities,
    this.favoriteFoods,
    this.avoidedFoods,
    this.waterIntake,
    this.pastDiets,
  });
}

class NutritionFlowState extends Equatable {
  // 0=MainConcern, 1=InfoPage, 2=HealthHistory, 3=SelfRatedHealth,
  // 4=LifestyleHabits, 5=NutritionHabits, 6=BiomarkerUpload
  final int assessmentStep;

  // Assessment data
  final int? questionnaireResponseId;
  final String? mainConcern;
  final double selfRatedHealth;
  final HealthProfile? healthProfile;
  final LifestyleHabits? lifestyleHabits;
  final NutritionHabits? nutritionHabits;
  final List<File> files;
  final List<String> fileUrls;

  // Booking data
  final ProfessionalEntity? selectedProfessional;
  final TimeSlot? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;

  // Status
  final bool isInitializing;
  final bool isSubmittingAssessment;
  final bool isBookingAppointment;
  final String? errorMessage;

  bool get isAssessmentSubmitted => questionnaireResponseId != null;
  bool get isLoading =>
      isInitializing || isSubmittingAssessment || isBookingAppointment;

  const NutritionFlowState({
    this.assessmentStep = 0,
    this.questionnaireResponseId,
    this.mainConcern,
    this.selfRatedHealth = 1.0,
    this.healthProfile,
    this.lifestyleHabits,
    this.nutritionHabits,
    this.files = const [],
    this.fileUrls = const [],
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.isInitializing = false,
    this.isSubmittingAssessment = false,
    this.isBookingAppointment = false,
    this.errorMessage,
  });

  NutritionFlowState copyWith({
    int? assessmentStep,
    int? questionnaireResponseId,
    String? mainConcern,
    double? selfRatedHealth,
    HealthProfile? healthProfile,
    LifestyleHabits? lifestyleHabits,
    NutritionHabits? nutritionHabits,
    List<File>? files,
    List<String>? fileUrls,
    ProfessionalEntity? selectedProfessional,
    TimeSlot? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    bool? isInitializing,
    bool? isSubmittingAssessment,
    bool? isBookingAppointment,
    String? errorMessage,
    bool clearError = false,
    bool clearAppointment = false,
    bool clearSelectedProfessional = false,
  }) {
    return NutritionFlowState(
      assessmentStep: assessmentStep ?? this.assessmentStep,
      questionnaireResponseId:
          questionnaireResponseId ?? this.questionnaireResponseId,
      mainConcern: mainConcern ?? this.mainConcern,
      selfRatedHealth: selfRatedHealth ?? this.selfRatedHealth,
      healthProfile: healthProfile ?? this.healthProfile,
      lifestyleHabits: lifestyleHabits ?? this.lifestyleHabits,
      nutritionHabits: nutritionHabits ?? this.nutritionHabits,
      files: files ?? this.files,
      fileUrls: fileUrls ?? this.fileUrls,
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
    );
  }

  @override
  List<Object?> get props => [
        assessmentStep,
        questionnaireResponseId,
        mainConcern,
        selfRatedHealth,
        healthProfile,
        lifestyleHabits,
        nutritionHabits,
        files,
        fileUrls,
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        isInitializing,
        isSubmittingAssessment,
        isBookingAppointment,
        errorMessage,
      ];
}
