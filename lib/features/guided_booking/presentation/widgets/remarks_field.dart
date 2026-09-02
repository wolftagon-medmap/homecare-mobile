import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';

class RemarksField extends StatefulWidget {
  final String label;
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const RemarksField({
    super.key,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<RemarksField> createState() => _RemarksFieldState();
}

class _RemarksFieldState extends State<RemarksField> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          maxLength: GuidedBookingDraft.remarksLimit,
          maxLines: 4,
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
        ),
      ],
    );
  }
}
