import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class SectionTextField extends StatefulWidget {
  const SectionTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hint,
  });

  final String initialValue;
  final String? hint;
  final ValueChanged<String> onChanged;

  @override
  State<SectionTextField> createState() => _SectionTextFieldState();
}

class _SectionTextFieldState extends State<SectionTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: 5,
      minLines: 3,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
    );
  }
}
