import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/data/models/country_model.dart';

abstract class CountriesRemoteDatasource {
  Future<List<CountryModel>> fetchCountries();
}

class CountriesRemoteDatasourceImpl implements CountriesRemoteDatasource {
  final Dio dio;

  CountriesRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<CountryModel>> fetchCountries() async {
    try {
      final response = await dio.get(
        Const.API_COUNTRIES,
        options: Options(validateStatus: (s) => s != null && s < 500),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to load countries');
      }
      final raw = response.data['data'];
      if (raw is! List) {
        return [];
      }
      return raw
          .map((e) => CountryModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e, st) {
      log('fetchCountries failed', error: e, stackTrace: st, name: 'CountriesRemoteDatasource');
      rethrow;
    }
  }
}
