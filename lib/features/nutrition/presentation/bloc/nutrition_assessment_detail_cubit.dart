import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_assessment_data.dart';
import 'package:m2health/features/nutrition/domain/repositories/nutrition_repository.dart';

// --- States ---------------------------------------------------------------

sealed class NutritionAssessmentDetailState {}

class NutritionAssessmentDetailInitial extends NutritionAssessmentDetailState {}

class NutritionAssessmentDetailLoading extends NutritionAssessmentDetailState {}

class NutritionAssessmentDetailLoaded extends NutritionAssessmentDetailState {
  final NutritionAssessmentData data;

  NutritionAssessmentDetailLoaded(this.data);
}

class NutritionAssessmentDetailError extends NutritionAssessmentDetailState {
  final String message;

  NutritionAssessmentDetailError(this.message);
}

// --- Cubit ----------------------------------------------------------------

class NutritionAssessmentDetailCubit
    extends Cubit<NutritionAssessmentDetailState> {
  final NutritionRepository _repository;

  NutritionAssessmentDetailCubit(this._repository)
      : super(NutritionAssessmentDetailInitial());

  Future<void> fetch({required int questionnaireResponseId}) async {
    emit(NutritionAssessmentDetailLoading());
    final result =
        await _repository.getPatientAssessmentData(questionnaireResponseId);
    result.fold(
      (failure) {
        log(
          failure.message,
          name: 'NutritionAssessmentDetailCubit',
        );
        emit(NutritionAssessmentDetailError(failure.message));
      },
      (data) => emit(NutritionAssessmentDetailLoaded(data)),
    );
  }
}
