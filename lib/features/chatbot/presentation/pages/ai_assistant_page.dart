import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_sessions_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';
import 'package:m2health/features/chatbot/presentation/pages/assistant_session_viewer_page.dart';
import 'package:m2health/features/chatbot/presentation/pages/assistant_sessions_page.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_block_view.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubbles.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_composer.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_hero.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_privacy_label.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_safety_note.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/features/chatbot_legacy/presentation/widgets/ai_data_consent.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/utils.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _consentAndStart());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _consentAndStart() async {
    final accepted = await Utils.hasAcceptedAiConsent();
    if (!mounted) return;
    if (!accepted) {
      final granted = await AiDataConsentModal.show(context);
      if (!mounted) return;
      if (!granted) {
        Navigator.of(context).maybePop();
        return;
      }
    }
    if (!mounted) return;
    context.read<AssistantCubit>().start();
  }

  void _onStateChange(BuildContext context, AssistantState state) {
    if (state is! AssistantReady) return;

    final route = state.pendingRoute;
    if (route != null) {
      context.read<AssistantCubit>().routeConsumed();
      context.push(route);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        state.blocks.length <= 1
            ? 0
            : _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _openHistory() async {
    final cubit = context.read<AssistantCubit>();
    final picked = await Navigator.of(context).push<AssistantSession>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AssistantSessionsCubit(
            repository: sl(),
            currentSessionId: cubit.sessionId,
          )..load(),
          child: const AssistantSessionsPage(),
        ),
      ),
    );
    if (picked == null || !mounted) return;
    if (picked.id == cubit.sessionId) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<AssistantCubit>(
          create: (_) => sl<AssistantCubit>(),
          child: AssistantSessionViewerPage(session: picked),
        ),
      ),
    );
  }

  Future<void> _startNewConversation() async {
    final t = context.t.chatbot;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.newConversationTitle),
        content: Text(t.newConversationBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              t.startNew,
              style: const TextStyle(color: AssistantPalette.primary),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    context.read<AssistantCubit>().newConversation();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    return Scaffold(
      backgroundColor: AssistantPalette.canvas,
      appBar: AppBar(
        backgroundColor: AssistantPalette.surface,
        surfaceTintColor: AssistantPalette.surface,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: AssistantPalette.navy,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            const AssistantAvatar(size: 28),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                t.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AssistantPalette.navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<AssistantCubit, AssistantState>(
            builder: (context, state) {
              final ready = state is AssistantReady;
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.history),
                    color: AssistantPalette.navy,
                    tooltip: t.history,
                    onPressed: ready ? _openHistory : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    color: AssistantPalette.navy,
                    tooltip: t.newConversation,
                    onPressed: ready ? _startNewConversation : null,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AssistantCubit, AssistantState>(
        listener: _onStateChange,
        builder: (context, state) => switch (state) {
          AssistantLoading() => const Center(
              child: CircularProgressIndicator(
                color: AssistantPalette.primary,
              ),
            ),
          AssistantFailed(:final message) => _Failure(message: message),
          AssistantReady() => _Conversation(
              state: state,
              scrollController: _scrollController,
            ),
        },
      ),
    );
  }
}

class _Conversation extends StatelessWidget {
  final AssistantReady state;
  final ScrollController scrollController;

  const _Conversation({required this.state, required this.scrollController});

  bool get _isWelcome =>
      state.blocks.length == 1 && state.blocks.first is TopicGridBlock;

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    final cubit = context.read<AssistantCubit>();
    final items = <Widget>[
      if (state.blocks.isNotEmpty && state.blocks.first is TopicGridBlock)
        const AssistantHero(),
      for (var i = 0; i < state.blocks.length; i++)
        AssistantBlockView(
          block: state.blocks[i],
          isLast: i == state.blocks.length - 1,
          chosenReplyId: state.resolved[state.blocks[i].id],
          selection: state.selections[state.blocks[i].id] ?? const [],
          answers: state.answers,
          onSelect: (replyId) => cubit.choose(state.blocks[i].id, replyId),
          onToggle: (optionId) => cubit.toggle(state.blocks[i].id, optionId),
          onSubmit: () => cubit.submitSelection(state.blocks[i].id),
          onAct: cubit.act,
          onOpenSuggestion: cubit.openSuggestion,
        ),
      const SizedBox(height: 8),
    ];

    return Column(
      children: [
        const AssistantPrivacyLabel(),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          ),
        ),
        const AssistantSafetyNote(),
        AssistantComposer(
          hint: _isWelcome ? t.composerHintWelcome : t.composerHint,
          onSend: cubit.sendText,
        ),
      ],
    );
  }
}

class _Failure extends StatelessWidget {
  final String message;

  const _Failure({required this.message});

  @override
  Widget build(BuildContext context) {
    final t = context.t.chatbot;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.errorTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AssistantPalette.navy,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AssistantPalette.body,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.read<AssistantCubit>().start(),
              style: FilledButton.styleFrom(
                backgroundColor: AssistantPalette.primary,
              ),
              child: Text(t.retry),
            ),
          ],
        ),
      ),
    );
  }
}
