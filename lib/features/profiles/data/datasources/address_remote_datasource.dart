import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/features/profiles/data/models/place_detail_model.dart';
import 'package:m2health/features/profiles/data/models/place_suggestion_model.dart';

abstract class AddressRemoteDatasource {
  Future<AddressModel> saveAddress(Map<String, dynamic> data);
  Future<List<PlaceSuggestionModel>> searchPlaces(
      String query, String sessionToken);
  Future<PlaceDetailModel> getPlaceDetails(String placeId, String sessionToken);
}

class AddressRemoteDatasourceImpl implements AddressRemoteDatasource {
  final Dio dio;

  AddressRemoteDatasourceImpl({required this.dio});

  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<AddressModel> saveAddress(Map<String, dynamic> data) async {
    try {
      final result = await dio.post(
        '${Const.URL_API}/addresses/save',
        data: data,
        options: await _getAuthHeaders(),
      );
      return AddressModel.fromJson(result.data['data']);
    } on DioException catch (e, stackTrace) {
      log('Failed to save address: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      rethrow;
    }
  }

  @override
  Future<List<PlaceSuggestionModel>> searchPlaces(
      String query, String sessionToken) async {
    try {
      final response = await dio.post(
        '${Const.URL_API}/addresses/search',
        data: {
          'query': query,
          'sessionToken': sessionToken,
        },
        options: await _getAuthHeaders(),
      );

      final List data = response.data['data'] ?? [];
      return data.map((e) => PlaceSuggestionModel.fromJson(e)).toList();
    } on DioException catch (e, stackTrace) {
      log('Failed to search places: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      rethrow;
    }
  }

  @override
  Future<PlaceDetailModel> getPlaceDetails(
      String placeId, String sessionToken) async {
    try {
      final response = await dio.get(
        '${Const.URL_API}/addresses/details/$placeId',
        queryParameters: {'sessionToken': sessionToken},
        options: await _getAuthHeaders(),
      );

      final data = response.data['data'];
      return PlaceDetailModel.fromJson(data, placeId);
    } on DioException catch (e, stackTrace) {
      log('Failed to get place details: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      rethrow;
    }
  }
}
