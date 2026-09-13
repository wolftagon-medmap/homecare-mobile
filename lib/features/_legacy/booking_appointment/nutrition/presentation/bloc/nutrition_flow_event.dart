part of 'nutrition_flow_bloc.dart';

sealed class NutritionFlowEvent extends Equatable {
  const NutritionFlowEvent();

  @override
  List<Object?> get props => [];
}

// --- Lifecycle ----------------------------------------------------------------

class NutritionFlowStarted extends NutritionFlowEvent {
  const NutritionFlowStarted();
}

// --- Assessment data updates --------------------------------------------------

class NutritionFlowMainConcernSet extends NutritionFlowEvent {
  final String concern;
  const NutritionFlowMainConcernSet(this.concern);
  @override
  List<Object> get props => [concern];
}

class NutritionFlowSelfRatedHealthUpdated extends NutritionFlowEvent {
  final double rating;
  const NutritionFlowSelfRatedHealthUpdated(this.rating);
  @override
  List<Object> get props => [rating];
}

class NutritionFlowHealthProfileUpdated extends NutritionFlowEvent {
  final HealthProfile profile;
  const NutritionFlowHealthProfileUpdated(this.profile);
  @override
  List<Object> get props => [profile];
}

class NutritionFlowLifestyleHabitsUpdated extends NutritionFlowEvent {
  final LifestyleHabits habits;
  const NutritionFlowLifestyleHabitsUpdated(this.habits);
  @override
  List<Object> get props => [habits];
}

class NutritionFlowNutritionHabitsUpdated extends NutritionFlowEvent {
  final NutritionHabits habits;
  const NutritionFlowNutritionHabitsUpdated(this.habits);
  @override
  List<Object> get props => [habits];
}

class NutritionFlowFileAdded extends NutritionFlowEvent {
  final File file;
  const NutritionFlowFileAdded(this.file);
  @override
  List<Object> get props => [file];
}

class NutritionFlowFileRemoved extends NutritionFlowEvent {
  final File file;
  const NutritionFlowFileRemoved(this.file);
  @override
  List<Object> get props => [file];
}

class NutritionFlowFileUrlRemoved extends NutritionFlowEvent {
  final String url;
  const NutritionFlowFileUrlRemoved(this.url);
  @override
  List<Object> get props => [url];
}

// --- Assessment step navigation -----------------------------------------------

class NutritionFlowAssessmentStepAdvanced extends NutritionFlowEvent {
  const NutritionFlowAssessmentStepAdvanced();
}

class NutritionFlowAssessmentStepDecremented extends NutritionFlowEvent {
  const NutritionFlowAssessmentStepDecremented();
}

// --- Assessment submission ----------------------------------------------------

class NutritionFlowAssessmentSubmitRequested extends NutritionFlowEvent {
  const NutritionFlowAssessmentSubmitRequested();
}

// --- Booking ------------------------------------------------------------------

class NutritionFlowProfessionalSelected extends NutritionFlowEvent {
  final ProfessionalEntity professional;
  const NutritionFlowProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class NutritionFlowTimeSlotSelected extends NutritionFlowEvent {
  final TimeSlot slot;
  const NutritionFlowTimeSlotSelected(this.slot);
  @override
  List<Object> get props => [slot];
}

class NutritionFlowAppointmentSubmitRequested extends NutritionFlowEvent {
  const NutritionFlowAppointmentSubmitRequested();
}
