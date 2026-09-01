import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/notifications/data/notifications_service.dart';
import 'package:m2health/features/notifications/domain/entities/app_notification.dart';

part 'notifications_state.dart';

/// Drives the notification inbox and the dashboard bell badge (one shared
/// instance): paginated load, optimistic mark-read, mark-all-read.
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsService _service;

  static const _pageSize = 20;

  NotificationsCubit(Dio dio)
      : _service = NotificationsService(dio),
        super(const NotificationsInitial());

  Future<void> load() async {
    emit(const NotificationsLoading());
    try {
      final page = await _service.fetch(page: 1, limit: _pageSize);
      emit(NotificationsLoaded(
        items: page.items,
        unread: page.unread,
        hasMore: page.items.length < page.total,
        page: 1,
      ));
    } catch (e, stackTrace) {
      log('Error loading notifications: $e',
          name: 'NotificationsCubit', error: e, stackTrace: stackTrace);
      emit(const NotificationsError('Failed to load notifications'));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(current.copyWith(loadingMore: true));
    try {
      final next =
          await _service.fetch(page: current.page + 1, limit: _pageSize);
      final items = [...current.items, ...next.items];
      emit(NotificationsLoaded(
        items: items,
        unread: next.unread,
        hasMore: items.length < next.total,
        page: current.page + 1,
      ));
    } catch (e, stackTrace) {
      log('Error loading more notifications: $e',
          name: 'NotificationsCubit', error: e, stackTrace: stackTrace);
      emit(current.copyWith(loadingMore: false));
    }
  }

  /// Optimistic: flips the row and decrements the badge immediately; the server
  /// call follows (a failure is only logged — a stale unread dot self-heals on
  /// the next load).
  Future<void> markRead(AppNotification notification) async {
    final current = state;
    if (notification.isRead || current is! NotificationsLoaded) return;

    emit(current.copyWith(
      items: [
        for (final n in current.items) n.id == notification.id ? n.asRead() : n,
      ],
      unread: current.unread > 0 ? current.unread - 1 : 0,
    ));
    try {
      await _service.markRead(notification.id);
    } catch (e) {
      log('Error marking notification read: $e', name: 'NotificationsCubit');
    }
  }

  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationsLoaded || current.unread == 0) return;

    emit(current.copyWith(
      items: [for (final n in current.items) n.asRead()],
      unread: 0,
    ));
    try {
      await _service.markAllRead();
    } catch (e) {
      log('Error marking all notifications read: $e',
          name: 'NotificationsCubit');
      await load();
    }
  }
}
