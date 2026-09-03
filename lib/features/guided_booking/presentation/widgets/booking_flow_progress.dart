import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';

enum GuidedBookingStep { subService, issues, professional, schedule, review }

/// Unnumbered progress for the guided flow. The step list is derived from the
/// catalogue rather than assumed, because a category with one sub-service never
/// shows the sub-service screen and any fixed count would be wrong there.
/// Add-ons are a detour off the issue step and are deliberately not in it.
class BookingFlowProgress extends StatelessWidget {
  const BookingFlowProgress({
    super.key,
    required this.state,
    required this.step,
  });

  final GuidedBookingState state;
  final GuidedBookingStep step;

  static List<GuidedBookingStep> stepsFor(GuidedBookingState state) => [
        if (state.catalogue?.needsSubServiceStep ?? false)
          GuidedBookingStep.subService,
        GuidedBookingStep.issues,
        GuidedBookingStep.professional,
        GuidedBookingStep.schedule,
        GuidedBookingStep.review,
      ];

  @override
  Widget build(BuildContext context) {
    final steps = stepsFor(state);
    final index = steps.indexOf(step);
    final progress = index < 0 ? 0.0 : (index + 1) / steps.length;

    return SizedBox(
      height: 3,
      child: ColoredBox(
        color: Const.borderSubtle,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          builder: (context, value, _) => Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              heightFactor: 1,
              child: const ColoredBox(color: Const.aqua),
            ),
          ),
        ),
      ),
    );
  }
}
