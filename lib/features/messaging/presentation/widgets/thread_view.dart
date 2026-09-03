import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/message_thread.dart';
import '../bloc/thread_cubit.dart';
import 'chat_bubble.dart';
import 'estimate_revision_card.dart';
import 'package:m2health/core/presentation/widgets/messaging/propose_time_sheet.dart';
import 'thread_context_card.dart';
import 'time_proposal_card.dart';

/// The conversation itself, shared by both chat screens.
///
/// The patient screen and the professional screen differ only in who may act on
/// a card and what the composer can raise — the transcript is the same object
/// seen from two sides, so it is one widget.
class ThreadView extends StatefulWidget {
  /// The other voice in the thread. Everything a person wrote that is not
  /// theirs is the viewer's, which is what puts a bubble on the right.
  final int? counterpartUserId;

  /// Only the patient accepts a proposal or approves an estimate. The
  /// professional who raised it sees the same card, read-only.
  final bool canRespondToCards;
  final String counterpartName;

  /// What the conversation is about. Rendered above the first message, so an
  /// empty thread still says why it exists.
  final String serviceLabel;
  final ThreadContext threadContext;

  /// The openers offered while the transcript is empty.
  final List<String> openers;

  const ThreadView({
    super.key,
    required this.counterpartUserId,
    required this.canRespondToCards,
    required this.counterpartName,
    this.serviceLabel = '',
    this.threadContext = const ThreadContext(),
    this.openers = const [],
  });

  @override
  State<ThreadView> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _toBottom() {
    if (!_scroll.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThreadCubit, ThreadState>(
      listenWhen: (before, after) =>
          before.messages.length != after.messages.length ||
          after.error != null,
      listener: (context, state) {
        _toBottom();
        final error = state.error;
        if (error == null) return;
        // A failed card action must say so without wiping the conversation.
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ));
        context.read<ThreadCubit>().clearError();
      },
      builder: (context, state) {
        if (state.loading) {
          return const BookingLoadingState(message: 'Loading the conversation');
        }
        final rows = _rows(state.messages);
        final header = _header();

        return Container(
          color: Const.grayLight,
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.only(top: 4, bottom: 16),
            itemCount: header.length + rows.length,
            itemBuilder: (context, index) => index < header.length
                ? header[index]
                : _row(context, rows[index - header.length], state),
          ),
        );
      },
    );
  }

  /// The context card, plus the openers while nobody has written anything.
  List<Widget> _header() {
    final cubit = context.read<ThreadCubit>();
    final empty = cubit.state.messages.isEmpty;

    return [
      if (!widget.threadContext.isEmpty || widget.serviceLabel.isNotEmpty)
        ThreadContextCard(
          serviceLabel: widget.serviceLabel,
          context_: widget.threadContext,
        ),
      if (empty && widget.openers.isNotEmpty)
        ChatOpeners(
          openers: widget.openers,
          onPick: cubit.useOpener,
        ),
    ];
  }

  Widget _row(BuildContext context, Object row, ThreadState state) {
    if (row is DateTime) return ChatDayDivider(day: row);

    final message = row as ChatMessage;
    final cubit = context.read<ThreadCubit>();

    switch (message.kind) {
      case MessageKind.system:
        return ChatSystemLine(text: message.body ?? '');

      case MessageKind.timeProposal:
        final proposal = message.timeProposal;
        if (proposal == null) return const SizedBox.shrink();
        return TimeProposalCard(
          proposal: proposal,
          canRespond: widget.canRespondToCards,
          busy: state.sending,
          onAccept: () => cubit.acceptProposal(proposal.proposalId),
          onChooseAnother: () => _chooseAnother(context, proposal.proposalId),
        );

      case MessageKind.estimateRevision:
        final revision = message.estimateRevision;
        if (revision == null) return const SizedBox.shrink();
        return EstimateRevisionCard(
          revision: revision,
          canApprove: widget.canRespondToCards,
          busy: state.sending,
          onApprove: () => cubit.approveEstimate(revision.revisionId),
        );

      case MessageKind.text:
        return ChatBubble(
          message: message,
          isMine: message.isMine(widget.counterpartUserId),
          authorName: widget.counterpartName,
        );
    }
  }

  Future<void> _chooseAnother(BuildContext context, int proposalId) async {
    final cubit = context.read<ThreadCubit>();
    // Deliberately not a bare "no thanks": choosing another without saying which
    // one is a round trip nobody needs. The patient names a time here, so the
    // professional gets something to act on.
    final slot = await showProposeTimeSheet(
      context,
      title: 'Which time suits you?',
      confirmLabel: 'Send this time',
      askReason: false,
    );
    if (slot == null) return;
    await cubit.chooseAnotherTime(proposalId, preferred: slot.start);
  }

  /// Flatten into `[DateTime header | ChatMessage]`.
  List<Object> _rows(List<ChatMessage> messages) {
    final rows = <Object>[];
    DateTime? currentDay;
    for (final message in messages) {
      final at = message.createdAt.toLocal();
      final day = DateTime(at.year, at.month, at.day);
      if (currentDay != day) {
        rows.add(day);
        currentDay = day;
      }
      rows.add(message);
    }
    return rows;
  }
}
