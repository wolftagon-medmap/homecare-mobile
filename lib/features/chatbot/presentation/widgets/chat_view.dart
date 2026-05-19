import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_state.dart';
import 'package:m2health/features/chatbot/presentation/widgets/ai_data_consent.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_thinking_indicator.dart';
import 'package:m2health/features/chatbot/presentation/widgets/chat_input.dart';
import 'package:m2health/features/chatbot/presentation/widgets/message_bubble.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';

/// Shared chat UI for both the pharmacy and doctor AI pages.
class ChatView extends StatefulWidget {
  final String service;
  final Widget appBarTitle;

  final Widget? footer;

  const ChatView({
    super.key,
    required this.service,
    required this.appBarTitle,
    this.footer,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
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
        GoRouter.of(context).pop();
        return;
      }
    }
    context.read<ChatCubit>().startNewConversation();
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

  Future<void> _openHistory() async {
    final selectedId = await context.pushNamed<int>(
      AppRoutes.chatAiConversations,
      queryParameters: {'service': widget.service},
    );
    if (selectedId != null && mounted) {
      context.read<ChatCubit>().loadConversation(selectedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: widget.appBarTitle,
            actions: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.grey),
                tooltip: 'Conversation history',
                onPressed: _openHistory,
              ),
              IconButton(
                icon:
                    const Icon(Icons.add_comment_outlined, color: Colors.grey),
                tooltip: 'New conversation',
                onPressed: () =>
                    context.read<ChatCubit>().startNewConversation(),
              ),
            ],
          ),
          body: Column(
            children: [
              const _HIPAAPrivacyLabel(),
              Expanded(child: _buildBody(context, state)),
              if (state is ChatLoaded && state.sendError != null)
                _ErrorBanner(
                  message: state.sendError!,
                  onRetry: () => context.read<ChatCubit>().retry(),
                ),
              if (widget.footer != null) widget.footer!,
              ChatInput(
                isSending: state is ChatLoaded && state.isSending,
                onSend: (text) => context.read<ChatCubit>().sendText(text),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    switch (state) {
      case ChatInitial():
      case ChatLoading():
        return const Center(
          child: CircularProgressIndicator(color: Const.aqua),
        );
      case ChatFatalError(:final message):
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, textAlign: TextAlign.center),
              TextButton(
                onPressed: () =>
                    context.read<ChatCubit>().startNewConversation(),
                child: const Text('Start new chat',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      case ChatLoaded(:final messages, :final isSending):
        if (messages.isEmpty && !isSending) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Ask me anything about your health.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return Scrollbar(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: messages.length + (isSending ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= messages.length) {
                return const AssistantThinkingIndicator();
              }
              return MessageBubble(message: messages[index]);
            },
          ),
        );
    }
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: Colors.red, fontSize: 13)),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('RETRY',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _HIPAAPrivacyLabel extends StatelessWidget {
  const _HIPAAPrivacyLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/ic_lock.png', width: 24, height: 24),
          const SizedBox(width: 8),
          const Text(
            "(HIPAA Privacy)",
            style: TextStyle(color: Color(0xFF5782F1), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
