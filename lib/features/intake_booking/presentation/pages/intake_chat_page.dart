import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot_legacy/presentation/widgets/ai_data_consent.dart';
import 'package:m2health/features/intake_booking/domain/entities/session_summary.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_cubit.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_sessions_cubit.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_state.dart';
import 'package:m2health/features/intake_booking/presentation/pages/intake_session_viewer_page.dart';
import 'package:m2health/features/intake_booking/presentation/pages/intake_sessions_page.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/block_view.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/composer_bar.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/intake_bubbles.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/presentation/pages/address_map_page.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/utils.dart';

/// The conversational booking chat. Consent is gated locally (reusing the AI
/// consent modal), then the cubit starts the session and streams blocks.
class IntakeChatPage extends StatefulWidget {
  const IntakeChatPage({super.key});

  @override
  State<IntakeChatPage> createState() => _IntakeChatPageState();
}

class _IntakeChatPageState extends State<IntakeChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkConsentAndStart());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkConsentAndStart() async {
    final alreadyAccepted = await Utils.hasAcceptedAiConsent();
    if (!mounted) return;
    if (!alreadyAccepted) {
      final accepted = await AiDataConsentModal.show(context);
      if (!mounted) return;
      if (!accepted) {
        Navigator.of(context).pop();
        return;
      }
    }
    if (!mounted) return;
    context.read<IntakeCubit>().start();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickLocation(int blockId) async {
    final result = await Navigator.of(context).push<Address>(
      MaterialPageRoute(builder: (_) => const AddressMapPage(pickOnly: true)),
    );
    if (result == null || !mounted) return;
    context.read<IntakeCubit>().sendLocation(
          blockId: blockId,
          lat: result.latitude,
          lng: result.longitude,
          address: result.formattedAddress ??
              result.shortFormattedAddress ??
              result.name ??
              '',
        );
  }

  /// Session history: pop with the tapped session — active one is this chat,
  /// a previous one opens read-only.
  Future<void> _openHistory() async {
    final currentSessionId = switch (context.read<IntakeCubit>().state) {
      IntakeActive(:final sessionId) => sessionId,
      _ => null,
    };
    final picked = await Navigator.of(context).push<IntakeSessionSummary>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => IntakeSessionsCubit(repository: sl())..load(),
          child: const IntakeSessionsPage(),
        ),
      ),
    );
    if (picked == null || !mounted) return;
    if (picked.active || picked.id == currentSessionId) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IntakeSessionViewerPage(sessionId: picked.id),
      ),
    );
  }

  Future<void> _startNewSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start a new conversation?'),
        content: const Text(
            'Your current conversation will be kept in history as read-only.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Start new', style: TextStyle(color: Const.aqua)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    context.read<IntakeCubit>().start(fresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntakeCubit, IntakeState>(
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: _IntakeChatHeader(
              connected: state is IntakeActive && state.connected,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history, color: Const.aqua),
                tooltip: 'Conversation history',
                onPressed: state is IntakeActive ? _openHistory : null,
              ),
              IconButton(
                icon: const Icon(Icons.add_comment_outlined, color: Const.aqua),
                tooltip: 'New conversation',
                onPressed: state is IntakeActive ? _startNewSession : null,
              ),
            ],
            bottom: (state is IntakeActive && !state.connected)
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(2),
                    child: LinearProgressIndicator(
                        minHeight: 2, color: Const.aqua),
                  )
                : null,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, IntakeState state) {
    return switch (state) {
      IntakeInitial() ||
      IntakeConnecting() =>
        const Center(child: CircularProgressIndicator(color: Const.aqua)),
      IntakeFatal(:final message) => _fatal(context, message),
      IntakeActive() => _active(context, state),
    };
  }

  Widget _active(BuildContext context, IntakeActive state) {
    return Column(
      children: [
        const _PrivacyNotice(),
        Expanded(
          child: state.blocks.isEmpty && !state.awaitingReply
              ? _EmptyChatWelcome(
                  onPrompt: (text) =>
                      context.read<IntakeCubit>().sendText(text),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount:
                      state.blocks.length + (state.awaitingReply ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.blocks.length) {
                      return const ThinkingIndicator();
                    }
                    final block = state.blocks[index];
                    return BlockView(
                      block: block,
                      isLast: index == state.blocks.length - 1,
                      chosenReplyId: state.resolvedChoices[block.id],
                      onReply: (replyId) => context
                          .read<IntakeCubit>()
                          .respond(blockId: block.id, replyId: replyId),
                      onPickLocation: () => _pickLocation(block.id),
                    );
                  },
                ),
        ),
        if (state.actionError != null)
          Container(
            width: double.infinity,
            color: Colors.red.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              state.actionError!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ComposerBar(
          composer: state.composer,
          isSending: state.awaitingReply,
          onSend: (text) => context.read<IntakeCubit>().sendText(text),
        ),
      ],
    );
  }

  Widget _fatal(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          TextButton(
            onPressed: () => context.read<IntakeCubit>().start(),
            child: const Text('Retry',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

/// Friendly empty state: what the agent can do, plus one-tap starter prompts
/// covering both booking and health Q&A.
class _EmptyChatWelcome extends StatelessWidget {
  final ValueChanged<String> onPrompt;
  const _EmptyChatWelcome({required this.onPrompt});

  static const _suggestions = [
    'I need a home nurse visit',
    'What services and prices do you offer?',
    'I have a health question',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/ic_doctor_ai.png', width: 64, height: 64),
            const SizedBox(height: 16),
            const Text(
              'Hi! How can I help you today?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF232F55),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'I can book home healthcare visits, help you prepare for '
              'appointments, and answer your health questions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ..._suggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () => onPrompt(suggestion),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Const.aqua.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(color: Const.aqua, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A privacy label matching the chatbot's, with an info `(!)` on the right that
/// reveals the detailed privacy statement on tap or hover.
class _PrivacyNotice extends StatelessWidget {
  const _PrivacyNotice();

  static const _detail =
      'Your conversation is private. Health details are encrypted and handled '
      'in line with our Privacy Policy (PDPA / HIPAA aligned). You can review or '
      'delete this chat anytime.';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/ic_lock.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text(
                '(HIPAA Privacy)',
                style: TextStyle(color: Color(0xFF5782F1), fontSize: 12),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: _detail,
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 8),
              preferBelow: true,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF232F55),
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                  color: Colors.white, fontSize: 12, height: 1.35),
              child: const Icon(Icons.info_outline,
                  size: 18, color: Color(0xFF5782F1)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header for the intake chat: icon + agent name + live connection status.
class _IntakeChatHeader extends StatelessWidget {
  final bool connected;
  const _IntakeChatHeader({required this.connected});

  @override
  Widget build(BuildContext context) {
    final statusColor = connected ? Colors.green : Colors.orange;
    return Row(
      children: [
        Image.asset('assets/icons/ic_doctor_ai.png', width: 34, height: 34),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'M2Health AI Agent',
              style: TextStyle(
                color: Const.aqua,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Icon(Icons.circle, color: statusColor, size: 6),
                const SizedBox(width: 4),
                Text(
                  connected ? 'Online' : 'Connecting…',
                  style: TextStyle(color: statusColor, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
