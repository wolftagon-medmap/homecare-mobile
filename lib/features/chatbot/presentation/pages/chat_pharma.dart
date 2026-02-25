// chatbot/presentation/pages/chat_pharma_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/bloc/pharmacy_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/pharmacy_appointment_flow_page.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_state.dart';
import 'package:m2health/features/chatbot/presentation/widgets/chat_input_factory.dart';
import 'package:m2health/features/chatbot/presentation/widgets/event_bubble_factory.dart';
import 'package:m2health/service_locator.dart';

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
      context.read<ChatCubit>().initialize();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const _ChatPharmaHeader()),
          body: Column(
            children: [
              const _HIPAAPrivacyLabel(),
              Expanded(
                child: state.maybeMap(
                  loading: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e) => Center(child: Text(e.message)),
                  loaded: (s) => ListView.builder(
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
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              const _PharmacHelpRequestButton(),
              // Handles the bottom bar logic: text, forms, or selection
              ChatInputFactory(
                config: state.maybeMap(
                    loaded: (s) => s.inputConfig, orElse: () => null),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => PharmacyAppointmentFlowBloc(
                      createPharmacyAppointment: sl(),
                    ),
                    child: const PharmacyAppointmentFlowPage(),
                  ),
                ),
              );
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
