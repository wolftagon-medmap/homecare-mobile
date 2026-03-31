import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';

class AppointmentCancellationSelection {
  final String cancellationReason;
  final String? otherReason;

  const AppointmentCancellationSelection({
    required this.cancellationReason,
    this.otherReason,
  });
}

class CancelAppoinmentDialog extends StatefulWidget {
  final ValueChanged<AppointmentCancellationSelection> onPressYes;
  final VoidCallback? onPressNo;
  final String? title;
  final String? subtitle;

  const CancelAppoinmentDialog(
      {super.key,
      required this.onPressYes,
      this.onPressNo,
      this.title,
      this.subtitle});

  @override
  State<CancelAppoinmentDialog> createState() => _CancelAppoinmentDialogState();
}

class _CancelAppoinmentDialogState extends State<CancelAppoinmentDialog> {
  static const List<String> _reasons = [
    'Scheduling conflict',
    'Location distance is too far',
    'Patient no longer requires appointment',
    'Patient requires immediate medical attention',
    'Other',
  ];

  String _selectedReason = _reasons.first;
  final TextEditingController _otherReasonController = TextEditingController();

  bool get _isOtherReason => _selectedReason == 'Other';

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final otherReason = _otherReasonController.text.trim();
    if (_isOtherReason && otherReason.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please enter at least 3 characters for Other reason.')),
      );
      return;
    }

    Navigator.of(context).pop();
    widget.onPressYes(
      AppointmentCancellationSelection(
        cancellationReason: _selectedReason,
        otherReason: _isOtherReason ? otherReason : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogMaxWidth = MediaQuery.of(context).size.width * 0.94;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      contentPadding: const EdgeInsets.all(16.0),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogMaxWidth),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Icon(Icons.warning_amber_rounded,
                  size: 50, color: Colors.red.shade600),
              const SizedBox(height: 16),
              Text(
                widget.title ?? context.l10n.appointment_cancel_dialog_content,
                style: const TextStyle(
                    color: Const.aqua,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.subtitle ??
                    context.l10n.appointment_cancel_dialog_subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Cancellation reason',
                  border: OutlineInputBorder(),
                ),
                items: _reasons
                    .map(
                      (reason) => DropdownMenuItem(
                        value: reason,
                        child: Text(
                          reason,
                          softWrap: true,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedReason = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedReason,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (_isOtherReason) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _otherReasonController,
                  maxLength: 255,
                  decoration: const InputDecoration(
                    labelText: 'Other reason',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (widget.onPressNo != null) widget.onPressNo!();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.aqua,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(context.l10n.common_no),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(context.l10n.common_yes),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
