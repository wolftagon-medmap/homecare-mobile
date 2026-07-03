import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/intake_booking/domain/entities/composer_state.dart';

/// The input bar. Its behaviour is dictated entirely by [ComposerState] from the
/// backend — when disabled it shows a notice instead of a text field.
class ComposerBar extends StatefulWidget {
  final ComposerState composer;
  final bool isSending;
  final ValueChanged<String> onSend;

  const ComposerBar({
    super.key,
    required this.composer,
    required this.isSending,
    required this.onSend,
  });

  @override
  State<ComposerBar> createState() => _ComposerBarState();
}

class _ComposerBarState extends State<ComposerBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.composer.enabled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        color: Colors.white,
        child: Text(
          widget.composer.notice ?? 'This conversation is closed.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF8A96BC), fontSize: 13),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: widget.composer.placeholder ?? 'Type your message…',
                hintStyle:
                    const TextStyle(color: Color(0xFF8A96BC), fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF1F3F8),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Const.aqua,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.isSending ? null : _submit,
              child: SizedBox(
                width: 44,
                height: 44,
                child: widget.isSending
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
