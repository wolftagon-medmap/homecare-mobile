import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/data/models/health_profile_models.dart';
import 'package:m2health/utils.dart';

class HealthProfileRemoteDataSource implements HealthProfileDataSource {
  final Dio dio;

  HealthProfileRemoteDataSource(this.dio);

  static const String _path = 'health-profile/sections';

  @override
  Future<List<HealthSectionSummaryModel>> fetchSections(int? patientProfileId) {
    return _guard(() async {
      final response = await dio.get(
        '${Const.URL_API_V2}/$_path',
        queryParameters: _profileQuery(patientProfileId),
        options: Options(headers: await _authHeaders()),
      );
      return _unwrapList(response.data)
          .map(HealthSectionSummaryModel.fromJson)
          .toList();
    });
  }

  @override
  Future<HealthSectionModel> fetchSection(String code, int? patientProfileId) {
    return _guard(() async {
      final response = await dio.get(
        '${Const.URL_API_V2}/$_path/$code',
        queryParameters: _profileQuery(patientProfileId),
        options: Options(headers: await _authHeaders()),
      );
      return HealthSectionModel.fromJson(_unwrap(response.data));
    });
  }

  @override
  Future<HealthSectionModel> saveSection({
    required String code,
    required Map<String, Object> answers,
    int? patientProfileId,
  }) {
    return _guard(() async {
      final response = await dio.put(
        '${Const.URL_API_V2}/$_path/$code',
        data: {
          if (patientProfileId != null) 'patient_profile_id': patientProfileId,
          'answers': answers,
        },
        options: Options(headers: await _authHeaders()),
      );
      return HealthSectionModel.fromJson(_unwrap(response.data));
    });
  }

  Map<String, dynamic> _profileQuery(int? patientProfileId) =>
      patientProfileId == null
          ? const {}
          : {'patient_profile_id': patientProfileId};
}

// The page shows its own translated text per failure type, never the
// server's English message.
Future<T> _guard<T>(Future<T> Function() call) async {
  try {
    return await call();
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

Future<Map<String, String>> _authHeaders() async {
  final token = await Utils.getSpString(Const.TOKEN);
  return {'Authorization': 'Bearer $token'};
}

Map<String, dynamic> _unwrap(Object? data) {
  if (data is Map<String, dynamic>) {
    final inner = data['data'];
    if (inner is Map<String, dynamic>) return inner;
    return data;
  }
  return const {};
}

List<Map<String, dynamic>> _unwrapList(Object? data) {
  final raw = data is Map<String, dynamic> ? data['data'] : data;
  if (raw is! List) return const [];
  return raw.cast<Map<String, dynamic>>();
}
