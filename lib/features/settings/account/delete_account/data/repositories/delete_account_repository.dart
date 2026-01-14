import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';

enum DeleteAccountResultStatus { success, failure }

class DeleteAccountResult {
  final DeleteAccountResultStatus status;
  final String? message;

  DeleteAccountResult({required this.status, this.message});
}

class DeleteAccountRepository {
  final Dio dio;

  DeleteAccountRepository({required this.dio});

  Future<DeleteAccountResult> requestDeleteAccountOtp() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await dio.post(
        Const.API_DELETE_ACCOUNT_REQUEST_OTP,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('OTP requested successfully', name: 'DeleteAccountRepository');
        log('Response data: ${response.data}', name: 'DeleteAccountRepository');
        return DeleteAccountResult(
          status: DeleteAccountResultStatus.success,
          message: response.data['message'],
        );
      }

      log('Failed to request OTP: ${response.data}',
          name: 'DeleteAccountRepository');

      return DeleteAccountResult(
          status: DeleteAccountResultStatus.failure,
          message: response.data['message'] ?? 'Failed to request OTP');
    } catch (e, stackTrace) {
      log('Exception while requesting OTP',
          name: 'DeleteAccountRepository', error: e, stackTrace: stackTrace);
      return DeleteAccountResult(
          status: DeleteAccountResultStatus.failure, message: e.toString());
    }
  }

  Future<DeleteAccountResult> confirmDeleteAccount({
    required String otp,
    required String reason,
    String? details,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await dio.post(
        Const.API_DELETE_ACCOUNT_CONFIRM,
        data: {
          'otp': otp,
          'reason': reason,
          if (details != null) 'details': details,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        log('Account deleted successfully', name: 'DeleteAccountRepository');
        log('Response data: ${response.data}', name: 'DeleteAccountRepository');
        // TODO: Clear auth cubit
        return DeleteAccountResult(
            status: DeleteAccountResultStatus.success,
            message: response.data['message']);
      }

      log('Failed to delete account: ${response.data}',
          name: 'DeleteAccountRepository');
      return DeleteAccountResult(
          status: DeleteAccountResultStatus.failure,
          message: response.data['message'] ?? 'Failed to delete account');
    } catch (e, stackTrace) {
      log('Exception while deleting account',
          name: 'DeleteAccountRepository', error: e, stackTrace: stackTrace);
      return DeleteAccountResult(
          status: DeleteAccountResultStatus.failure, message: e.toString());
    }
  }
}
