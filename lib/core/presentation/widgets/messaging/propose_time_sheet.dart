import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';

/// What a professional picks when suggesting another time, and what a patient
/// picks when choosing another. One sheet, two labels — the shape of the answer
/// is identical.
class ProposedSlot {
  final DateTime start;
  final DateTime end;
  final String? reason;

  const ProposedSlot({required this.start, required this.end, this.reason});
}

Future<ProposedSlot?> showProposeTimeSheet(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  DateTime? initial,
  bool askReason = true,
}) {
  return showModalBottomSheet<ProposedSlot>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ProposeTimeSheet(
      title: title,
      confirmLabel: confirmLabel,
      initial: initial,
      askReason: askReason,
    ),
  );
}

class _ProposeTimeSheet extends StatefulWidget {
  final String title;
  final String confirmLabel;
  final DateTime? initial;
  final bool askReason;

  const _ProposeTimeSheet({
    required this.title,
    required this.confirmLabel,
    required this.askReason,
    this.initial,
  });

  @override
  State<_ProposeTimeSheet> createState() => _ProposeTimeSheetState();
}

class _ProposeTimeSheetState extends State<_ProposeTimeSheet> {
  late DateTime _date;
  late TimeOfDay _time;
  final TextEditingController _reason = TextEditingController();

  /// One hour, which is what a home visit is booked as everywhere else here.
  static const _visitLength = Duration(hours: 1);

  @override
  void initState() {
    super.initState();
    final seed = widget.initial ?? DateTime.now().add(const Duration(days: 1));
    _date = DateTime(seed.year, seed.month, seed.day);
    _time = TimeOfDay(hour: seed.hour, minute: 0);
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  DateTime get _start =>
      DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Const.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _PickerRow(
            icon: Icons.calendar_today_outlined,
            label: DateFormat('EEEE, d MMMM').format(_date),
            onTap: _pickDate,
          ),
          const SizedBox(height: 10),
          _PickerRow(
            icon: Icons.access_time,
            label: '${_two(_time.hour)}:${_two(_time.minute)} - '
                '${_two(_start.add(_visitLength).hour)}:${_two(_time.minute)}',
            onTap: _pickTime,
          ),
          if (widget.askReason) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _reason,
              maxLines: 3,
              maxLength: 300,
              decoration: InputDecoration(
                labelText: 'Why? (optional)',
                hintText: 'A short reason helps them say yes.',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(
                ProposedSlot(
                  start: _start,
                  end: _start.add(_visitLength),
                  reason:
                      _reason.text.trim().isEmpty ? null : _reason.text.trim(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.confirmLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}

class _PickerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerRow(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Const.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Const.aqua),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Const.primaryTextColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}
