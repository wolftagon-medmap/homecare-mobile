import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/data/models/mental_health_state_model.dart';
import 'package:m2health/features/profiles/data/models/profile_model.dart';
import 'package:m2health/utils.dart';
import 'package:path/path.dart' as p;

abstract class ProfileRemoteDatasource {
  // Patient
  Future<List<ProfileModel>> getProfiles();
  Future<ProfileModel> createProfile(
      Map<String, dynamic> profile, File? avatar);
  Future<void> updateProfile(
      int profileId, Map<String, dynamic> profile, File? avatar);
  Future<void> deleteProfile(int profileId);

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
  Future<List<ProfileModel>> getProfiles() async {
    try {
      final response = await dio.get(
        Const.API_PROFILE, // /v1/profiles
        options: await _getAuthHeaders(),
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => ProfileModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure("User is not authenticated");
      }
      throw Exception('Failed to load profile data. Error: ${e.message}');
    }
  }

  @override
  Future<ProfileModel> createProfile(
      Map<String, dynamic> profile, File? avatar) async {
    try {
      final response = await dio.post(
        Const.API_PROFILE, // /v1/profiles
        data: await _buildFormData(profile, avatar),
        options: (await _getAuthHeaders())..contentType = 'multipart/form-data',
      );
      // Returned so the caller can make the new profile active.
      return ProfileModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_serverMessage(e) ?? 'Failed to create profile');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> updateProfile(
      int profileId, Map<String, dynamic> profile, File? avatar) async {
    try {
      await dio.put(
        '${Const.API_PROFILE}/$profileId', // /v1/profiles/:id
        data: await _buildFormData(profile, avatar),
        options: (await _getAuthHeaders())..contentType = 'multipart/form-data',
      );
    } on DioException catch (e) {
      throw Exception(_serverMessage(e) ??
          'Failed to update profile data. Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteProfile(int profileId) async {
    try {
      await dio.delete(
        '${Const.API_PROFILE}/$profileId', // /v1/profiles/:id
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      throw Exception(_serverMessage(e) ?? 'Failed to remove profile');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<FormData> _buildFormData(
      Map<String, dynamic> profile, File? avatar) async {
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
    return formData;
  }

  /// The API explains refusals in the body ("The primary profile cannot be
  /// removed", field validation errors); Dio's own message would hide them.
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
