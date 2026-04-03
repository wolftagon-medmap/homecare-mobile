import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/utils.dart';

class SecondOpinionImagingRemoteDataSource {
  final Dio dio;

  SecondOpinionImagingRemoteDataSource({required this.dio});

  Future<void> submitFeedback({
    required int appointmentId,
    required String diagnosticOpinion,
    required String recommendationOpinion,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final payload = {
        'diagnostic_opinion': diagnosticOpinion,
        'recommendation_opinion': recommendationOpinion,
      };

      final response = await dio.post(
        '${Const.URL_API}/second-opinion/$appointmentId/feedback',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit feedback: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log(
        'Error submitting feedback: $e',
        error: e,
        name: 'SecondOpinionImagingRemoteDataSource',
        stackTrace: stackTrace,
      );
      if (e is DioException) {
        throw BadRequestFailure(
            e.response?.data['message'] ?? 'Failed to submit feedback');
      }
      rethrow;
    }
  }
}
