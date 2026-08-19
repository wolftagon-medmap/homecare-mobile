import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/utils.dart';

/// Shared plumbing for the professional-profile endpoints.
///
/// The API explains refusals in the body -- an unknown area code, a validation
/// error -- and Dio's own message would hide them, so [guard] lifts the server's
/// message and maps the status onto the failure hierarchy the cubits fold on.
abstract class ProfessionalEndpointClient {
  ProfessionalEndpointClient({required this.dio});

  final Dio dio;

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
