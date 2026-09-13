import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/data/models/professional_model.dart';
import 'package:m2health/utils.dart';

class ProfessionalRemoteDatasource {
  final Dio dio;

  ProfessionalRemoteDatasource(this.dio);

  Future<List<ProfessionalModel>> getProfessionals({
    String? role,
    String? name,
    List<int>? serviceIds,
    bool? isHomeScreeningAuthorized,
    String? serviceSubCategory,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final queryParams = {
        if (role != null) 'role': role,
        if (name != null) 'name': name,
        if (serviceIds != null && serviceIds.isNotEmpty)
          'service_ids[]': serviceIds,
        if (isHomeScreeningAuthorized != null)
          'is_home_screening_authorized': isHomeScreeningAuthorized,
        if (serviceSubCategory != null)
          'service_sub_category': serviceSubCategory,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };
      log('Fetching professionals with params: $queryParams',
          name: 'ProfessionalRemoteDatasource');
      final response = await dio.get(
        '${Const.URL_API}/professionals',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('Professionals fetched: ${response.data}',
          name: 'ProfessionalRemoteDatasource');

      final professionals = response.data['data'] as List;
      return professionals
          .map((prof) => ProfessionalModel.fromJson(prof))
          .toList();
    } catch (e, stackTrace) {
      log('Error fetching professionals',
          error: e,
          stackTrace: stackTrace,
          name: 'ProfessionalRemoteDatasource');
      rethrow;
    }
  }

  Future<ProfessionalModel> getProfessionalDetail(int id) async {
    final token = await Utils.getSpString(Const.TOKEN);

    final response = await dio.get(
      '${Const.URL_API}/professionals/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final data = response.data['data'];
      return ProfessionalModel.fromJson(data);
    } else {
      throw Exception('Failed to load professional detail');
    }
  }

  Future<void> toggleFavorite(
    int professionalId,
    bool isFavorite, {
    String itemType = 'nurse',
  }) async {
    final userId = await Utils.getSpString(Const.USER_ID);
    final token = await Utils.getSpString(Const.TOKEN);

    try {
      if (isFavorite) {
        await dio.post(
          Const.API_FAVORITES,
          data: {
            'user_id': userId,
            'item_id': professionalId,
            'item_type': itemType,
            'highlighted': 1,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      } else {
        await dio.delete(
          Const.API_FAVORITES,
          data: {
            'user_id': userId,
            'item_id': professionalId,
            'item_type': itemType,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } on DioException catch (e) {
      log(
        'Favorite toggle failed: status=${e.response?.statusCode} body=${e.response?.data}',
        name: 'ProfessionalRemoteDatasource',
      );
      throw Exception(_serverMessage(e) ??
          (isFavorite
              ? 'Failed to update favorite status'
              : 'Failed to delete favorite'));
    }
  }

  /// Surfaces the API's own validation/error message instead of Dio's raw dump.
  String? _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map && first['message'] is String) {
          return first['message'] as String;
        }
      }
    }
    return null;
  }
}
