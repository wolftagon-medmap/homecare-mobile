import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class CustomValueField extends StatefulWidget {
  const CustomValueField({
    super.key,
    required this.label,
    required this.onSubmitted,
  });

  final String label;
  final ValueChanged<String> onSubmitted;

  @override
  State<CustomValueField> createState() => _CustomValueFieldState();
}

class _CustomValueFieldState extends State<CustomValueField> {
  final TextEditingController _controller = TextEditingController();
  bool _open = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onSubmitted(value);
    _controller.clear();
    setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _open = true),
          icon: const Icon(Icons.add_circle_outline, size: 18),
          label: Text(widget.label),
          style: TextButton.styleFrom(foregroundColor: Const.tosca),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: widget.label,
              isDense: true,
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Const.tosca),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _submit,
          icon: const Icon(Icons.check, color: Const.tosca),
        ),
      ],
    );
  }
}
