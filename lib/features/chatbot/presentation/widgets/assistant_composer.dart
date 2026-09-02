import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';

class AssistantComposer extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onSend;

  const AssistantComposer({
    super.key,
    required this.hint,
    required this.onSend,
  });

  @override
  State<AssistantComposer> createState() => _AssistantComposerState();
}

class _AssistantComposerState extends State<AssistantComposer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: AssistantPalette.canvas,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AssistantPalette.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AssistantPalette.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  style: const TextStyle(
                    color: AssistantPalette.navy,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      color: AssistantPalette.muted,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: context.t.chatbot.send,
              child: Material(
                color: AssistantPalette.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _send,
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
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
