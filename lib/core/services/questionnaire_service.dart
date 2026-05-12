import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/utils.dart';

class QuestionnaireService {
  final Dio _dio;

  QuestionnaireService(this._dio);

  /// Submit a questionnaire response. Returns the new response's id.
  Future<int> submitQuestionnaireResponse({
    required String questionnaireCode,
    required Map<String, dynamic> answers,
    int? appointmentId,
    String status = 'completed',
  }) async {
    final token = await Utils.getSpString(Const.TOKEN);
    try {
      final response = await _dio.post(
        Const.API_QUESTIONNAIRE_RESPONSES,
        data: {
          'questionnaire_code': questionnaireCode,
          'answers': answers,
          if (appointmentId != null) 'appointment_id': appointmentId,
          'status': status,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );
      final data = response.data['data'] ?? response.data;
      return (data as Map<String, dynamic>)['id'] as int;
    } catch (e) {
      log('Error submitting questionnaire response: $e',
          name: 'QuestionnaireService');
      if (e is DioException) {
        throw BadRequestFailure(
            e.response?.data['message'] ?? 'Failed to submit questionnaire');
      }
      rethrow;
    }
  }

  /// Returns the most recent questionnaire response for a given code, or null.
  Future<Map<String, dynamic>?> getLatestQuestionnaireResponse(
      String questionnaireCode) async {
    final token = await Utils.getSpString(Const.TOKEN);
    try {
      final response = await _dio.get(
        Const.API_QUESTIONNAIRE_RESPONSES,
        queryParameters: {'questionnaire_code': questionnaireCode, 'limit': 1},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'] as List?;
      if (data == null || data.isEmpty) return null;
      return data.first as Map<String, dynamic>;
    } catch (e) {
      log('Error fetching questionnaire response: $e',
          name: 'QuestionnaireService');
      return null;
    }
  }

  /// Returns observations filtered by category (e.g. 'mental-health', 'lab-result').
  Future<List<Map<String, dynamic>>> getObservations({
    required String category,
    String? code,
  }) async {
    final token = await Utils.getSpString(Const.TOKEN);
    try {
      final response = await _dio.get(
        Const.API_OBSERVATIONS,
        queryParameters: {
          'category': category,
          if (code != null) 'code': code,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'] as List? ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      log('Error fetching observations: $e', name: 'QuestionnaireService');
      return [];
    }
  }
}
