import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/widgets/provider_appointment_action_dialog.dart';
import 'package:m2health/features/home_health_screening/presentation/widgets/screening_appointment_list_action_buttons.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

class ProviderAppointmentPage extends StatefulWidget {
  const ProviderAppointmentPage({super.key});

  @override
  State<ProviderAppointmentPage> createState() =>
      _ProviderAppointmentPageState();
}

class _ProviderAppointmentPageState extends State<ProviderAppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<ProviderAppointmentCubit>().fetchProviderAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.appointment_list_title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actionsPadding: const EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Filter.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Const.aqua,
          labelColor: Const.aqua,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: context.l10n.appointment_status_pending),
            Tab(text: context.l10n.appointment_status_accepted),
            Tab(text: context.l10n.appointment_status_completed),
            Tab(text: context.l10n.appointment_status_cancelled),
          ],
        ),
      ),
      body: BlocConsumer<ProviderAppointmentCubit, ProviderAppointmentState>(
        listener: (context, state) {
          log('ProviderAppointmentState changed: $state',
              name: 'ProviderAppointmentPage');
          if (state is ProviderAppointmentChangeSucceed) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(state.message ??
                        context.l10n.appointment_update_success_message),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is ProviderAppointmentError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: context.l10n.common_retry,
                  textColor: Colors.white,
                  onPressed: () {
                    context
                        .read<ProviderAppointmentCubit>()
                        .fetchProviderAppointments();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProviderAppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProviderAppointmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(context.l10n.common_error(state.message)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProviderAppointmentCubit>()
                          .fetchProviderAppointments();
                    },
                    child: Text(context.l10n.common_retry),
                  ),
                ],
              ),
            );
          } else if (state is ProviderAppointmentLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _ProviderAppointmentTab(
                  appointments: state.appointments,
                  status: 'pending',
                ),
                _ProviderAppointmentTab(
                  appointments: state.appointments,
                  status: 'accepted',
                ),
                _ProviderAppointmentTab(
                  appointments: state.appointments,
                  status: 'completed',
                ),
                _ProviderAppointmentTab(
                  appointments: state.appointments,
                  status: 'cancelled',
                ),
              ],
            );
          }
          return Center(child: Text(context.l10n.common_no_data));
        },
      ),
    );
  }
}

class _ProviderAppointmentTab extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final String status;

  const _ProviderAppointmentTab({
    required this.appointments,
    required this.status,
  });

  List<AppointmentEntity> get filteredAppointments => appointments
      .where((appointment) =>
          appointment.status.toLowerCase() == status.toLowerCase())
      .toList();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<ProviderAppointmentCubit>().fetchProviderAppointments(),
      backgroundColor: Colors.white,
      color: Const.aqua,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          if (filteredAppointments.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: buildEmptyAppointmentList(context, status),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 64.0),
              sliver: SliverList.builder(
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = filteredAppointments[index];
                  return _ProviderAppointmentCard(appointment: appointment);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildEmptyAppointmentList(BuildContext context, String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.l10n.appointment_list_empty(status.toLowerCase()),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _ProviderAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  const _ProviderAppointmentCard({required this.appointment});

  Profile get patient => appointment.patientProfile!;
  String get status => appointment.status;
  String get date {
    final localStarTime = appointment.startDatetime.toLocal();
    return DateFormat('EEEE, dd MMMM yyyy').format(localStarTime);
  }

  String get hourRange {
    final localStarTime = appointment.startDatetime.toLocal();
    final localEndTime = appointment.endDatetime!.toLocal();
    final startHour = DateFormat('hh:mm a').format(localStarTime);
    final endHour = DateFormat('hh:mm a').format(localEndTime);
    return '$startHour - $endHour';
  }

  String getStatusDescription(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return context.l10n.appointment_status_waiting_approval;
      case 'accepted':
        return context.l10n.appointment_status_accepted;
      case 'completed':
        return context.l10n.appointment_status_completed;
      case 'cancelled':
        return context.l10n.appointment_status_cancelled;
      default:
        return context.l10n.common_status;
    }
  }

  String getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return context.l10n.appointment_status_pending;
      case 'accepted':
        return context.l10n.appointment_status_accepted;
      case 'completed':
        return context.l10n.appointment_status_completed;
      case 'cancelled':
        return context.l10n.appointment_status_cancelled;
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(
          AppRoutes.providerAppointmentDetail,
          extra: appointment.id,
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: (patient.avatar != null)
                        ? NetworkImage(patient.avatar!)
                        : null,
                    child: (patient.avatar == null)
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              getStatusDescription(context, status),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const Text(' | ',
                                style: TextStyle(color: Colors.grey)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(appointment.status)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                getLocalizedStatus(context, appointment.status),
                                style: TextStyle(
                                  color: _getStatusColor(appointment.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              hourRange,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (appointment.summary.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.appointment_summary,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.summary,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.appointment_detail_total_amount(
                        appointment.payTotal.toStringAsFixed(2)),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF35C5CF),
                    ),
                  ),
                  _buildActionButtonsByAppointmentType(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// ---- Action Buttons by Appointment Type ----
  Widget _buildActionButtonsByAppointmentType() {
    switch (appointment.type.toLowerCase()) {
      case 'screening':
        return ScreeningAppointmentListActionButtons(appointment: appointment);
      default:
        return _ProviderActionButtons(appointment: appointment);
    }
  }
}

class _ProviderActionButtons extends StatelessWidget {
  final AppointmentEntity appointment;
  const _ProviderActionButtons({required this.appointment});

  String get status => appointment.status;

  @override
  Widget build(BuildContext context) {
    if (status.toLowerCase() == 'pending') {
      return _buildForPendingStatus(context);
    } else if (status.toLowerCase() == 'accepted') {
      return _buildForAcceptedStatus(context);
    } else if (status.toLowerCase() == 'completed') {
      return _buildForCompletedStatus(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildForPendingStatus(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () =>
              showDeclineAppointmentDialog(context, appointment.id!),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(80, 36),
          ),
          child: Text(context.l10n.appointment_decline_btn),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            showAcceptAppointmentDialog(context, appointment.id!);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF35C5CF),
            foregroundColor: Colors.white,
            minimumSize: const Size(80, 36),
          ),
          child: Text(context.l10n.appointment_accept_btn),
        ),
      ],
    );
  }

  Widget _buildForAcceptedStatus(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showCompleteAppointmentDialog(context, appointment.id!);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      child: Text(context.l10n.appointment_mark_complete_btn),
    );
  }

  Widget _buildForCompletedStatus(BuildContext context) {
    return const SizedBox.shrink();
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
    case 'accepted':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    case 'pending':
    default:
      return Colors.orange;
  }
}
