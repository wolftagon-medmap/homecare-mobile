import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/data/models/inbox_item.dart';
import 'package:m2health/utils.dart';

/// Transport for the professional offer inbox (ADR-0006): reads the unified
/// pending list, and responds to v2 care-task offers. v1 appointment actions
/// are handled by the existing AppointmentService.
class ProviderInboxService {
  final Dio _dio;

  ProviderInboxService(this._dio);

  Future<Options> _authOptions() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  Future<List<InboxItem>> fetchInbox() async {
    final response = await _dio.get(
      '${Const.URL_API_V2}/provider/inbox',
      options: await _authOptions(),
    );
    final items = (response.data['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(InboxItem.fromJson)
        .toList();
    return items;
  }

  Future<void> acceptOffer(int careTaskId) async {
    await _dio.post(
      '${Const.URL_API_V2}/care-tasks/$careTaskId/accept',
      options: await _authOptions(),
    );
  }

  Future<void> declineOffer(int careTaskId) async {
    await _dio.post(
      '${Const.URL_API_V2}/care-tasks/$careTaskId/decline',
      options: await _authOptions(),
    );
  }
}
