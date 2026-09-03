import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

/// Ruled at gate 1, 2026-09-04: this sentence stays legible with no interaction.
/// The card around it was the clutter; the disclosure was not. Do not truncate
/// it, collapse it, or move it behind the privacy tooltip.
class AssistantSafetyNote extends StatelessWidget {
  const AssistantSafetyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AssistantPalette.canvas,
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: Text(
        context.t.chatbot.disclaimerBody,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AssistantPalette.muted,
          fontSize: 10.5,
          height: 1.35,
        ),
      ),
    );
  }
}
