import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_endpoint_client.dart';
import 'package:m2health/features/professional_profile/data/models/expertise_model.dart';

/// Condition experience and language proficiency. Mirrors the backend's
/// ExpertiseService so the two stay recognisable to each other.
abstract class ExpertiseRemoteDatasource {
  Future<List<LeveledEntryModel>> conditionCatalog();
  Future<List<LeveledEntryModel>> languageCatalog();
  Future<List<LeveledEntryModel>> updateConditionExperience(
      List<LeveledEntryModel> entries);
  Future<List<LeveledEntryModel>> updateLanguages(
      List<LeveledEntryModel> entries);
}

class ExpertiseRemoteDatasourceImpl extends ProfessionalEndpointClient
    implements ExpertiseRemoteDatasource {
  ExpertiseRemoteDatasourceImpl({required super.dio});

  @override
  Future<List<LeveledEntryModel>> conditionCatalog() =>
      _list('${Const.API_PROFESSIONALS}/expertise/conditions');

  @override
  Future<List<LeveledEntryModel>> languageCatalog() =>
      _list('${Const.API_PROFESSIONALS}/expertise/languages');

  @override
  Future<List<LeveledEntryModel>> updateConditionExperience(
          List<LeveledEntryModel> entries) =>
      _replace('${Const.API_PROFESSIONALS}/my-profile/condition-experience',
          entries);

  @override
  Future<List<LeveledEntryModel>> updateLanguages(
          List<LeveledEntryModel> entries) =>
      _replace('${Const.API_PROFESSIONALS}/my-profile/languages', entries);

  Future<List<LeveledEntryModel>> _list(String endpoint) async {
    return guard('load the catalogue', () async {
      final response = await dio.get(endpoint, options: await authHeaders());
      return _parse(response);
    });
  }

  /// The server replaces the whole list on every save, which is what these
  /// screens submit.
  Future<List<LeveledEntryModel>> _replace(
      String endpoint, List<LeveledEntryModel> entries) async {
    return guard('save your expertise', () async {
      final response = await dio.put(
        endpoint,
        data: {'entries': entries.map((e) => e.toJson()).toList()},
        options: await authHeaders(),
      );
      return _parse(response);
    });
  }

  List<LeveledEntryModel> _parse(Response<dynamic> response) {
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => LeveledEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
