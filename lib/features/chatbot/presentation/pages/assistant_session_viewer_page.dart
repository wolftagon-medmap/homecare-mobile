import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_block_view.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_privacy_label.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_safety_note.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

/// A past conversation, rebuilt by replaying its recorded replies. No callbacks
/// are passed down, so every block renders inert.
class AssistantSessionViewerPage extends StatefulWidget {
  final AssistantSession session;

  const AssistantSessionViewerPage({super.key, required this.session});

  @override
  State<AssistantSessionViewerPage> createState() =>
      _AssistantSessionViewerPageState();
}

class _AssistantSessionViewerPageState
    extends State<AssistantSessionViewerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<AssistantCubit>().open(widget.session),
    );
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
        iconTheme: const IconThemeData(color: AssistantPalette.navy),
        title: Text(
          t.sessionReadOnly,
          style: const TextStyle(
            color: AssistantPalette.navy,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<AssistantCubit, AssistantState>(
        builder: (context, state) => switch (state) {
          AssistantLoading() => const Center(
              child: CircularProgressIndicator(
                color: AssistantPalette.primary,
              ),
            ),
          AssistantFailed(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AssistantPalette.body),
                ),
              ),
            ),
          AssistantReady() => Column(
              children: [
                const AssistantPrivacyLabel(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.blocks.length,
                    itemBuilder: (context, index) => AssistantBlockView(
                      block: state.blocks[index],
                      isLast: false,
                      chosenReplyId: state.resolved[state.blocks[index].id],
                      selection:
                          state.selections[state.blocks[index].id] ?? const [],
                      answers: state.answers,
                    ),
                  ),
                ),
                const AssistantSafetyNote(),
                const SizedBox(height: 12),
              ],
            ),
        },
      ),
    );
  }
}
