import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/utils.dart';

/// Shared plumbing for the pricing endpoints, mirroring
/// `ProfessionalEndpointClient`: the API explains a refusal in the body — a
/// price below the floor, most often — and Dio's own message would hide it.
abstract class PricingEndpointClient {
  PricingEndpointClient({required this.dio});

  final Dio dio;

  String url(String path) => '${Const.URL_API_V2}$path';

  Future<Options> authHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<T> guard<T>(String action, Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw _failureFor(e, action);
    }
  }

  /// The server sends `{ data: ... }`; older handlers send the object bare.
  Map<String, dynamic> unwrap(dynamic body) {
    final map = Map<String, dynamic>.from((body ?? <String, dynamic>{}) as Map);
    final data = map['data'];
    return data is Map ? Map<String, dynamic>.from(data) : map;
  }

  List<Map<String, dynamic>> unwrapList(dynamic body) {
    final raw = body is Map ? (body['data'] ?? body) : body;
    return (raw as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Failure _failureFor(DioException e, String action) {
    final status = e.response?.statusCode;
    final message = _serverMessage(e) ?? 'Could not $action.';

    return switch (status) {
      401 => const UnauthorizedFailure('User is not authenticated'),
      404 => NotFoundFailure(message),
      422 || 400 => BadRequestFailure(message),
      null => NetworkFailure(message),
      _ => ServerFailure(message),
    };
  }

  String? _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }
}
