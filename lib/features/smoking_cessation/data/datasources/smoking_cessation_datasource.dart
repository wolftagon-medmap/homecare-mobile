import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/smoking_cessation/data/models/smoking_cessation_plan_model.dart';
import 'package:m2health/utils.dart';

abstract class SmokingCessationRemoteDatasource {
  Future<SmokingCessationPlanModel?> getSmokingCessationPlan(int appointmentId);
  Future<void> submitSmokingCessationPlan(
      int appointmentId, SmokingCessationPlanModel plan);
}

class SmokingCessationRemoteDatasourceImpl
    implements SmokingCessationRemoteDatasource {
  final Dio dio;

  SmokingCessationRemoteDatasourceImpl({required this.dio});

  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  @override
  Future<SmokingCessationPlanModel?> getSmokingCessationPlan(
      int appointmentId) async {
    try {
      final url =
          '${Const.URL_API}/appointments/$appointmentId/smoking-cessation-plan';
      final response = await dio.get(url, options: await _getAuthHeaders());

      if (response.data['status'] == 'success' &&
          response.data['data'] != null) {
        return SmokingCessationPlanModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e, s) {
      log('Error in getSmokingCessationPlan',
          name: 'SmokingCessationRemoteDatasource', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> submitSmokingCessationPlan(
      int appointmentId, SmokingCessationPlanModel plan) async {
    try {
      final url =
          '${Const.URL_API}/appointments/$appointmentId/smoking-cessation-plan';
      await dio.post(
        url,
        data: plan.toJson(),
        options: await _getAuthHeaders(),
      );
    } catch (e, s) {
      log('Error in submitSmokingCessationPlan',
          name: 'SmokingCessationRemoteDatasource', error: e, stackTrace: s);
      rethrow;
    }
  }
}
