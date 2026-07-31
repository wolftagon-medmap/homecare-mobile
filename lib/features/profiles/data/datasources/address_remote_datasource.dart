import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/features/profiles/data/models/place_detail_model.dart';
import 'package:m2health/features/profiles/data/models/place_suggestion_model.dart';

abstract class AddressRemoteDatasource {
  Future<AddressModel> saveAddress(Map<String, dynamic> data);
  Future<AddressModel> saveWorkplaceAddress(Map<String, dynamic> data);
  Future<List<PlaceSuggestionModel>> searchPlaces(
      String query, String sessionToken);
  Future<PlaceDetailModel> getPlaceDetails(String placeId, String sessionToken);

  // Saved Addresses (multiple, with label + default)
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress(Map<String, dynamic> data);
  Future<AddressModel> updateAddress(int id, Map<String, dynamic> data);
  Future<void> deleteAddress(int id);
  Future<AddressModel> setDefaultAddress(int id);
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
  Future<AddressModel> saveWorkplaceAddress(Map<String, dynamic> data) async {
    try {
      final result = await dio.post(
        '${Const.URL_API}/addresses/save-workplace',
        data: data,
        options: await _getAuthHeaders(),
      );
      return AddressModel.fromJson(result.data['data']);
    } on DioException catch (e, stackTrace) {
      log('Failed to save workplace address: ${e.message}',
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

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await dio.get(
        '${Const.URL_API}/addresses',
        options: await _getAuthHeaders(),
      );
      final List data = response.data['data'] ?? [];
      return data.map((e) => AddressModel.fromJson(e)).toList();
    } on DioException catch (e, stackTrace) {
      log('Failed to load addresses: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      rethrow;
    }
  }

  @override
  Future<AddressModel> createAddress(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        '${Const.URL_API}/addresses',
        data: data,
        options: await _getAuthHeaders(),
      );
      return AddressModel.fromJson(response.data['data']);
    } on DioException catch (e, stackTrace) {
      log('Failed to create address: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      throw Exception(_serverMessage(e) ?? 'Failed to create address');
    }
  }

  @override
  Future<AddressModel> updateAddress(int id, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(
        '${Const.URL_API}/addresses/$id',
        data: data,
        options: await _getAuthHeaders(),
      );
      return AddressModel.fromJson(response.data['data']);
    } on DioException catch (e, stackTrace) {
      log('Failed to update address: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      throw Exception(_serverMessage(e) ?? 'Failed to update address');
    }
  }

  @override
  Future<void> deleteAddress(int id) async {
    try {
      await dio.delete(
        '${Const.URL_API}/addresses/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e, stackTrace) {
      log('Failed to delete address: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      throw Exception(_serverMessage(e) ?? 'Failed to delete address');
    }
  }

  @override
  Future<AddressModel> setDefaultAddress(int id) async {
    try {
      final response = await dio.post(
        '${Const.URL_API}/addresses/$id/default',
        options: await _getAuthHeaders(),
      );
      return AddressModel.fromJson(response.data['data']);
    } on DioException catch (e, stackTrace) {
      log('Failed to set default address: ${e.message}',
          name: 'AddressRemoteDatasourceImpl',
          stackTrace: stackTrace,
          error: e);
      throw Exception(_serverMessage(e) ?? 'Failed to set default address');
    }
  }

  /// The API explains refusals in the body (field validation errors, "The
  /// primary profile cannot be removed"-style messages); Dio's own message
  /// would hide them behind a generic "422 bad response" dump.
  String? _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is! Map) return null;

    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) {
      final first = errors.first;
      if (first is Map && first['message'] != null) {
        return first['message'].toString();
      }
    }
    return data['message']?.toString();
  }
}
