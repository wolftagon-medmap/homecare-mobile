import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/i18n/translations.g.dart';

import '../../domain/entities/message_thread.dart';
import '../bloc/thread_cubit.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_composer.dart';
import 'package:m2health/core/presentation/widgets/messaging/propose_time_sheet.dart';
import '../widgets/thread_view.dart';

/// The professional's side.
///
/// The difference from the patient's screen is the composer: cancelling a
/// booking is the patient's alone, so this side offers only the time.
///
/// **Suggest another time** covers both situations. Before a booking it is the
/// counter-offer the decision is made from; after one it proposes moving the
/// visit, which the patient then confirms.
class ProfessionalChatPage extends StatefulWidget {
  final MessageThread? thread;

  /// Shown when a deep link opens the thread before the list has been loaded.
  final String? fallbackName;

  const ProfessionalChatPage({super.key, this.thread, this.fallbackName});

  @override
  State<ProfessionalChatPage> createState() => _ProfessionalChatPageState();
}

class _ProfessionalChatPageState extends State<ProfessionalChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ThreadCubit>().load();
  }

  Future<void> _suggestAnotherTime() async {
    final cubit = context.read<ThreadCubit>();
    final careTaskId = widget.thread?.careTaskId;
    if (careTaskId == null) return;

    final slot = await showProposeTimeSheet(
      context,
      title: 'Suggest another time',
      confirmLabel: 'Send suggestion',
    );
    if (slot == null) return;

    await cubit.proposeTime(
      careTaskId: careTaskId,
      start: slot.start,
      end: slot.end,
      reason: slot.reason,
    );
  }

  @override
  Widget build(BuildContext context) {
    final counterpart = widget.thread?.counterpart;
    final name = counterpart?.name ?? widget.fallbackName ?? 'Patient';
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
            canRespondToCards: false,
            counterpartName: name,
            serviceLabel: widget.thread?.serviceLabel ?? '',
            threadContext: widget.thread?.context ?? const ThreadContext(),
            openers: context.t.messaging.chat.openersProfessional,
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
                ComposerAction(
                  icon: Icons.event_repeat,
                  label: 'Suggest another time',
                  onTap: state.sending ? null : _suggestAnotherTime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
