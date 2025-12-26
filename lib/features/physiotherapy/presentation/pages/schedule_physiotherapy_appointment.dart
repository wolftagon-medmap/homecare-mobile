import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/widgets/time_slot_grid_view.dart';
import 'package:m2health/features/physiotherapy/presentation/bloc/schedule_physiotherapy_appointment_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePhysiotherapyAppointmentPageData {
  final String title;
  final ProfessionalEntity professional;
  final void Function({required TimeSlot timeSlot, required int duration})
      onSubmit;
  final bool isSubmitting;

  SchedulePhysiotherapyAppointmentPageData({
    required this.professional,
    required this.title,
    required this.onSubmit,
    this.isSubmitting = false,
  });
}

class SchedulePhysiotherapyAppointmentPage extends StatefulWidget {
  final SchedulePhysiotherapyAppointmentPageData data;

  const SchedulePhysiotherapyAppointmentPage({
    super.key,
    required this.data,
  });

  @override
  State<SchedulePhysiotherapyAppointmentPage> createState() =>
      _SchedulePhysiotherapyAppointmentPageState();
}

class _SchedulePhysiotherapyAppointmentPageState
    extends State<SchedulePhysiotherapyAppointmentPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchSlots(DateTime.now());
  }

  void _submit() {
    final selectedSlot = context
        .read<SchedulePhysiotherapyAppointmentCubit>()
        .state
        .selectedSlot;

    if (selectedSlot == null) {
      log('No time slot selected on submit',
          name: 'SchedulePhysiotherapyAppointmentView');
      return;
    }

    final duration =
        context.read<SchedulePhysiotherapyAppointmentCubit>().state.duration;

    if (duration == null) {
      log('No duration selected on submit',
          name: 'SchedulePhysiotherapyAppointmentView');
      return;
    }

    widget.data.onSubmit(
      timeSlot: selectedSlot,
      duration: duration,
    );
  }

  void _fetchSlots(DateTime date) async {
    await context.read<SchedulePhysiotherapyAppointmentCubit>().fetchSlots(
          providerId: widget.data.professional.id,
          date: date,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.physiotherapy_scheduling_duration,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SchedulePhysiotherapyAppointmentCubit,
                SchedulePhysiotherapyAppointmentState>(
              builder: (context, state) {
                return Row(
                  spacing: 16,
                  children: [
                    Expanded(
                        child: _buildDurationChip(context, 45, state.duration)),
                    Expanded(
                        child: _buildDurationChip(context, 60, state.duration)),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.physiotherapy_scheduling_select_date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            _buildCalendar(),
            const SizedBox(height: 24),
            Text(
              context.l10n.physiotherapy_scheduling_select_hour,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(
                minHeight: 300, // Set the minimum height to 400px
              ),
              child: BlocBuilder<SchedulePhysiotherapyAppointmentCubit,
                  SchedulePhysiotherapyAppointmentState>(
                builder: (context, state) {
                  if (state.status == ActionStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ActionStatus.error) {
                    return Center(
                        child: Text(state.errorMessage ??
                            context.l10n.physiotherapy_scheduling_failed_load_slots));
                  }
                  if (state.slots.isEmpty) {
                    return Center(
                        child: Text(context.l10n.physiotherapy_scheduling_no_slots));
                  }

                  return TimeSlotGridView(
                    timeSlots: state.slots,
                    selectedSlot: state.selectedSlot,
                    onSlotSelected: (slot) {
                      context
                          .read<SchedulePhysiotherapyAppointmentCubit>()
                          .selectSlot(slot);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildDurationChip(
      BuildContext context, int duration, int? selectedDuration) {
    final isSelected = duration == selectedDuration;
    return ChoiceChip(
      label: SizedBox(
        width: double.infinity,
        child: Center(
            child: Text(context.l10n.physiotherapy_scheduling_minutes(duration))),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context
              .read<SchedulePhysiotherapyAppointmentCubit>()
              .selectDuration(duration);
        }
      },
      selectedColor: const Color(0xFF35C5CF),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
      showCheckmark: false,
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        color: const Color.fromRGBO(154, 225, 255, 0.1),
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          availableGestures: AvailableGestures.none,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            log('Selected Day: $selectedDay', name: '_buildCalendar');
            _fetchSlots(selectedDay);
          },
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Colors.grey,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: Const.aqua,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              border: Border.all(color: Const.aqua.withValues(alpha: 0.5)),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
            selectedTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            markerDecoration: const BoxDecoration(
              color: Const.aqua,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: const TextStyle(color: Colors.black),
            defaultTextStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: BlocBuilder<SchedulePhysiotherapyAppointmentCubit,
          SchedulePhysiotherapyAppointmentState>(
        builder: (context, state) {
          final isButtonDisabled = state.selectedSlot == null ||
              state.duration == null ||
              widget.data.isSubmitting;
          return ElevatedButton(
            onPressed: isButtonDisabled ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF35C5CF),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: widget.data.isSubmitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(context.l10n.physiotherapy_scheduling_submitting,
                          style: const TextStyle(color: Colors.white)),
                    ],
                  )
                : Text(
                    context.l10n.physiotherapy_scheduling_submit,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
          );
        },
      ),
    );
  }
}
