import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/data/model/payment_model.dart';
import 'package:m2health/utils.dart';

abstract class PaymentRemoteDataSource {
  // v2: pay an order by id.
  Future<void> payOrder(int orderId, String method);

  @Deprecated('Use payOrder(orderId, method). TODO: delete.')
  Future<PaymentModel> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> payOrder(int orderId, String method) async {
    final token = await Utils.getSpString(Const.TOKEN);
    if (token == null) {
      throw const UnauthorizedFailure('User is not authenticated');
    }
    try {
      await dio.post(
        '${Const.API_ORDERS}/$orderId/pay',
        data: {'method': method},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure(
            'Session expired. Please log in again.');
      }
      throw ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  @Deprecated('Use payOrder(orderId, method). TODO: delete.')
  Future<PaymentModel> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  }) async {
    final token = await Utils.getSpString(Const.TOKEN);
    if (token == null) {
      throw const UnauthorizedFailure('User is not authenticated');
    }

    try {
      final response = await dio.post(
        '${Const.URL_API}/payments',
        data: {
          'appointment_id': appointmentId,
          'method': method,
          'amount': amount,
          'status': 'pending',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            response.data?['message'] ?? 'Failed to create payment');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure(
            'Session expired. Please log in again.');
      }
      throw ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
