import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/profiles/domain/entities/mental_health_state.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/features/profiles/presentation/bloc/mental_health_state_state.dart';

class MentalHealthStateCubit extends Cubit<MentalHealthStateState> {
  final ProfileRepository repository;
  final QuestionnaireService questionnaireService;

  MentalHealthStateCubit({
    required this.repository,
    required this.questionnaireService,
  }) : super(MentalHealthStateInitial());

  Future<void> loadMentalHealthState() async {
    emit(MentalHealthStateLoading());
    final result = await repository.getMentalHealthState();
    result.fold(
      (failure) => emit(MentalHealthStateError(failure.message)),
      (mentalHealthState) => emit(MentalHealthStateLoaded(mentalHealthState)),
    );
  }

  // v2: save via unified questionnaire endpoint
  Future<void> saveMentalHealthStateV2(MentalHealthState data) async {
    emit(MentalHealthStateSaving());
    try {
      await questionnaireService.submitQuestionnaireResponse(
        questionnaireCode: 'mental-health-check',
        answers: {
          'overall_mood': data.overallMood,
          'anxiety_level': data.anxietyLevel,
          'stress_level': data.stressLevel,
          'energy_level': data.energyLevel,
          'focus_level': data.focusLevel,
          'sleep_quality': data.sleepQuality,
        },
      );
      emit(const MentalHealthStateSuccess("Updated successfully!"));
    } catch (e) {
      log('Error saving mental health state v2: $e',
          name: 'MentalHealthStateCubit');
      emit(MentalHealthStateError(e.toString()));
    }
  }

  @Deprecated('Use saveMentalHealthStateV2(data). TODO: delete.')
  Future<void> saveMentalHealthState(MentalHealthState data) async {
    emit(MentalHealthStateSaving());
    // ignore: deprecated_member_use
    final result = await repository.updateMentalHealthState(data);
    result.fold(
      (failure) => emit(MentalHealthStateError(failure.message)),
      (_) {
        emit(const MentalHealthStateSuccess("Updated successfully!"));
        loadMentalHealthState();
      },
    );
  }
}