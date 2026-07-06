import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/presentation/widgets/ai_data_consent.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_cubit.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_state.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/block_view.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/composer_bar.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/intake_bubbles.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/presentation/pages/address_map_page.dart';
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
        Expanded(
          child: state.blocks.isEmpty && !state.awaitingReply
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Tell me what care you need, and I\'ll help you book it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
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

/// Header for the intake chat: icon + agent name + live connection status.
/// Action buttons (session history / new session) are deferred to the
/// multiple-session work.
class _IntakeChatHeader extends StatelessWidget {
  final bool connected;
  const _IntakeChatHeader({required this.connected});

  @override
  Widget build(BuildContext context) {
    final statusColor = connected ? Colors.green : Colors.orange;
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Const.aqua.withValues(alpha: 0.12),
          child: const Icon(Icons.smart_toy_outlined, color: Const.aqua, size: 20),
        ),
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
