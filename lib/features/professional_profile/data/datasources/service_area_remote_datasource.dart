import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_endpoint_client.dart';
import 'package:m2health/features/professional_profile/data/models/service_area_model.dart';

/// Districts a professional serves, and the one they live in. Mirrors the
/// backend's ServiceAreaService.
abstract class ServiceAreaRemoteDatasource {
  Future<List<AreaOptionModel>> listAreas(String countryCode);
  Future<List<ServiceAreaModel>> updateServiceAreas(
      String countryCode, List<String> codes);
  Future<ServiceAreaModel?> updateResidentialArea(
      String countryCode, String? code);
}

class ServiceAreaRemoteDatasourceImpl extends ProfessionalEndpointClient
    implements ServiceAreaRemoteDatasource {
  ServiceAreaRemoteDatasourceImpl({required super.dio});

  @override
  Future<List<AreaOptionModel>> listAreas(String countryCode) async {
    return guard('load the districts', () async {
      final response = await dio.get(
        '${Const.API_PROFESSIONALS}/areas',
        queryParameters: {'country_code': countryCode},
        options: await authHeaders(),
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => AreaOptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<ServiceAreaModel>> updateServiceAreas(
      String countryCode, List<String> codes) async {
    return guard('save your districts', () async {
      final response = await dio.put(
        '${Const.API_PROFESSIONALS}/my-profile/service-areas',
        data: {'country_code': countryCode, 'codes': codes},
        options: await authHeaders(),
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => ServiceAreaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  /// A null code clears the residential area, which the server accepts.
  @override
  Future<ServiceAreaModel?> updateResidentialArea(
      String countryCode, String? code) async {
    return guard('save where you live', () async {
      final response = await dio.put(
        '${Const.API_PROFESSIONALS}/my-profile/residential-area',
        data: {'country_code': countryCode, 'code': code},
        options: await authHeaders(),
      );
      final data = response.data['data'] as Map<String, dynamic>?;
      return data == null ? null : ServiceAreaModel.fromJson(data);
    });
  }
}
