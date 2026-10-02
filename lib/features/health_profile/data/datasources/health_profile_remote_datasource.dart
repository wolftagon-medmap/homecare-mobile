import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/data/models/health_profile_models.dart';
import 'package:m2health/utils.dart';

class HealthProfileRemoteDataSource implements HealthProfileDataSource {
  final Dio dio;
  final String baseUrl;

  HealthProfileRemoteDataSource(this.dio, {this.baseUrl = Const.URL_API_V2});

  String get _sections => '$baseUrl/health-profile/sections';

  @override
  Future<List<HealthSectionSummaryModel>> fetchSections(
      int? patientProfileId) async {
    final data = await _request('GET', _sections, patientProfileId);
    return (data as List)
        .map((json) => HealthSectionSummaryModel.fromJson(json))
        .toList();
  }

  @override
  Future<HealthSectionModel> fetchSection(
      String code, int? patientProfileId) async {
    final data = await _request('GET', '$_sections/$code', patientProfileId);
    return HealthSectionModel.fromJson(data);
  }

  @override
  Future<HealthSectionModel> saveSection({
    required String code,
    required Map<String, Object> answers,
    int? patientProfileId,
  }) async {
    final data = await _request('PUT', '$_sections/$code', patientProfileId,
        answers: answers);
    return HealthSectionModel.fromJson(data);
  }

  // Failures carry no server text: the page translates by failure type.
  Future<dynamic> _request(String method, String url, int? patientProfileId,
      {Map<String, Object>? answers}) async {
    final profile = {
      if (patientProfileId != null) 'patient_profile_id': patientProfileId,
    };
    final token = await Utils.getSpString(Const.TOKEN);
    try {
      final response = await dio.request(
        url,
        queryParameters: answers == null ? profile : null,
        data: answers == null ? null : {...profile, 'answers': answers},
        options: Options(
          method: method,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data['data'];
    } on DioException catch (e) {
      throw switch (e.response?.statusCode) {
        401 => const UnauthorizedFailure('unauthorized'),
        404 => const NotFoundFailure('not_found'),
        422 || 400 => const BadRequestFailure('invalid'),
        null => const NetworkFailure('network'),
        _ => const ServerFailure('server'),
      };
    }
  }
}
