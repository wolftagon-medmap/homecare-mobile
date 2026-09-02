import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';

import '../../domain/entities/message_thread.dart';
import '../bloc/thread_cubit.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_composer.dart';
import '../widgets/propose_time_sheet.dart';
import '../widgets/thread_view.dart';

/// The professional's side.
///
/// The difference from the patient's screen is the composer: this is where
/// **Suggest another time** lives, because the conversation is what the offer
/// decision is made from. Cards are read-only here — the professional raised
/// them, the patient answers them.
class ProfessionalChatPage extends StatefulWidget {
  final MessageThread? thread;

  const ProfessionalChatPage({super.key, this.thread});

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
    final name = counterpart?.name ?? 'Patient';
    final closed = widget.thread?.isOpen == false;

    return Scaffold(
      backgroundColor: Const.grayLight,
      appBar: ChatAppBar(
        name: name,
        subtitle: widget.thread?.serviceLabel,
        avatar: counterpart?.avatar,
      ),
      body: ThreadView(
        counterpartUserId: counterpart?.userId,
        canRespondToCards: false,
        counterpartName: name,
      ),
      bottomNavigationBar: BlocBuilder<ThreadCubit, ThreadState>(
        buildWhen: (a, b) => a.sending != b.sending,
        builder: (context, state) => ChatComposer(
          enabled: !closed,
          sending: state.sending,
          hint: 'Message $name',
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
    );
  }
}
