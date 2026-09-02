import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';

void main() {
  group('NotificationsState.unreadCount', () {
    test('reports the loaded count', () {
      const state = NotificationsLoaded(
        items: [],
        unread: 4,
        hasMore: false,
        page: 1,
      );

      expect(state.unreadCount, 4);
    });

    test('holds the count through a refresh', () {
      const state = NotificationsLoading(unread: 4);

      expect(state.unreadCount, 4);
    });

    test('holds the count when a refresh fails', () {
      const state = NotificationsError('boom', unread: 4);

      expect(state.unreadCount, 4);
    });

    test('is zero before anything has loaded', () {
      expect(const NotificationsInitial().unreadCount, 0);
      expect(const NotificationsLoading().unreadCount, 0);
    });
  });
}
