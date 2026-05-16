import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_assessment_data.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';

part 'nutrition_flow_event.dart';
part 'nutrition_flow_state.dart';

class NutritionFlowBloc extends Bloc<NutritionFlowEvent, NutritionFlowState> {
  final QuestionnaireService _questionnaireService;
  final CreateNutritionAppointment _createNutritionAppointment;

  NutritionFlowBloc({
    required QuestionnaireService questionnaireService,
    required CreateNutritionAppointment createNutritionAppointment,
  })  : _questionnaireService = questionnaireService,
        _createNutritionAppointment = createNutritionAppointment,
        super(const NutritionFlowState()) {
    on<NutritionFlowStarted>(_onStarted);
    on<NutritionFlowMainConcernSet>(_onMainConcernSet);
    on<NutritionFlowSelfRatedHealthUpdated>(_onSelfRatedHealthUpdated);
    on<NutritionFlowHealthProfileUpdated>(_onHealthProfileUpdated);
    on<NutritionFlowLifestyleHabitsUpdated>(_onLifestyleHabitsUpdated);
    on<NutritionFlowNutritionHabitsUpdated>(_onNutritionHabitsUpdated);
    on<NutritionFlowFileAdded>(_onFileAdded);
    on<NutritionFlowFileRemoved>(_onFileRemoved);
    on<NutritionFlowFileUrlRemoved>(_onFileUrlRemoved);
    on<NutritionFlowAssessmentStepAdvanced>((event, emit) =>
        emit(state.copyWith(assessmentStep: state.assessmentStep + 1)));
    on<NutritionFlowAssessmentStepDecremented>((event, emit) =>
        emit(state.copyWith(assessmentStep: state.assessmentStep - 1)));
    on<NutritionFlowAssessmentSubmitRequested>(_onAssessmentSubmitRequested);
    on<NutritionFlowProfessionalSelected>(_onProfessionalSelected);
    on<NutritionFlowTimeSlotSelected>(_onTimeSlotSelected);
    on<NutritionFlowAppointmentSubmitRequested>(_onAppointmentSubmitRequested);
  }

  Future<void> _onStarted(
    NutritionFlowStarted event,
    Emitter<NutritionFlowState> emit,
  ) async {
    emit(const NutritionFlowState(isInitializing: true));

    try {
      final data = await _questionnaireService
          .getLatestQuestionnaireResponse('nutrition-abcd');

      if (data == null) {
        emit(state.copyWith(isInitializing: false));
        return;
      }

      final answers = data['answers'] as Map<String, dynamic>? ?? {};
      final responseId = data['id'] as int?;

      emit(NutritionFlowState(
        questionnaireResponseId: responseId,
        assessment: NutritionAssessmentData.fromAnswers(answers),
        isInitializing: false,
      ));
    } catch (e, st) {
      log('Error loading nutrition assessment',
          error: e, stackTrace: st, name: 'NutritionFlowBloc');
      emit(state.copyWith(isInitializing: false));
    }
  }

  // --- Assessment data updates -------------------------------------------------

  void _onMainConcernSet(
      NutritionFlowMainConcernSet event, Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment.copyWith(mainConcern: event.concern)));
  }

  void _onSelfRatedHealthUpdated(NutritionFlowSelfRatedHealthUpdated event,
      Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment.copyWith(selfRatedHealth: event.rating)));
  }

  void _onHealthProfileUpdated(NutritionFlowHealthProfileUpdated event,
      Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment.copyWith(healthProfile: event.profile)));
  }

  void _onLifestyleHabitsUpdated(NutritionFlowLifestyleHabitsUpdated event,
      Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment.copyWith(lifestyleHabits: event.habits)));
  }

  void _onNutritionHabitsUpdated(NutritionFlowNutritionHabitsUpdated event,
      Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment.copyWith(nutritionHabits: event.habits)));
  }

  void _onFileAdded(
      NutritionFlowFileAdded event, Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment
            .copyWith(files: [...state.assessment.files, event.file])));
  }

  void _onFileRemoved(
      NutritionFlowFileRemoved event, Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment.copyWith(
            files: state.assessment.files
                .where((f) => f != event.file)
                .toList())));
  }

  void _onFileUrlRemoved(
      NutritionFlowFileUrlRemoved event, Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(
        assessment: state.assessment.copyWith(
            fileUrls: state.assessment.fileUrls
                .where((u) => u != event.url)
                .toList())));
  }

  // --- Assessment submission ---------------------------------------------------

  Future<void> _onAssessmentSubmitRequested(
    NutritionFlowAssessmentSubmitRequested event,
    Emitter<NutritionFlowState> emit,
  ) async {
    emit(state.copyWith(isSubmittingAssessment: true, clearError: true));

    try {
      final a = state.assessment;
      final answers = <String, dynamic>{
        'main_concern': a.mainConcern,
        'self_rated_health': a.selfRatedHealth.round(),
        'known_condition': a.healthProfile?.knownCondition,
        'special_considerations': a.healthProfile?.specialConsiderations,
        'medication_history': a.healthProfile?.medicationHistory,
        'family_health_history': a.healthProfile?.familyHistory,
        'sleep_hours': a.lifestyleHabits?.sleepHours,
        'activity_level': a.lifestyleHabits?.activityLevel,
        'exercise_frequency': a.lifestyleHabits?.exerciseFrequency,
        'stress_level': a.lifestyleHabits?.stressLevel,
        'smoking_alcohol_habit': a.lifestyleHabits?.smokingAlcoholHabits,
        'meal_frequency': a.nutritionHabits?.mealFrequency,
        'food_sensitivities': a.nutritionHabits?.foodSensitivities,
        'favorite_foods': a.nutritionHabits?.favoriteFoods,
        'avoided_foods': a.nutritionHabits?.avoidedFoods,
        'water_intake': a.nutritionHabits?.waterIntake,
        'past_diet': a.nutritionHabits?.pastDiets,
      };

      final int responseId;
      if (state.isAssessmentSubmitted) {
        log('Updating questionnaire response id: ${state.questionnaireResponseId}',
            name: 'NutritionFlowBloc');
        responseId = await _questionnaireService.updateQuestionnaireResponse(
          id: state.questionnaireResponseId!,
          answers: answers,
        );
      } else {
        log('Creating new questionnaire response', name: 'NutritionFlowBloc');
        responseId = await _questionnaireService.submitQuestionnaireResponse(
          questionnaireCode: 'nutrition-abcd',
          answers: answers,
        );
      }

      emit(state.copyWith(
        questionnaireResponseId: responseId,
        isSubmittingAssessment: false,
        submissionCount: state.submissionCount + 1,
      ));
    } catch (e, st) {
      log('Error submitting assessment',
          error: e, stackTrace: st, name: 'NutritionFlowBloc');
      emit(state.copyWith(
        isSubmittingAssessment: false,
        errorMessage: 'Failed to submit assessment. Please try again.',
      ));
    }
  }

  // --- Booking -----------------------------------------------------------------

  void _onProfessionalSelected(NutritionFlowProfessionalSelected event,
      Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(selectedProfessional: event.professional));
  }

  void _onTimeSlotSelected(
      NutritionFlowTimeSlotSelected event, Emitter<NutritionFlowState> emit) {
    emit(state.copyWith(selectedTimeSlot: event.slot));
    add(const NutritionFlowAppointmentSubmitRequested());
  }

  Future<void> _onAppointmentSubmitRequested(
    NutritionFlowAppointmentSubmitRequested event,
    Emitter<NutritionFlowState> emit,
  ) async {
    emit(state.copyWith(isBookingAppointment: true, clearError: true));

    final params = CreateNutritionAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!.startTime,
      questionnaireResponseId: state.questionnaireResponseId!,
    );

    final result = await _createNutritionAppointment(params);
    result.fold(
      (failure) {
        log('Failed to book appointment: ${failure.message}',
            name: 'NutritionFlowBloc');
        emit(state.copyWith(
          isBookingAppointment: false,
          errorMessage: failure.message,
        ));
      },
      (appointment) {
        emit(state.copyWith(
          isBookingAppointment: false,
          createdAppointment: appointment,
        ));
      },
    );
  }
}
