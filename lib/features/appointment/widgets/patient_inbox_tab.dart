import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/patient_inbox_cubit.dart';
import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';
import 'package:m2health/features/appointment/widgets/booking_card.dart';
import 'package:m2health/core/messaging/thread_index_cubit.dart';
import 'package:m2health/core/messaging/thread_ref.dart';
import 'package:m2health/core/presentation/widgets/messaging/message_action_button.dart';
import 'package:m2health/route/appointment_routes.dart';

/// The patient Pending tab: pre-acceptance care tasks. The other tabs stay on
/// the v1 appointment list. Cards are tap-to-detail; cancel/reschedule/pay
/// live on the care-task detail page once a booking has an appointment.
class PatientInboxTab extends StatelessWidget {
  const PatientInboxTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientInboxCubit, PatientInboxState>(
      listener: (context, state) {
        if (state is PatientInboxLoaded) {
          // A booking sent moments ago already has a thread on the server, but
          // this app's index was built before it existed — so the card's chat
          // entry would render nothing until something else refreshed it.
          context.read<ThreadIndexCubit>().refresh();
        }
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
      case 'unmatched':
        return const Color(0xFFD64545);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BookingCard(
      avatarUrl: item.provider?.avatar,
      title: item.provider?.name ?? item.serviceLabel,
      subtitle: item.provider != null
          ? item.serviceLabel
          : (item.patientName != null ? 'For ${item.patientName}' : null),
      statusLabel: item.statusLabel,
      statusColor: _statusColor,
      scheduledStart: item.scheduledStart,
      priceLabel: _estimateLabel,
      onTap: () => _openCareTaskDetail(context),
      actions: [
        // An unmatched booking is waiting on the patient, and its threads are
        // all closed — so the card offers the way out instead of a chat entry
        // that would render nothing.
        if (item.isUnmatched)
          _PickAnotherTimeButton(careTaskId: item.careTaskId)
        else
          // Full width and gradient, the same as the appointment cards it
          // sits beside in this list: the conversation is the main thing to
          // do with a booking, whichever kind it is.
          Expanded(
            child: MessageActionButton(
              threadRef: ThreadRef.forCareTask(item.careTaskId),
              style: MessageActionStyle.gradient,
              label: 'Chat',
            ),
          ),
      ],
    );
  }

  String? get _estimateLabel =>
      item.estimatedPrice != null && item.estimatedPrice! > 0
          ? 'Est. \$${item.estimatedPrice!.toStringAsFixed(2)}'
          : null;

  Future<void> _openCareTaskDetail(BuildContext context) async {
    final cubit = context.read<PatientInboxCubit>();
    await context.push(AppointmentRoutes.careTaskDetailPath(item.careTaskId));
    // Status may have moved (accepted/cancelled) while the detail was open.
    await cubit.fetchInbox();
  }
}

/// Opens the booking so the patient picks a new time there. The detail page
/// owns the retry — the card only has to stop being a dead end.
class _PickAnotherTimeButton extends StatelessWidget {
  final int careTaskId;

  const _PickAnotherTimeButton({required this.careTaskId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final cubit = context.read<PatientInboxCubit>();
        await context.push(AppointmentRoutes.careTaskDetailPath(careTaskId));
        await cubit.fetchInbox();
      },
      icon: const Icon(Icons.event_repeat, size: 16),
      style: ElevatedButton.styleFrom(
        backgroundColor: Const.aqua,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      label: const Text(
        'Pick another time',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
