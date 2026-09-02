import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/nutrition/domain/entities/nutrition_assessment_data.dart';
import 'package:m2health/utils.dart';

class NutritionDatasource {
  final Dio _dio;

  NutritionDatasource(this._dio);

  Future<Map<String, dynamic>> getNutritionPlan(int appointmentId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await _dio.get(
      '${Const.API_APPOINTMENT}/$appointmentId/nutrition-plan',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> submitNutritionPlan(
      int appointmentId, Map<String, dynamic> plan) async {
    final token = await Utils.getSpString(Const.TOKEN);
    await _dio.post(
      '${Const.API_APPOINTMENT}/$appointmentId/nutrition-plan',
      data: plan,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<int?> getLatestNutritionAppointmentId() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await _dio.get(
      Const.API_APPOINTMENT,
      queryParameters: {'type': 'nutrition', 'limit': 1, 'sort': '-created_at'},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List?;
    if (data == null || data.isEmpty) return null;
    return data.first['id'] as int?;
  }

  Future<NutritionAssessmentData?> getPatientAssessmentData(
      int questionnaireResponseId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await _dio.get(
      '${Const.API_QUESTIONNAIRE_RESPONSES}/$questionnaireResponseId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    if (data == null) return null;
    final answers = data['answers'] as Map<String, dynamic>? ?? {};
    return NutritionAssessmentData.fromAnswers(answers);
  }
}
