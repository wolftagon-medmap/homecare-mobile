import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_cubit.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_state.dart';

/// Lets a provider apply one time range to several weekday at once
/// (e.g. 09:00–17:00 for Monday–Friday), instead of adding each day separately.
class BatchAvailabilityDialog extends StatefulWidget {
  const BatchAvailabilityDialog({super.key});

  @override
  State<BatchAvailabilityDialog> createState() =>
      _BatchAvailabilityDialogState();
}

class _BatchAvailabilityDialogState extends State<BatchAvailabilityDialog> {
  // Day-of-week indices match the backend: 0 = Sunday ... 6 = Saturday.
  static const List<int> _weekdays = [1, 2, 3, 4, 5];
  static const List<int> _weekend = [6, 0];
  static const List<int> _displayOrder = [1, 2, 3, 4, 5, 6, 0];

  final Set<int> _selectedDays = {};
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String _dayLabel(BuildContext context, int index) {
    switch (index) {
      case 0:
        return context.l10n.day_sunday;
      case 1:
        return context.l10n.day_monday;
      case 2:
        return context.l10n.day_tuesday;
      case 3:
        return context.l10n.day_wednesday;
      case 4:
        return context.l10n.day_thursday;
      case 5:
        return context.l10n.day_friday;
      case 6:
        return context.l10n.day_saturday;
      default:
        return '';
    }
  }

  String _format(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  int _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void _applyPreset(List<int> days) {
    setState(() {
      _selectedDays
        ..clear()
        ..addAll(days);
    });
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
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

  /// Returns day labels that already have a block overlapping the new range.
  List<String> _overlappingDays(ScheduleState state) {
    final newStart = _startTime!.hour * 60 + _startTime!.minute;
    final newEnd = _endTime!.hour * 60 + _endTime!.minute;

    return _selectedDays
        .where((day) => state.availabilities.any((a) {
              if (a.dayOfWeek != day) return false;
              final existStart = _toMinutes(a.startTime);
              final existEnd = _toMinutes(a.endTime);
              return newStart < existEnd && existStart < newEnd;
            }))
        .map((day) => _dayLabel(context, day))
        .toList();
  }

  void _onSave() {
    if (_selectedDays.isEmpty) {
      _snack('Please select at least one day');
      return;
    }
    if (_startTime == null || _endTime == null) {
      _snack(context.l10n.schedule_please_select_time);
      return;
    }
    final start = _startTime!.hour * 60 + _startTime!.minute;
    final end = _endTime!.hour * 60 + _endTime!.minute;
    if (start >= end) {
      _snack(context.l10n.schedule_end_time_error);
      return;
    }

    final overlaps = _overlappingDays(context.read<ScheduleCubit>().state);
    if (overlaps.isNotEmpty) {
      _snack('Overlaps existing hours on: ${overlaps.join(', ')}');
      return;
    }

    final days = _selectedDays.toList()..sort();
    context.read<ScheduleCubit>().saveWeeklyRulesBulk(
          days: days,
          startTime: _format(_startTime!),
          endTime: _format(_endTime!),
        );
    Navigator.pop(context);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add hours to multiple days'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Days', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _PresetChip(
                    label: 'Weekdays', onTap: () => _applyPreset(_weekdays)),
                _PresetChip(
                    label: 'Weekend', onTap: () => _applyPreset(_weekend)),
                _PresetChip(
                    label: 'Every day',
                    onTap: () => _applyPreset(_displayOrder)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _displayOrder.map((day) {
                final selected = _selectedDays.contains(day);
                return FilterChip(
                  label: Text(_dayLabel(context, day)),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: Const.aqua.withValues(alpha: 0.2),
                  checkmarkColor: Const.aqua,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Hours', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TimePickerChip(
                  label: context.l10n.schedule_start,
                  time: _startTime,
                  onTap: () => _selectTime(true),
                ),
                const Text('-'),
                _TimePickerChip(
                  label: context.l10n.schedule_end,
                  time: _endTime,
                  onTap: () => _selectTime(false),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(backgroundColor: Const.aqua),
          child: Text(context.l10n.common_save,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      side: const BorderSide(color: Const.aqua),
      labelStyle: const TextStyle(color: Const.aqua, fontSize: 12),
      backgroundColor: Colors.white,
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
      child: Chip(
        label: Text(time?.format(context) ?? label),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
