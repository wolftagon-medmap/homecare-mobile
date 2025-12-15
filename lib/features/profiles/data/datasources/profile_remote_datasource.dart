import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/data/models/mental_health_state_model.dart';
import 'package:m2health/features/profiles/data/models/professional_profile_model.dart';
import 'package:m2health/features/profiles/data/models/profile_model.dart';
import 'package:m2health/utils.dart';
import 'package:path/path.dart' as p;

abstract class ProfileRemoteDatasource {
  // Patient
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(Map<String, dynamic> profile, File? avatar);

  // Professional
  Future<ProfessionalProfileModel> getProfessionalProfile();
  Future<void> updateProfessionalProfile(
      Map<String, dynamic> data, File? avatar);
  Future<void> updateProvidedServices(List<int> serviceIds,
      {bool? isHomeScreeningAuthorized});

  // Admin
  Future<List<ProfessionalProfileModel>> getAdminProfessionals(
      {String? status});
  Future<ProfessionalProfileModel> getAdminProfessionalDetail(int id);
  Future<void> verifyProfessional(int id);
  Future<void> revokeVerification(int id);

  // Mental Health State
  Future<MentalHealthStateModel> getMentalHealthState();
  Future<void> updateMentalHealthState(Map<String, dynamic> data);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDatasourceImpl({required this.dio});

  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // String _getEndpointByRole(String role) {
  //   switch (role) {
  //     case 'nurse':
  //       return Const.API_NURSE_SERVICES; // e.g., /v1/nurse-services
  //     case 'pharmacist':
  //       return Const.API_PHARMACIST_SERVICES; // e.g., /v1/pharmacist-services
  //     case 'radiologist':
  //       return Const.API_RADIOLOGIST_SERVICES; // e.g., /v1/radiologist-services
  //     default:
  //       throw Exception('Invalid professional role');
  //   }
  // }

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get(
        Const.API_PROFILE, // /v1/profiles
        options: await _getAuthHeaders(),
      );
      final data = response.data['data'];
      log('Profile data received: $data', name: 'ProfileRemoteDatasourceImpl');
      return ProfileModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure("User is not authenticated");
      }
      throw Exception('Failed to load profile data. Error: ${e.message}');
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> profile, File? avatar) async {
    try {
      final formData = FormData();
      profile.forEach((key, value) {
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
        Const.API_PROFILE, // /v1/profiles
        data: formData,
        options: (await _getAuthHeaders())..contentType = 'multipart/form-data',
      );
    } on DioException catch (e) {
      throw Exception('Failed to update profile data. Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // --- Professional Profile Methods ---

  @override
  Future<ProfessionalProfileModel> getProfessionalProfile() async {
    try {
      const endpoint = '${Const.API_PROFESSIONALS}/my-profile';
      final response = await dio.get(
        endpoint,
        options: await _getAuthHeaders(),
      );
      final data = response.data['data'];
      log('Professional profile data received: $data',
          name: 'ProfileRemoteDatasourceImpl');
      return ProfessionalProfileModel.fromJson(data);
    } on DioException catch (e) {
      log('Dio error while fetching professional profile: ${e.response}',
          error: e, name: 'ProfileRemoteDatasourceImpl');
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

  // --- Admin Methods ---
  @override
  Future<List<ProfessionalProfileModel>> getAdminProfessionals(
      {String? status}) async {
    try {
      final response = await dio.get(
        '${Const.URL_API}/admin/professionals',
        queryParameters: {
          'status': status, // 'verified' or 'unverified'
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
  Future<MentalHealthStateModel> getMentalHealthState() async {
    try {
      final response = await dio.get(
        '${Const.API_PROFILE}/mental-health-state',
        options: await _getAuthHeaders(),
      );
      final data = response.data['data'];
      return MentalHealthStateModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure("User is not authenticated");
      }
      throw Exception(
          'Failed to load mental health state. Error: ${e.message}');
    }
  }

  @override
  Future<void> updateMentalHealthState(Map<String, dynamic> data) async {
    try {
      await dio.put(
        '${Const.API_PROFILE}/mental-health-state',
        data: data,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      throw Exception(
          'Failed to update mental health state. Error: ${e.message}');
    }
  }
}
