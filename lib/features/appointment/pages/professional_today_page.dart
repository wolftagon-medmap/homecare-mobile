import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/provider_inbox_cubit.dart';
import 'package:m2health/features/appointment/data/models/inbox_item.dart';
import 'package:flutter_svg/svg.dart';
import 'package:m2health/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_cubit.dart';
import 'package:m2health/features/professional_profile/presentation/bloc/professional_profile_state.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

/// The professional's home.
///
/// Replaces the patient dashboard, which offered a nurse a menu for booking a
/// nurse. This answers the three questions a professional opens the app with:
/// is anything waiting on me, what is next, and how has this week gone.
class ProfessionalTodayPage extends StatelessWidget {
  const ProfessionalTodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderInboxCubit(sl<Dio>())..fetchInbox(),
      child: const _TodayView(),
    );
  }
}

class _TodayView extends StatefulWidget {
  const _TodayView();

  @override
  State<_TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<_TodayView> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderAppointmentCubit>().fetchProviderAppointments();
  }

  Future<void> _refresh() async {
    context.read<ProviderInboxCubit>().fetchInbox();
    await context.read<ProviderAppointmentCubit>().fetchProviderAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Const.grayLight,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Const.aqua,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          children: const [
            _GreetingHeader(),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  _PendingSection(),
                  SizedBox(height: 20),
                  _TodayScheduleSection(),
                  SizedBox(height: 20),
                  _WeekSummary(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mirrors the patient dashboard header — same gradient, logo, bell and avatar —
/// so both roles open on a screen that reads as the same product. The patient
/// service menu and assistant box have no professional equivalent and are not
/// carried over.
class _GreetingHeader extends StatefulWidget {
  const _GreetingHeader();

  @override
  State<_GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<_GreetingHeader> {
  late final NotificationsCubit _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = NotificationsCubit(sl<Dio>())..load();
  }

  @override
  void dispose() {
    _notifications.close();
    super.dispose();
  }

  void _openInbox() {
    _notifications.load();
    GoRouter.of(context)
        .push(AppRoutes.notificationInbox, extra: _notifications);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 16, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8EF4E8), Color(0xFF35C5CF)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: BlocBuilder<ProfessionalProfileCubit, ProfessionalProfileState>(
        builder: (context, state) {
          final profile =
              state is ProfessionalProfileLoaded ? state.profile : null;
          final name =
              (profile?.name?.isNotEmpty ?? false) ? profile!.name! : '';
          final avatar = profile?.avatar;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(Const.banner,
                      fit: BoxFit.contain, height: 36),
                  const Spacer(),
                  _NotificationBell(cubit: _notifications, onTap: _openInbox),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.profile),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: avatar != null && avatar.isNotEmpty
                          ? Image.network(
                              avatar,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const _AvatarFallback(),
                            )
                          : const _AvatarFallback(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                name.isEmpty ? 'Welcome back' : 'Welcome back, $name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('EEEE, d MMMM').format(DateTime.now()),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.cubit, required this.onTap});

  final NotificationsCubit cubit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: cubit,
      builder: (context, state) {
        final unread = state.unreadCount;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none,
                    color: Colors.white, size: 28),
                if (unread > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          unread > 9 ? '9+' : '$unread',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: Colors.white.withValues(alpha: 0.25),
      child: const Icon(Icons.person, color: Colors.white, size: 32),
    );
  }
}

/// Offers and pending requests. Time-limited, so this sits above everything.
class _PendingSection extends StatelessWidget {
  const _PendingSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderInboxCubit, ProviderInboxState>(
      builder: (context, state) {
        if (state is ProviderInboxLoading || state is ProviderInboxInitial) {
          return const _CardShell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final items =
            state is ProviderInboxLoaded ? state.items : const <InboxItem>[];
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Waiting for your response',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (final item in items.take(2)) _OfferCard(item: item),
            if (items.length > 2)
              TextButton(
                onPressed: () => context.go(AppRoutes.appointment),
                child: Text('View all ${items.length} requests'),
              ),
          ],
        );
      },
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.item});

  final InboxItem item;

  @override
  Widget build(BuildContext context) {
    final expiry = item.expiresAt;
    final remaining = expiry?.difference(DateTime.now());

    return _CardShell(
      accent: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              if (remaining != null && !remaining.isNegative)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    remaining.inMinutes < 60
                        ? '${remaining.inMinutes}m left'
                        : '${remaining.inHours}h left',
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          _IconLine(
              icon: Icons.medical_services_outlined, text: item.serviceLabel),
          if (item.scheduledStart != null)
            _IconLine(
              icon: Icons.schedule,
              text:
                  DateFormat('EEE d MMM • HH:mm').format(item.scheduledStart!),
            ),
          if (item.summary.location != null)
            _IconLine(
                icon: Icons.location_on_outlined, text: item.summary.location!),
          if (item.estimatedIncome != null)
            _IconLine(
              icon: Icons.payments_outlined,
              text: '\$${item.estimatedIncome!.toStringAsFixed(2)}',
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go(AppRoutes.appointment),
              style: OutlinedButton.styleFrom(
                foregroundColor: Const.tosca,
                side: const BorderSide(color: Const.aqua),
              ),
              child: const Text('Review'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Accepted visits happening today, with the next one given prominence.
class _TodayScheduleSection extends StatelessWidget {
  const _TodayScheduleSection();

  static bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderAppointmentCubit, ProviderAppointmentState>(
      builder: (context, state) {
        if (state is ProviderAppointmentLoading ||
            state is ProviderAppointmentInitial) {
          return const _CardShell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final all = state is ProviderAppointmentLoaded
            ? state.appointments
            : const <AppointmentEntity>[];
        final accepted = all
            .where((a) => a.status.toLowerCase() == 'accepted')
            .toList()
          ..sort((a, b) => a.startDatetime.compareTo(b.startDatetime));
        final today = accepted.where((a) => _isToday(a.startDatetime)).toList();
        final upcoming = accepted
            .where((a) => a.startDatetime.isAfter(DateTime.now()))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's visits",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (today.isEmpty)
              _EmptyToday(nextUp: upcoming.isNotEmpty ? upcoming.first : null)
            else
              for (final a in today) _VisitCard(appointment: a),
          ],
        );
      },
    );
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final patient = appointment.patientProfile?.name ?? 'Patient';

    return _CardShell(
      accent: Const.aqua,
      onTap: appointment.id == null
          ? null
          : () => context.push(
              '${AppRoutes.appointment}/provider-detail/${appointment.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('HH:mm').format(appointment.startDatetime),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Const.tosca,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  patient,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _IconLine(
              icon: Icons.medical_services_outlined, text: appointment.summary),
          if (appointment.locationAddress != null)
            _IconLine(
                icon: Icons.location_on_outlined,
                text: appointment.locationAddress!),
        ],
      ),
    );
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday({this.nextUp});

  final AppointmentEntity? nextUp;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.free_breakfast_outlined, color: Colors.grey.shade500),
              const SizedBox(width: 10),
              const Text(
                'No visits scheduled today',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (nextUp != null)
            Text(
              'Next: ${DateFormat('EEE d MMM • HH:mm').format(nextUp!.startDatetime)}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            )
          else ...[
            Text(
              'Nothing upcoming. Patients can only be matched with you when your '
              'availability is set.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.availability),
              style: OutlinedButton.styleFrom(
                foregroundColor: Const.tosca,
                side: const BorderSide(color: Const.aqua),
              ),
              child: const Text('Set availability'),
            ),
          ],
        ],
      ),
    );
  }
}

/// A first step toward earnings visibility, which the app has none of today.
/// Derived from completed appointments rather than a payouts endpoint, so it is
/// what was booked, not what has been paid out.
class _WeekSummary extends StatelessWidget {
  const _WeekSummary();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderAppointmentCubit, ProviderAppointmentState>(
      builder: (context, state) {
        if (state is! ProviderAppointmentLoaded) return const SizedBox.shrink();

        final now = DateTime.now();
        final weekStart = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));
        final completed = state.appointments.where((a) =>
            a.status.toLowerCase() == 'completed' &&
            a.startDatetime.isAfter(weekStart));

        final count = completed.length;
        final total =
            completed.fold<double>(0, (sum, a) => sum + (a.order?.total ?? 0));

        return _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This week',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _Stat(label: 'Visits completed', value: '$count')),
                  Expanded(
                    child: _Stat(
                      label: 'Booked value',
                      value: '\$${total.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Const.tosca,
          ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, this.accent, this.onTap});

  final Widget child;
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: accent == null
            ? BorderSide.none
            : BorderSide(color: accent!.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(padding: const EdgeInsets.all(14), child: child),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
