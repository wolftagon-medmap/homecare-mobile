import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/notifications/domain/entities/app_notification.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/core/messaging/messaging_entry.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/appointment_routes.dart';

/// The notification inbox. Unread items are visually distinct (tint + dot +
/// bold), items are grouped by day, tapping marks read and deep-links to the
/// related screen, and "Mark all as read" clears the badge in one tap.
class NotificationInboxPage extends StatefulWidget {
  const NotificationInboxPage({super.key});

  @override
  State<NotificationInboxPage> createState() => _NotificationInboxPageState();
}

class _NotificationInboxPageState extends State<NotificationInboxPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          // The thread list lives behind the bell, not in the dashboard header:
          // this is already where people look for what is new.
          IconButton(
            tooltip: 'Messages',
            onPressed: () => context.push(MessagingEntry.list),
            icon: const Icon(Icons.forum_outlined, color: Const.aqua, size: 22),
          ),
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is! NotificationsLoaded || state.unread == 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () =>
                    context.read<NotificationsCubit>().markAllRead(),
                child: const Text(
                  'Mark all as read',
                  style: TextStyle(color: Const.aqua, fontSize: 13),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          switch (state) {
            case NotificationsInitial() || NotificationsLoading():
              return const Center(
                child: CircularProgressIndicator(color: Const.aqua),
              );
            case NotificationsError(:final message):
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(message),
                    TextButton(
                      onPressed: () =>
                          context.read<NotificationsCubit>().load(),
                      child: const Text('Retry',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            case NotificationsLoaded(:final items):
              if (items.isEmpty) return const _EmptyState();
              return RefreshIndicator(
                onRefresh: () => context.read<NotificationsCubit>().load(),
                backgroundColor: Colors.white,
                color: Const.aqua,
                child: _GroupedList(
                  controller: _scrollController,
                  state: state,
                ),
              );
          }
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "You're all caught up",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            'Booking updates will show up here.',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

/// Items grouped under Today / Yesterday / Earlier headers.
class _GroupedList extends StatelessWidget {
  final ScrollController controller;
  final NotificationsLoaded state;

  const _GroupedList({required this.controller, required this.state});

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows(state.items);
    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.only(bottom: 32),
      itemCount: rows.length + (state.loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= rows.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: Const.aqua),
            ),
          );
        }
        final row = rows[index];
        if (row is String) return _SectionHeader(label: row);
        return _NotificationTile(notification: row as AppNotification);
      },
    );
  }

  /// Flatten into [String header | AppNotification] rows.
  List<Object> _buildRows(List<AppNotification> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String sectionOf(AppNotification n) {
      final at = n.createdAt?.toLocal();
      if (at == null) return 'Earlier';
      final day = DateTime(at.year, at.month, at.day);
      if (day == today) return 'Today';
      if (day == yesterday) return 'Yesterday';
      return 'Earlier';
    }

    final rows = <Object>[];
    String? current;
    for (final n in items) {
      final section = sectionOf(n);
      if (section != current) {
        rows.add(section);
        current = section;
      }
      rows.add(n);
    }
    return rows;
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8A96BC),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    final visual = _visualFor(notification.type);

    return Material(
      color: unread ? Const.aqua.withValues(alpha: 0.06) : Colors.white,
      child: InkWell(
        onTap: () => _onTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: visual.color.withValues(alpha: 0.12),
                child: Icon(visual.icon, size: 20, color: visual.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  unread ? FontWeight.w700 : FontWeight.w500,
                              color: const Color(0xFF232F55),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _relativeTime(notification.createdAt),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: unread ? Colors.grey[800] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (unread)
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 6),
                  child: Icon(Icons.circle, size: 8, color: Const.aqua),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    context.read<NotificationsCubit>().markRead(notification);

    final type = notification.type ?? '';
    // A message notification always points at its conversation.
    if (notification.threadId != null) {
      context.push(MessagingEntry.threadPath(notification.threadId!));
      return;
    }
    // Nurse offer → the Pending inbox tab (same target as the FCM tap).
    // `/appointment` is a bottom-nav shell branch: switch to it with `go` —
    // pushing a branch route duplicates the shell page key and crashes.
    if (type == 'offer.received') {
      context.go(AppRoutes.appointment);
      return;
    }
    if (notification.appointmentId != null) {
      context.push(AppointmentRoutes.detailPath(notification.appointmentId!));
      return;
    }
    if (notification.careTaskId != null) {
      context
          .push(AppointmentRoutes.careTaskDetailPath(notification.careTaskId!));
    }
  }

  ({IconData icon, Color color}) _visualFor(String? type) {
    final t = type ?? '';
    if (t.endsWith('.cancelled')) {
      return (icon: Icons.event_busy, color: Colors.red);
    }
    if (t.endsWith('.completed')) {
      return (icon: Icons.task_alt, color: Colors.green);
    }
    if (t == 'booking.confirmed' || t == 'appointment.accepted') {
      return (icon: Icons.check_circle_outline, color: Colors.green);
    }
    if (t.startsWith('booking.reminder')) {
      return (icon: Icons.alarm, color: const Color(0xFFE59500));
    }
    if (t == 'offer.received' || t == 'appointment.pending') {
      return (icon: Icons.assignment_outlined, color: Const.aqua);
    }
    if (t == 'message.received') {
      return (icon: Icons.forum_outlined, color: Const.aqua);
    }
    if (t == 'time.proposed' || t == 'time.accepted' || t == 'time.declined') {
      return (icon: Icons.event_repeat, color: Const.primaryBlue);
    }
    if (t == 'estimate.revised') {
      return (icon: Icons.receipt_long_outlined, color: Const.tosca);
    }
    if (t == 'handoff.requested' || t == 'intake.halted') {
      return (icon: Icons.support_agent, color: Colors.deepOrange);
    }
    return (icon: Icons.notifications_none, color: Const.aqua);
  }

  String _relativeTime(DateTime? at) {
    if (at == null) return '';
    final diff = DateTime.now().difference(at.toLocal());
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    final local = at.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }
}
