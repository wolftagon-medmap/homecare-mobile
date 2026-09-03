import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

/// The message box. [actions] carries whatever the role may raise from here —
/// the professional gets "Suggest another time", the patient gets nothing extra.
/// They live behind the `+` rather than in a row above the field, so the bottom
/// of the screen stays one line however many of them there are.
class ChatComposer extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool sending;
  final bool enabled;
  final String hint;
  final List<ComposerAction> actions;

  /// Prefilled by a suggested opener, so the sender still edits before sending.
  final String? draft;

  const ChatComposer({
    super.key,
    required this.onSend,
    this.sending = false,
    this.enabled = true,
    this.hint = 'Write a message',
    this.actions = const [],
    this.draft,
  });

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void didUpdateWidget(ChatComposer old) {
    super.didUpdateWidget(old);
    final draft = widget.draft;
    if (draft != null && draft != old.draft) {
      _controller.text = draft;
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openActions() async {
    final action = await showModalBottomSheet<ComposerAction>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ActionSheet(actions: widget.actions),
    );
    action?.onTap?.call();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.sending) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const _ClosedNotice();

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: 8 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Const.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.actions.isNotEmpty) ...[
            _ActionsButton(onTap: _openActions),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              // Return breaks the line. A message is sent by the button,
              // because a chat message is often more than one sentence and half
              // of one sent by accident cannot be taken back.
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                filled: true,
                fillColor: Const.surfaceMuted,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _SendButton(
            enabled: _hasText && !widget.sending,
            sending: widget.sending,
            onTap: _send,
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final bool sending;
  final VoidCallback onTap;

  const _SendButton({
    required this.enabled,
    required this.sending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? Const.aqua : Colors.grey[300],
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 44,
          height: 44,
          child: sending
              ? const Padding(
                  padding: EdgeInsets.all(13),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _ClosedNotice extends StatelessWidget {
  const _ClosedNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 14,
        bottom: 14 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Const.surfaceMuted,
        border: Border(top: BorderSide(color: Const.borderSubtle)),
      ),
      child: Text(
        'This conversation is closed.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
    );
  }
}

/// A composer action — what this role may raise from the conversation. Data,
/// not a widget: the composer decides how to draw it, which is what let the row
/// of pills become one `+`.
class ComposerAction {
  final IconData icon;
  final String label;
  final String? description;
  final VoidCallback? onTap;

  const ComposerAction({
    required this.icon,
    required this.label,
    this.description,
    this.onTap,
  });
}

class _ActionsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ActionsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Const.surfaceMuted,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.add_rounded, color: Const.aqua, size: 22),
        ),
      ),
    );
  }
}

class _ActionSheet extends StatelessWidget {
  final List<ComposerAction> actions;

  const _ActionSheet({required this.actions});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          for (final action in actions)
            ListTile(
              leading: Icon(action.icon, color: Const.aqua, size: 22),
              title: Text(action.label, style: ProText.bodyStrong),
              subtitle: action.description == null
                  ? null
                  : Text(action.description!, style: ProText.hint),
              enabled: action.onTap != null,
              onTap: () => Navigator.of(context).pop(action),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
