// chatbot/presentation/pages/chat_pharma_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_state.dart';
import 'package:m2health/features/chatbot/presentation/widgets/ai_data_consent.dart';
import 'package:m2health/features/chatbot/presentation/widgets/chat_input_factory.dart';
import 'package:m2health/features/chatbot/presentation/widgets/event_bubble_factory.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';

class ChatPharmaPage extends StatefulWidget {
  const ChatPharmaPage({super.key});

  @override
  State<ChatPharmaPage> createState() => _ChatPharmaPageState();
}

class _ChatPharmaPageState extends State<ChatPharmaPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkConsentAndInitialize();
    });
  }

  Future<void> _checkConsentAndInitialize() async {
    final alreadyAccepted = await Utils.hasAcceptedAiConsent();
    if (!mounted) return;

    if (alreadyAccepted) {
      context.read<ChatCubit>().initialize();
      return;
    }

    final accepted = await AiDataConsentModal.show(context);
    if (!mounted) return;

    if (accepted) {
      context.read<ChatCubit>().initialize();
    } else {
      GoRouter.of(context).pop();
    }
  }

  void _scrollToBottom({bool isStreaming = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (isStreaming) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Chat'),
        content: const Text(
            'Are you sure you want to reset the current conversation? All history for this session will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatCubit>().resetChat();
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        final isStreaming = state.maybeMap(
          loaded: (s) =>
              s.events.isNotEmpty && s.events.last is StreamMessageEvent,
          orElse: () => false,
        );
        _scrollToBottom(isStreaming: isStreaming);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const _ChatPharmaHeader(),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'reset') _showResetConfirmation();
                },
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'reset',
                    textStyle: TextStyle(color: Colors.red),
                    child: Text('Reset Chat'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              const _HIPAAPrivacyLabel(),
              Expanded(
                child: state.maybeMap(
                  loading: (s) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Const.aqua),
                        const SizedBox(height: 8),
                        Text(s.message ?? "Loading...",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  error: (e) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          e.message,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: context.read<ChatCubit>().retry,
                          child: const Text(
                            "Retry",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  loaded: (s) => Scrollbar(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: state.displayableEvents.length,
                      itemBuilder: (context, index) {
                        return EventBubbleFactory(
                          event: state.displayableEvents[index],
                          // Only the last event can be "active" for interaction
                          isActive: index == state.displayableEvents.length - 1,
                        );
                      },
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),

              // Error Banner
              state.maybeMap(
                loaded: (s) {
                  if (s.error != null && (s.isRetryable ?? false)) {
                    return Container(
                      color: Colors.red.shade50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(s.error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                )),
                          ),
                          TextButton(
                            onPressed: context.read<ChatCubit>().retry,
                            child: const Text(
                              "Retry",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                orElse: () => const SizedBox.shrink(),
              ),

              const _PharmacHelpRequestButton(),
              // Handles the bottom bar logic: text, forms, or selection
              ChatInputFactory(
                config: state.maybeMap(
                  loaded: (s) => s.activeInputEvent?.inputConfig,
                  orElse: () => null,
                ),
                isProcessing: state.maybeMap(
                    loaded: (s) => s.isProcessing, orElse: () => false),
                onSendText: context.read<ChatCubit>().sendText,
                // onSendFiles: (files) =>
                //     context.read<ChatCubit>().sendFiles(files),
                // onSendSelection: context.read<ChatCubit>().sendSelection,
                // onSendConfirmation: context.read<ChatCubit>().sendConfirmation,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatPharmaHeader extends StatelessWidget {
  const _ChatPharmaHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/ic_pharma_ai.png',
          width: 36,
          height: 36,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.chat_pharma_title,
              style: const TextStyle(
                color: Const.aqua,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 6,
                ),
                const SizedBox(width: 4),
                Text(
                  context.l10n.chat_pharma_online,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
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
          Image.asset(
            'assets/icons/ic_lock.png',
            width: 24,
            height: 24,
          ),
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

class _PharmacHelpRequestButton extends StatelessWidget {
  const _PharmacHelpRequestButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.grey),
          const SizedBox(width: 5),
          Text(
            context.l10n.chat_pharma_need_help,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).push(AppRoutes.pharmacyBookAppointmentFlow);
            },
            child: Text(
              context.l10n.chat_pharma_request_help,
              style: const TextStyle(
                color: Color(0xFF35C5CF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
