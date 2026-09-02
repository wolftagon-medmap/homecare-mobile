import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/notifications/domain/entities/app_notification.dart';
import 'package:m2health/utils.dart';

class NotificationsPage {
  final List<AppNotification> items;
  final int total;
  final int unread;

  const NotificationsPage({
    required this.items,
    required this.total,
    required this.unread,
  });
}

/// Transport for the in-app notification inbox (`/v2/notifications`).
class NotificationsService {
  final Dio _dio;

  NotificationsService(this._dio);

  static const _base = '${Const.URL_API_V2}/notifications';

  Future<Options> _authOptions() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  Future<NotificationsPage> fetch({int page = 1, int limit = 20}) async {
    final response = await _dio.get(
      _base,
      queryParameters: {'page': page, 'limit': limit},
      options: await _authOptions(),
    );
    final data = response.data as Map<String, dynamic>;
    final meta = data['meta'] as Map<String, dynamic>? ?? const {};
    return NotificationsPage(
      items: (data['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList(),
      total: (meta['total'] as num?)?.toInt() ?? 0,
      unread: (meta['unread'] as num?)?.toInt() ?? 0,
    );
  }

  Future<void> markRead(int id) async {
    await _dio.patch('$_base/$id/read', options: await _authOptions());
  }

  Future<void> markAllRead() async {
    await _dio.patch('$_base/read-all', options: await _authOptions());
  }
}
