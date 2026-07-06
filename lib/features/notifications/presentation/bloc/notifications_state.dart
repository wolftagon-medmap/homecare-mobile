part of 'notifications_cubit.dart';

sealed class NotificationsState {
  const NotificationsState();

  /// Unread count for the dashboard bell badge (0 while loading/error).
  int get unreadCount => switch (this) {
        NotificationsLoaded(:final unread) => unread,
        _ => 0,
      };
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> items;
  final int unread;
  final bool hasMore;
  final int page;
  final bool loadingMore;

  const NotificationsLoaded({
    required this.items,
    required this.unread,
    required this.hasMore,
    required this.page,
    this.loadingMore = false,
  });

  NotificationsLoaded copyWith({
    List<AppNotification>? items,
    int? unread,
    bool? hasMore,
    int? page,
    bool? loadingMore,
  }) {
    return NotificationsLoaded(
      items: items ?? this.items,
      unread: unread ?? this.unread,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}
