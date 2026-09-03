import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/booking_flow_progress.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_avatar.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:table_calendar/table_calendar.dart';

class PreferredDateTimePage extends StatefulWidget {
  const PreferredDateTimePage({super.key, required this.args});

  final GuidedBookingStepArgs args;

  @override
  State<PreferredDateTimePage> createState() => _PreferredDateTimePageState();
}

class _PreferredDateTimePageState extends State<PreferredDateTimePage> {
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    if (widget.args.cubit.state.availabilityStatus ==
        BookingLoadStatus.initial) {
      widget.args.cubit.loadAvailability();
    }
  }

  DateTime _resolveDay(List<BookingDay> days) {
    final chosen = _selectedDay ?? widget.args.cubit.state.draft.preferredAt;
    if (chosen != null) {
      for (final day in days) {
        if (isSameDay(day.date, chosen)) return day.date;
      }
    }
    for (final day in days) {
      if (day.hasAvailability) return day.date;
    }
    return days.first.date;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocBuilder<GuidedBookingCubit, GuidedBookingState>(
      builder: (context, state) {
        final preferredAt = state.draft.preferredAt;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              state.catalogue?.title ?? t.namespace_title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: Column(
            children: [
              BookingFlowProgress(
                state: state,
                step: GuidedBookingStep.schedule,
              ),
              Expanded(child: _body(context, state, cubit)),
            ],
          ),
          bottomNavigationBar: StickyBottomCta(
            label: t.cta.kContinue,
            footer: preferredAt == null
                ? null
                : Text(
                    t.schedule.chosen(
                      day: DateFormat('EEE d MMM').format(preferredAt),
                      time: DateFormat('HH:mm').format(preferredAt),
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            onPressed: state.draft.hasPreferredTime
                ? () {
                    if (widget.args.returnToReview) {
                      context.pop();
                    } else {
                      context.push(
                        GuidedBookingRoutes.review,
                        extra: GuidedBookingStepArgs(cubit),
                      );
                    }
                  }
                : null,
          ),
        );
      },
    );
  }

  Widget _body(
    BuildContext context,
    GuidedBookingState state,
    GuidedBookingCubit cubit,
  ) {
    final t = context.t.guidedBooking.schedule;

    switch (state.availabilityStatus) {
      case BookingLoadStatus.initial:
      case BookingLoadStatus.loading:
        return BookingLoadingState(message: t.loading);
      case BookingLoadStatus.failure:
        return BookingErrorState(
          message: state.errorMessage ?? t.error,
          onRetry: cubit.loadAvailability,
        );
      case BookingLoadStatus.ready:
        final days = state.availability;
        if (days.isEmpty || !days.any((day) => day.hasAvailability)) {
          return BookingEmptyState(
            message: t.no_days,
            icon: Icons.event_busy_outlined,
          );
        }

        final selectedDay = _resolveDay(days);
        final slots =
            (state.dayFor(selectedDay)?.slots ?? const <BookingSlot>[])
                .where((slot) => slot.isAvailable)
                .toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            BookingStepHeader(
              title: t.title,
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
            ),
            if (state.selectedProfessional != null)
              _ProfessionalSummary(
                professional: state.selectedProfessional!,
                location: state.selectedAddress?.formattedAddress ??
                    state.selectedAddress?.label,
              ),
            const SizedBox(height: 24),
            _SectionTitle(t.select_date),
            const SizedBox(height: 12),
            _AvailabilityCalendar(
              days: days,
              selectedDay: selectedDay,
              isEnabled: (day) => state.dayFor(day)?.hasAvailability ?? false,
              onDaySelected: (day) => setState(() => _selectedDay = day),
            ),
            const SizedBox(height: 24),
            _SectionTitle(t.select_hour),
            const SizedBox(height: 12),
            if (slots.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Text(
                  t.empty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              )
            else
              _SlotGrid(
                slots: slots,
                selectedAt: state.draft.preferredAt,
                onSelected: cubit.selectSlot,
              ),
          ],
        );
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _ProfessionalSummary extends StatelessWidget {
  const _ProfessionalSummary({required this.professional, this.location});

  final BookingProfessional professional;
  final String? location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Const.borderSubtle),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ProfessionalAvatar(professional: professional, radius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  professional.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (professional.jobTitle != null)
                  Text(
                    professional.jobTitle!,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                if (location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Const.tosca,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityCalendar extends StatelessWidget {
  const _AvailabilityCalendar({
    required this.days,
    required this.selectedDay,
    required this.isEnabled,
    required this.onDaySelected,
  });

  final List<BookingDay> days;
  final DateTime selectedDay;
  final bool Function(DateTime day) isEnabled;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final dates = days.map((day) => day.date).toList()..sort();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Const.aqua.withValues(alpha: 0.06),
        border: Border.all(color: Const.borderSubtle),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar<void>(
        availableGestures: AvailableGestures.none,
        firstDay: dates.first,
        lastDay: dates.last,
        focusedDay: selectedDay,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        enabledDayPredicate: isEnabled,
        onDaySelected: (day, _) => onDaySelected(day),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Const.primaryTextColor,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.grey),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.grey),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Const.aqua,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(color: Const.aqua.withValues(alpha: 0.5)),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          defaultTextStyle: const TextStyle(color: Colors.black),
          weekendTextStyle: const TextStyle(color: Colors.black),
          disabledTextStyle: const TextStyle(color: Colors.black26),
          outsideDaysVisible: false,
        ),
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.slots,
    required this.selectedAt,
    required this.onSelected,
  });

  final List<BookingSlot> slots;
  final DateTime? selectedAt;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 105 / 42,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final selected = slot.startTime == selectedAt;

        return GestureDetector(
          onTap: () => onSelected(slot.startTime),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      colors: [Const.tosca.withValues(alpha: 0.5), Const.tosca],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              border: Border.all(color: Const.tosca),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                DateFormat('HH:mm').format(slot.startTime),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Const.tosca,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
