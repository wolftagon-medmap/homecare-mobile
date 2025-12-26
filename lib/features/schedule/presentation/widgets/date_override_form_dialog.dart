import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_cubit.dart';

class DateOverrideFormDialog extends StatefulWidget {
  final DateTime selectedDate;

  const DateOverrideFormDialog({super.key, required this.selectedDate});

  @override
  State<DateOverrideFormDialog> createState() => _DateOverrideFormDialogState();
}

class _DateOverrideFormDialogState extends State<DateOverrideFormDialog> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ??
          const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _onSave() {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.schedule_please_select_time)),
      );
      return;
    }

    if (_startTime!.hour > _endTime!.hour ||
        (_startTime!.hour == _endTime!.hour &&
            _startTime!.minute >= _endTime!.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.schedule_end_time_error)),
      );
      return;
    }

    // Combine date and time
    final startDateTime = widget.selectedDate.copyWith(
      hour: _startTime!.hour,
      minute: _startTime!.minute,
    );
    final endDateTime = widget.selectedDate.copyWith(
      hour: _endTime!.hour,
      minute: _endTime!.minute,
    );

    // final tzStartDateTime = TZDateTime.from(startDateTime, tz.local);
    // final tzEndDateTime = TZDateTime.from(endDateTime, tz.local);

    // Call Cubit to Add Slot
    context
        .read<ScheduleCubit>()
        .addSlotToDate(widget.selectedDate, startDateTime, endDateTime);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(context.l10n.schedule_add_time_slot_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('MMMM d, yyyy', Localizations.localeOf(context).toString())
                .format(widget.selectedDate),
            style: TextStyle(color: Colors.grey.shade900),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TimePickerChip(
                label: context.l10n.schedule_start,
                time: _startTime,
                onTap: () => _selectTime(context, true),
              ),
              const Text('-'),
              _TimePickerChip(
                label: context.l10n.schedule_end,
                time: _endTime,
                onTap: () => _selectTime(context, false),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(backgroundColor: Const.aqua),
          child: Text(context.l10n.schedule_add_btn,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _TimePickerChip extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _TimePickerChip({required this.label, this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time?.format(context) ?? label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
