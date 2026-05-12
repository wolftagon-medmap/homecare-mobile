import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/utils.dart';

class DiabetesFormCubit extends Cubit<DiabetesFormState> {
  final Dio _dio;
  final QuestionnaireService _questionnaireService;

  DiabetesFormCubit(this._dio, this._questionnaireService)
      : super(const DiabetesFormState());

  Future<bool> loadForm() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      const url = Const.API_DIABETES_PROFILE;
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data['data'];
      log('Loaded diabetes profile data: $data', name: 'DiabetesFormCubit');
      final bool hasBeenSubmitted = data['diabetes_type'] != null;

      final diabetesHistory = DiabetesHistory(
        diabetesType: data['diabetes_type'],
        yearOfDiagnosis: data['year_of_diagnosis'],
        lastHbA1c: data['last_hba1c'] != null
            ? double.tryParse(data['last_hba1c'].toString())
            : null,
        hasTreatmentDiet: data['treatment_diet_exercise'] != null,
        hasTreatmentOral: data['treatment_oral_meds'] != null,
        oralMedication: data['treatment_oral_meds'],
        hasTreatmentInsulin: data['treatment_insulin'] != null,
        insulinTypeDose: data['treatment_insulin'],
      );

      // Helper to convert integer to nullable bool
      bool? toNullableBool(dynamic value) {
        return value == null ? null : value == 1;
      }

      final riskFactors = RiskFactors(
        hasHypertension: toNullableBool(data['has_hypertension']),
        hasDyslipidemia: toNullableBool(data['has_dyslipidemia']),
        hasCardiovascularDisease:
            toNullableBool(data['has_cardiovascular_disease']),
        hasNeuropathy: toNullableBool(data['has_neuropathy']),
        hasEyeDisease: toNullableBool(data['has_eye_disease']),
        hasKidneyDisease: toNullableBool(data['has_kidney_disease']),
        hasFamilyHistory: toNullableBool(data['has_family_history']),
        smokingStatus: data['smoking_status'],
      );

      final lifestyleSelfCare = LifestyleSelfCare(
        recentHypoglycemia: data['recent_hypoglycemia'],
        physicalActivity: data['physical_activity'],
        dietQuality: data['diet_quality'],
      );

      final physicalSigns = PhysicalSigns(
        eyesLastExamDate: data['eyes_last_exam_date']?.toString(),
        eyesFindings: data['eyes_findings'],
        kidneysEgfr: data['kidneys_egfr'],
        kidneysUrineAcr: data['kidneys_urine_acr'],
        feetSkinStatus: data['feet_skin_status'],
        feetDeformityStatus: data['feet_deformity_status'],
      );

      emit(state.copyWith(
        diabetesHistory: diabetesHistory,
        riskFactors: riskFactors,
        lifestyleSelfCare: lifestyleSelfCare,
        physicalSigns: physicalSigns,
        isSubmitted: hasBeenSubmitted,
        isLoading: false,
      ));
      return hasBeenSubmitted;
    } catch (e, s) {
      log('Error checking form status: $e',
          name: 'DiabetesFormCubit', stackTrace: s);

      emit(state.copyWith(
        isSubmitted: false,
        errorMessage: 'error_profile_load',
        isLoading: false,
      ));

      return false;
    }
  }

  void updateDiabetesHistory(DiabetesHistory history) {
    emit(state.copyWith(diabetesHistory: history));
  }

  void updateMedicalHistoryRiskFactors(RiskFactors factors) {
    emit(state.copyWith(riskFactors: factors));
  }

  void updateLifestyleSelfCare(LifestyleSelfCare lifestyle) {
    emit(state.copyWith(lifestyleSelfCare: lifestyle));
  }

  void updatePhysicalSigns(PhysicalSigns signs) {
    emit(state.copyWith(physicalSigns: signs));
  }

  Future<bool> submitForm() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final diabetesHistory = state.diabetesHistory;
    final medicalHistory = state.riskFactors;
    final lifestyle = state.lifestyleSelfCare;
    final physicalSigns = state.physicalSigns;
    try {
      final formData = FormData.fromMap({
        'diabetes_type': diabetesHistory.diabetesType,
        'year_of_diagnosis': diabetesHistory.yearOfDiagnosis,
        'last_hba1c': diabetesHistory.lastHbA1c,
        'treatment_diet_exercise': diabetesHistory.hasTreatmentDiet,
        'treatment_oral_meds': diabetesHistory.hasTreatmentOral
            ? diabetesHistory.oralMedication
            : null,
        'treatment_insulin': diabetesHistory.hasTreatmentInsulin
            ? diabetesHistory.insulinTypeDose
            : null,
        'has_hypertension': medicalHistory.hasHypertension,
        'has_dyslipidemia': medicalHistory.hasDyslipidemia,
        'has_cardiovascular_disease': medicalHistory.hasCardiovascularDisease,
        'has_neuropathy': medicalHistory.hasNeuropathy,
        'has_eye_disease': medicalHistory.hasEyeDisease,
        'has_kidney_disease': medicalHistory.hasKidneyDisease,
        'has_family_history': medicalHistory.hasFamilyHistory,
        'smoking_status': medicalHistory.smokingStatus,
        'recent_hypoglycemia': lifestyle.recentHypoglycemia,
        'physical_activity': lifestyle.physicalActivity,
        'diet_quality': lifestyle.dietQuality,
        'eyes_last_exam_date': physicalSigns.eyesLastExamDate,
        'eyes_findings': physicalSigns.eyesFindings,
        'kidneys_egfr': physicalSigns.kidneysEgfr,
        'kidneys_urine_acr': physicalSigns.kidneysUrineAcr,
        'feet_skin_status': physicalSigns.feetSkinStatus,
        'feet_deformity_status': physicalSigns.feetDeformityStatus,
      });

      const url = Const.API_DIABETES_PROFILE;
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(state.copyWith(
        isLoading: false,
        isSubmitted: true,
      ));
      return true;
    } on DioException catch (dioError, s) {
      final errorMessage =
          dioError.response?.data['message'] ?? 'error_submit';
      log(
        'Dio error submitting form: $errorMessage',
        name: 'DiabetesFormCubit',
        error: dioError,
        stackTrace: s,
      );
      emit(state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      ));
      return false;
    } catch (e, s) {
      log(
        'Error submitting form: $e',
        name: 'DiabetesFormCubit',
        error: e,
        stackTrace: s,
      );
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'error_submit',
      ));
      return false;
    }
  }

  // v2: submit via unified questionnaire endpoint
  Future<bool> submitFormV2() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final h = state.diabetesHistory;
      final r = state.riskFactors;
      final l = state.lifestyleSelfCare;
      final p = state.physicalSigns;
      await _questionnaireService.submitQuestionnaireResponse(
        questionnaireCode: 'diabetes-profile',
        answers: {
          'diabetes_type': h.diabetesType,
          'last_hba1c': h.lastHbA1c,
          'smoking_status': r.smokingStatus,
          'recent_hypoglycemia': l.recentHypoglycemia,
          'physical_activity': l.physicalActivity,
          'diet_quality': l.dietQuality,
          'kidneys_egfr': p.kidneysEgfr,
          'kidneys_urine_acr': p.kidneysUrineAcr,
          'has_hypertension': r.hasHypertension,
          'has_dyslipidemia': r.hasDyslipidemia,
          'has_cardiovascular_disease': r.hasCardiovascularDisease,
          'has_neuropathy': r.hasNeuropathy,
          'has_eye_disease': r.hasEyeDisease,
          'has_kidney_disease': r.hasKidneyDisease,
        },
      );
      emit(state.copyWith(isLoading: false, isSubmitted: true));
      return true;
    } catch (e) {
      log('Error submitting diabetes profile v2: $e', name: 'DiabetesFormCubit');
      emit(state.copyWith(isLoading: false, errorMessage: 'error_submit'));
      return false;
    }
  }

  // v2: load via unified questionnaire endpoint
  Future<bool> loadFormV2() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final data = await _questionnaireService
          .getLatestQuestionnaireResponse('diabetes-profile');
      if (data == null) {
        emit(state.copyWith(isLoading: false, isSubmitted: false));
        return false;
      }
      final answers = data['answers'] as Map<String, dynamic>? ?? data;
      emit(state.copyWith(
        isLoading: false,
        isSubmitted: true,
        diabetesHistory: state.diabetesHistory.copyWith(
          diabetesType: answers['diabetes_type'],
          lastHbA1c: answers['last_hba1c'] != null
              ? double.tryParse(answers['last_hba1c'].toString())
              : null,
        ),
        riskFactors: state.riskFactors.copyWith(
          smokingStatus: answers['smoking_status'],
          hasHypertension: answers['has_hypertension'] as bool?,
          hasDyslipidemia: answers['has_dyslipidemia'] as bool?,
          hasCardiovascularDisease:
              answers['has_cardiovascular_disease'] as bool?,
          hasNeuropathy: answers['has_neuropathy'] as bool?,
          hasEyeDisease: answers['has_eye_disease'] as bool?,
          hasKidneyDisease: answers['has_kidney_disease'] as bool?,
        ),
        lifestyleSelfCare: state.lifestyleSelfCare.copyWith(
          recentHypoglycemia: answers['recent_hypoglycemia'],
          physicalActivity: answers['physical_activity'],
          dietQuality: answers['diet_quality'],
        ),
        physicalSigns: state.physicalSigns.copyWith(
          kidneysEgfr: answers['kidneys_egfr'],
          kidneysUrineAcr: answers['kidneys_urine_acr'],
        ),
      ));
      return true;
    } catch (e) {
      log('Error loading diabetes profile v2: $e', name: 'DiabetesFormCubit');
      emit(state.copyWith(isLoading: false, errorMessage: 'error_profile_load'));
      return false;
    }
  }
}
