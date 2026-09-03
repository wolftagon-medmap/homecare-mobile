import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/cancel_appointment_dialog.dart';
import 'package:m2health/core/presentation/widgets/messaging/propose_time_sheet.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/i18n/translations.g.dart';

import '../../domain/entities/message_thread.dart';
import '../bloc/thread_cubit.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_composer.dart';
import '../widgets/thread_view.dart';

/// The patient's side. The patient is the one who answers cards — accepting a
/// time and approving an estimate are theirs to do.
class PatientChatPage extends StatefulWidget {
  final MessageThread? thread;

  /// Shown when a deep link opens the thread before the list has been loaded.
  final String? fallbackName;

  const PatientChatPage({super.key, this.thread, this.fallbackName});

  @override
  State<PatientChatPage> createState() => _PatientChatPageState();
}

class _PatientChatPageState extends State<PatientChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ThreadCubit>().load();
  }

  /// Moving a booked visit is a proposal the professional answers, not a
  /// change the patient makes alone — the same card either of them raises.
  Future<void> _proposeReschedule() async {
    final careTaskId = widget.thread?.careTaskId;
    if (careTaskId == null) return;

    final slot = await showProposeTimeSheet(
      context,
      title: 'Suggest another time',
      confirmLabel: 'Send suggestion',
    );
    if (slot == null || !mounted) return;

    await context.read<ThreadCubit>().proposeTime(
          careTaskId: careTaskId,
          start: slot.start,
          end: slot.end,
          reason: slot.reason,
        );
  }

  Future<void> _cancelBooking() async {
    final appointmentId = widget.thread?.appointmentId;
    if (appointmentId == null) return;

    await showDialog<void>(
      context: context,
      builder: (_) => CancelAppoinmentDialog(
        onPressYes: (selection) async {
          final messenger = ScaffoldMessenger.of(context);
          try {
            await AppointmentService(sl<Dio>()).cancelAppointment(
              appointmentId,
              cancellationReason: selection.cancellationReason,
              otherReason: selection.otherReason,
            );
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Booking cancelled'),
                backgroundColor: Colors.green,
              ));
          } catch (_) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Cancellation failed. Please try again.'),
                backgroundColor: Colors.red,
              ));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final counterpart = widget.thread?.counterpart;
    final name =
        counterpart?.name ?? widget.fallbackName ?? 'Your professional';
    final closed = widget.thread?.isOpen == false;

    return Scaffold(
      backgroundColor: Const.grayLight,
      appBar: ChatAppBar(
        name: name,
        subtitle: widget.thread?.serviceLabel,
        avatar: counterpart?.avatar,
      ),
      body: Column(
        children: [
          Expanded(
              child: ThreadView(
            counterpartUserId: counterpart?.userId,
            canRespondToCards: true,
            counterpartName: name,
            serviceLabel: widget.thread?.serviceLabel ?? '',
            threadContext: widget.thread?.context ?? const ThreadContext(),
            openers: context.t.messaging.chat.openersPatient,
          )),
          BlocBuilder<ThreadCubit, ThreadState>(
            buildWhen: (a, b) => a.sending != b.sending || a.draft != b.draft,
            builder: (context, state) => ChatComposer(
              enabled: !closed,
              sending: state.sending,
              hint: 'Message $name',
              draft: state.draft,
              onSend: (text) => context.read<ThreadCubit>().send(text),
              actions: [
                // Only once there is a visit to move or call off. Before that
                // the patient answers the professional's card instead.
                if (widget.thread?.appointmentId != null) ...[
                  ComposerAction(
                    icon: Icons.event_repeat,
                    label: 'Suggest another time',
                    description: 'They confirm before anything moves',
                    onTap: state.sending ? null : _proposeReschedule,
                  ),
                  ComposerAction(
                    icon: Icons.event_busy_outlined,
                    label: 'Cancel booking',
                    onTap: state.sending ? null : _cancelBooking,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
