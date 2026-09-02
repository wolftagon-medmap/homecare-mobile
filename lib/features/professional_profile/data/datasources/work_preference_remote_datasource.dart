import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_endpoint_client.dart';
import 'package:m2health/features/professional_profile/data/models/expertise_model.dart';
import 'package:m2health/features/professional_profile/data/models/work_preferences_model.dart';

/// Care style and work preferences. Mirrors the backend's WorkPreferenceService.
abstract class WorkPreferenceRemoteDatasource {
  Future<List<CareStyleTraitModel>> careStyleCatalog();
  Future<List<CareStyleTraitModel>> updateCareStyle(
      List<CareStyleTraitModel> traits);
  Future<WorkPreferencesModel> updatePreferences(WorkPreferencesModel prefs);
}

class WorkPreferenceRemoteDatasourceImpl extends ProfessionalEndpointClient
    implements WorkPreferenceRemoteDatasource {
  WorkPreferenceRemoteDatasourceImpl({required super.dio});

  @override
  Future<List<CareStyleTraitModel>> careStyleCatalog() async {
    return guard('load the care style traits', () async {
      final response = await dio.get(
        '${Const.API_PROFESSIONALS}/care-style/traits',
        options: await authHeaders(),
      );
      return _parseTraits(response.data);
    });
  }

  @override
  Future<List<CareStyleTraitModel>> updateCareStyle(
      List<CareStyleTraitModel> traits) async {
    return guard('save your care style', () async {
      final response = await dio.put(
        '${Const.API_PROFESSIONALS}/my-profile/care-style',
        data: {'entries': traits.map((t) => t.toJson()).toList()},
        options: await authHeaders(),
      );
      return _parseTraits(response.data);
    });
  }

  @override
  Future<WorkPreferencesModel> updatePreferences(
      WorkPreferencesModel prefs) async {
    return guard('save your work preferences', () async {
      final response = await dio.put(
        '${Const.API_PROFESSIONALS}/my-profile/work-preferences',
        data: prefs.toJson(),
        options: await authHeaders(),
      );
      return WorkPreferencesModel.fromJson(
          (response.data['data'] as Map<String, dynamic>?) ?? const {});
    });
  }

  List<CareStyleTraitModel> _parseTraits(dynamic body) {
    final data = body['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => CareStyleTraitModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
