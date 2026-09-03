import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
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
      body: ThreadView(
        counterpartUserId: counterpart?.userId,
        canRespondToCards: true,
        counterpartName: name,
        serviceLabel: widget.thread?.serviceLabel ?? '',
        threadContext: widget.thread?.context ?? const ThreadContext(),
        openers: context.t.messaging.chat.openersPatient,
      ),
      bottomNavigationBar: BlocBuilder<ThreadCubit, ThreadState>(
        buildWhen: (a, b) => a.sending != b.sending || a.draft != b.draft,
        builder: (context, state) => ChatComposer(
          enabled: !closed,
          sending: state.sending,
          hint: 'Message $name',
          draft: state.draft,
          onSend: (text) => context.read<ThreadCubit>().send(text),
        ),
      ),
    );
  }
}
