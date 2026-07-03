import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/presentation/widgets/ai_data_consent.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_cubit.dart';
import 'package:m2health/features/intake_booking/presentation/bloc/intake_state.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/block_view.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/composer_bar.dart';
import 'package:m2health/features/intake_booking/presentation/widgets/intake_bubbles.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkConsentAndStart());
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntakeCubit, IntakeState>(
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Book with AI'),
            bottom: (state is IntakeActive && !state.connected)
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(2),
                    child: LinearProgressIndicator(minHeight: 2, color: Const.aqua),
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
                  itemCount: state.blocks.length + (state.awaitingReply ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.blocks.length) return const ThinkingIndicator();
                    return BlockView(block: state.blocks[index]);
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
            child: const Text('Retry', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
