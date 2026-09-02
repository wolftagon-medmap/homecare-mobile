import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/patient_inbox_cubit.dart';
import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';
import 'package:m2health/features/appointment/widgets/booking_card.dart';
import 'package:m2health/features/appointment/widgets/cancel_appoinment_dialog.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/messaging/domain/entities/message_thread.dart';
import 'package:m2health/features/messaging/presentation/widgets/message_action_button.dart';
import 'package:m2health/features/messaging/presentation/widgets/propose_time_sheet.dart';
import 'package:m2health/features/messaging/presentation/widgets/time_proposal_alert.dart';
import 'package:m2health/route/app_routes.dart';

/// The patient Pending tab: the unified inbox of v1 pending appointments +
/// v2 pre-acceptance care tasks. The other tabs stay on the v1 appointment
/// list. Appointment cards keep Cancel/Reschedule/Pay; care-task cards are
/// tap-to-detail only.
class PatientInboxTab extends StatelessWidget {
  const PatientInboxTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientInboxCubit, PatientInboxState>(
      listener: (context, state) {
        if (state is PatientInboxActionSucceed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ));
          // A cancelled booking lands in the Cancelled tab — refresh it.
          context
              .read<AppointmentCubit>()
              .fetchAppointments(AppointmentStatus.cancelled, isRefresh: true);
        } else if (state is PatientInboxError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ));
        }
      },
      builder: (context, state) {
        if (state is PatientInboxLoading || state is PatientInboxInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PatientInboxError) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<PatientInboxCubit>().fetchInbox(),
          );
        }
        final items = state is PatientInboxLoaded
            ? state.items
            : const <PatientInboxItem>[];
        return RefreshIndicator(
          onRefresh: () => context.read<PatientInboxCubit>().fetchInbox(),
          backgroundColor: Colors.white,
          color: Const.aqua,
          child: items.isEmpty
              ? const _EmptyView()
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.only(bottom: 64),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      _PatientInboxCard(item: items[index]),
                ),
        );
      },
    );
  }
}

class _PatientInboxCard extends StatelessWidget {
  final PatientInboxItem item;
  const _PatientInboxCard({required this.item});

  Color get _statusColor {
    switch (item.status.toLowerCase()) {
      case 'waiting_for_payment':
      case 'pending':
      case 'matched':
        return const Color(0xFFE59500); // Orange
      case 'time_proposed':
        return Const.primaryBlue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (item.isCareTask) {
      return Column(
        children: [
          BookingCard(
            avatarUrl: item.provider?.avatar,
            title: item.provider?.name ?? item.serviceLabel,
            subtitle: item.provider != null
                ? item.serviceLabel
                : (item.patientName != null ? 'For ${item.patientName}' : null),
            statusLabel: item.statusLabel,
            statusColor: _statusColor,
            scheduledStart: item.scheduledStart,
            priceLabel: _estimateLabel,
            onTap: item.careTaskId != null
                ? () => _openCareTaskDetail(context)
                : null,
            actions: [
              if (item.careTaskId != null)
                MessageActionButton(
                  threadRef: ThreadRef.forCareTask(item.careTaskId!),
                  label: 'Message ${item.provider?.name ?? 'professional'}',
                ),
            ],
          ),
          // A proposal is answered without opening the conversation, because
          // the answer is a decision, not a reply.
          if (item.hasTimeProposal)
            TimeProposalAlert(
              proposedStart: item.proposal!.proposedStart,
              proposedEnd: item.proposal!.proposedEnd,
              originalStart: item.scheduledStart,
              expiresAt: item.proposal!.expiresAt,
              reason: item.proposal!.reason,
              professionalName: item.provider?.name,
              onAccept: () => _acceptProposal(context),
              onChooseAnother: () => _chooseAnother(context),
            ),
        ],
      );
    }

    return BookingCard(
      avatarUrl: item.provider?.avatar,
      title: item.provider?.name ?? 'Unknown Provider',
      subtitle: item.provider?.jobTitle?.toTitleCase(),
      statusLabel: item.statusLabel,
      statusColor: _statusColor,
      scheduledStart: item.scheduledStart,
      priceLabel: item.estimatedPrice != null && item.estimatedPrice! > 0
          ? '\$${item.estimatedPrice!.toStringAsFixed(2)}'
          : null,
      onTap: () =>
          context.push(AppRoutes.appointmentDetail, extra: item.appointmentId),
      actions: _appointmentActions(context),
    );
  }

  String? get _estimateLabel =>
      item.estimatedPrice != null && item.estimatedPrice! > 0
          ? 'Est. \$${item.estimatedPrice!.toStringAsFixed(2)}'
          : null;

  Future<void> _acceptProposal(BuildContext context) async {
    await context
        .read<PatientInboxCubit>()
        .respondToProposal('New time accepted. Your booking is confirmed.');
  }

  Future<void> _chooseAnother(BuildContext context) async {
    final cubit = context.read<PatientInboxCubit>();
    final slot = await showProposeTimeSheet(
      context,
      title: 'Which time suits you?',
      confirmLabel: 'Send this time',
      initial: item.scheduledStart?.toLocal(),
      askReason: false,
    );
    if (slot == null) return;
    await cubit.respondToProposal('Your preferred time has been sent.');
  }

  Future<void> _openCareTaskDetail(BuildContext context) async {
    final cubit = context.read<PatientInboxCubit>();
    await context.push(AppRoutes.careTaskDetail, extra: item.careTaskId);
    // Status may have moved (accepted/cancelled) while the detail was open.
    await cubit.fetchInbox();
  }

  List<Widget> _appointmentActions(BuildContext context) {
    final status = item.status.toLowerCase();
    final cancelButton = OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => CancelAppoinmentDialog(onPressYes: (selection) {
            context.read<PatientInboxCubit>().cancelAppointment(
                  item.appointmentId!,
                  cancellationReason: selection.cancellationReason,
                  otherReason: selection.otherReason,
                );
          }),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        context.l10n.appointment_cancel_booking_btn,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );

    final rescheduleButton = _GradientButton(
      label: context.l10n.appointment_reschedule_btn,
      onPressed: () => _openReschedule(context),
    );

    final payButton = _GradientButton(
      label: 'Pay',
      onPressed: () => _openPayment(context),
    );

    if (status == 'waiting_for_payment') {
      return [
        Expanded(child: cancelButton),
        const SizedBox(width: 10),
        Expanded(child: payButton),
      ];
    }
    return [
      Expanded(child: cancelButton),
      const SizedBox(width: 10),
      Expanded(child: rescheduleButton),
    ];
  }

  Future<void> _openReschedule(BuildContext context) async {
    final cubit = context.read<PatientInboxCubit>();
    final appointment = await cubit.loadAppointment(item.appointmentId!);
    if (appointment?.provider == null || !context.mounted) return;
    await GoRouter.of(context).pushNamed(
      AppRoutes.scheduleAppoointment,
      extra: ScheduleAppointmentPageData(
        professional: appointment!.provider!,
        currentAppointment: appointment,
      ),
    );
    await cubit.fetchInbox();
  }

  Future<void> _openPayment(BuildContext context) async {
    final cubit = context.read<PatientInboxCubit>();
    final appointment = await cubit.loadAppointment(item.appointmentId!);
    if (appointment == null || !context.mounted) return;
    await context.push(AppRoutes.payment, extra: appointment);
    await cubit.fetchInbox();
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Color(0xFF35C5CF), Color(0xFF9DCEFF)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/illustration/empty_appointments.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.appointment_list_empty(
                    context.l10n.appointment_status_pending.toLowerCase()),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
