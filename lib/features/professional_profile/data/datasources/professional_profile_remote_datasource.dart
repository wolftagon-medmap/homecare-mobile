import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/data/models/professional_profile_model.dart';
import 'package:m2health/utils.dart';
import 'package:path/path.dart' as p;

abstract class ProfessionalProfileRemoteDatasource {
  Future<ProfessionalProfileModel> getProfessionalProfile();
  Future<void> updateProfessionalProfile(
      Map<String, dynamic> data, File? avatar);
  Future<void> updateProvidedServices(List<int> serviceIds,
      {bool? isHomeScreeningAuthorized});
  Future<ProfessionalProfileModel> submitForVerification();

  // Admin
  Future<List<ProfessionalProfileModel>> getAdminProfessionals(
      {String? status, String? role});
  Future<ProfessionalProfileModel> getAdminProfessionalDetail(int id);
  Future<void> verifyProfessional(int id);
  Future<void> revokeVerification(int id);
  Future<void> rejectProfessional(int id,
      {required String category, String? note});
}

class ProfessionalProfileRemoteDatasourceImpl
    implements ProfessionalProfileRemoteDatasource {
  final Dio dio;

  ProfessionalProfileRemoteDatasourceImpl({required this.dio});

  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<ProfessionalProfileModel> getProfessionalProfile() async {
    try {
      const endpoint = '${Const.API_PROFESSIONALS}/my-profile';
      final response = await dio.get(
        endpoint,
        options: await _getAuthHeaders(),
      );
      final data = response.data['data'];
      return ProfessionalProfileModel.fromJson(data);
    } on DioException catch (e) {
      log('Dio error while fetching professional profile: ${e.response}',
          error: e, name: 'ProfessionalProfileRemoteDatasourceImpl');
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure("User is not authenticated");
      }
      throw Exception(
          'Failed to load professional profile data. Error: ${e.message}');
    }
  }

  @override
  Future<void> updateProfessionalProfile(
      Map<String, dynamic> data, File? avatar) async {
    try {
      const endpoint = '${Const.API_PROFESSIONALS}/my-profile';
      final formData = FormData();

      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      if (avatar != null) {
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatar.path,
            filename: p.basename(avatar.path),
          ),
        ));
      }

      await dio.put(
        endpoint,
        data: formData,
        options: (await _getAuthHeaders())..contentType = 'multipart/form-data',
      );
    } on DioException catch (e) {
      throw Exception(
          'Failed to update professional profile data. Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> updateProvidedServices(List<int> serviceIds,
      {bool? isHomeScreeningAuthorized}) async {
    try {
      const endpoint = '${Const.API_PROFESSIONALS}/my-services';
      final Map<String, dynamic> data = {'service_ids': serviceIds};
      if (isHomeScreeningAuthorized != null) {
        data['is_home_screening_authorized'] = isHomeScreeningAuthorized;
      }

      await dio.put(
        endpoint,
        data: data,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update services: ${e.message}');
    }
  }

  @override
  Future<ProfessionalProfileModel> submitForVerification() async {
    try {
      const endpoint =
          '${Const.API_PROFESSIONALS}/my-profile/submit-verification';
      final response = await dio.post(
        endpoint,
        options: await _getAuthHeaders(),
      );
      return ProfessionalProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure("User is not authenticated");
      }
      final data = e.response?.data;
      final String message = (data is Map && data['message'] is String)
          ? data['message'] as String
          : 'Failed to submit for verification. Error: ${e.message}';
      throw ServerFailure(message);
    }
  }

  // --- Admin Methods ---

  @override
  Future<List<ProfessionalProfileModel>> getAdminProfessionals(
      {String? status, String? role}) async {
    try {
      final response = await dio.get(
        '${Const.URL_API}/admin/professionals',
        queryParameters: {
          'status': status, // 'verified' or 'unverified'
          if (role != null && role.isNotEmpty) 'role': role,
        },
        options: await _getAuthHeaders(),
      );

      final List data = response.data['data'];
      return data.map((e) => ProfessionalProfileModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch professionals: ${e.message}');
    }
  }

  @override
  Future<ProfessionalProfileModel> getAdminProfessionalDetail(int id) async {
    try {
      final response = await dio.get(
        '${Const.URL_API}/admin/professionals/$id',
        options: await _getAuthHeaders(),
      );

      final data = response.data['data'];
      return ProfessionalProfileModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch professional detail: ${e.message}');
    }
  }

  @override
  Future<void> verifyProfessional(int id) async {
    try {
      await dio.post(
        '${Const.URL_API}/professionals/$id/verify',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to verify professional: ${e.message}');
    }
  }

  @override
  Future<void> revokeVerification(int id) async {
    try {
      await dio.post(
        '${Const.URL_API}/professionals/$id/revoke',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to revoke verification: ${e.message}');
    }
  }

  @override
  Future<void> rejectProfessional(int id,
      {required String category, String? note}) async {
    try {
      await dio.post(
        '${Const.URL_API}/professionals/$id/reject',
        data: {
          'category': category,
          if (note != null && note.isNotEmpty) 'note': note,
        },
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      throw Exception('Failed to reject professional: ${e.message}');
    }
  }
}
