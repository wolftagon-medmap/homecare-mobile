import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/i18n/translations.g.dart';

class PreferredDateTimePage extends StatefulWidget {
  const PreferredDateTimePage({super.key, required this.args});

  final GuidedBookingStepArgs args;

  @override
  State<PreferredDateTimePage> createState() => _PreferredDateTimePageState();
}

class _PreferredDateTimePageState extends State<PreferredDateTimePage> {
  int _dayIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.args.cubit.state.availabilityStatus ==
        BookingLoadStatus.initial) {
      widget.args.cubit.loadAvailability();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocBuilder<GuidedBookingCubit, GuidedBookingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              t.schedule.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: _body(context, state, cubit),
          bottomNavigationBar: StickyBottomCta(
            label: t.cta.kContinue,
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
        if (days.isEmpty) {
          return BookingEmptyState(
            message: t.no_days,
            icon: Icons.event_busy_outlined,
          );
        }

        final index = _dayIndex.clamp(0, days.length - 1);
        final slots =
            days[index].slots.where((slot) => slot.isAvailable).toList();

        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            BookingStepHeader(title: t.title, subtitle: t.subtitle, step: 4),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => _DayChip(
                  date: days[i].date,
                  selected: i == index,
                  enabled: days[i].hasAvailability,
                  onTap: () => setState(() => _dayIndex = i),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (slots.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: Text(
                  t.empty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final slot in slots)
                      _SlotChip(
                        slot: slot,
                        selected: slot.startTime == state.draft.preferredAt,
                        onTap: () => cubit.selectSlot(slot.startTime),
                      ),
                  ],
                ),
              ),
          ],
        );
    }
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.date,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Const.tosca : const Color(0xFFE0E0E0);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                selected ? Const.tosca.withValues(alpha: 0.08) : Colors.white,
            border: Border.all(color: color, width: selected ? 1.6 : 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('EEE').format(date),
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('d MMM').format(date),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final BookingSlot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Const.tosca : Colors.white,
          border: Border.all(
            color: selected ? Const.tosca : const Color(0xFFE0E0E0),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          DateFormat('HH:mm').format(slot.startTime),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
