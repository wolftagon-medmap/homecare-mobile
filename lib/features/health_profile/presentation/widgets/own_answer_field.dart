import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';

/// A button ("Add another condition", "Other") that opens a field in place.
class OwnAnswerField extends StatefulWidget {
  const OwnAnswerField({
    super.key,
    required this.label,
    required this.enabled,
    required this.onSubmitted,
  });

  final String label;
  final bool enabled;
  final ValueChanged<String> onSubmitted;

  @override
  State<OwnAnswerField> createState() => _OwnAnswerFieldState();
}

class _OwnAnswerFieldState extends State<OwnAnswerField> {
  final _controller = TextEditingController();
  bool _open = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) widget.onSubmitted(value);
    _controller.clear();
    setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.healthProfile.section;

    if (!_open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: widget.enabled ? () => setState(() => _open = true) : null,
          style: TextButton.styleFrom(
            foregroundColor: Const.aqua,
            minimumSize: const Size(48, 48),
          ),
          icon: const Icon(Icons.add, size: 20),
          label: Text(widget.label),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            maxLength: maxOwnTextLength,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: t.own_answer_hint,
              counterText: '',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Const.aqua),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: _submit,
            style: TextButton.styleFrom(foregroundColor: Const.aqua),
            child: Text(t.add),
          ),
        ),
      ],
    );
  }
}
