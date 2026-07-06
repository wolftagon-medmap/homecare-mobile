import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

typedef RejectSubmitCallback = void Function(String category, String? note);

/// Captures a structured rejection reason (preset category + optional note),
/// matching the backend `REJECTION_CATEGORIES`.
class RejectProfessionalDialog extends StatefulWidget {
  final RejectSubmitCallback onSubmit;
  const RejectProfessionalDialog({super.key, required this.onSubmit});

  @override
  State<RejectProfessionalDialog> createState() =>
      _RejectProfessionalDialogState();
}

class _RejectProfessionalDialogState extends State<RejectProfessionalDialog> {
  static const Map<String, String> _categories = {
    'certificate_issue': 'Certificate missing, unclear, or expired',
    'license_invalid': 'License / registration could not be verified',
    'info_incomplete': 'Profile information incomplete or inconsistent',
    'other': 'Other (add a note)',
  };

  String? _category;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reason')),
      );
      return;
    }
    final note = _noteController.text.trim();
    Navigator.pop(context);
    widget.onSubmit(_category!, note.isEmpty ? null : note);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reject submission'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reason', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            ..._categories.entries.map((e) {
              final selected = _category == e.key;
              return InkWell(
                onTap: () => setState(() => _category = e.key),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 20,
                        color: selected ? Const.aqua : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(e.value,
                            style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'Explain what needs to change',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
          child: const Text('Reject'),
        ),
      ],
    );
  }
}
