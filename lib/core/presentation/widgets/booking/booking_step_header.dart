import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The five steps the patient sees. Location is captured on the professional
/// step and is deliberately not one of them — refined-booking-flow.md §3.
const int kBookingStepCount = 5;

/// Segmented progress bar. One filled segment per completed step.
class BookingProgressIndicator extends StatelessWidget {
  const BookingProgressIndicator({
    super.key,
    required this.step,
    this.totalSteps = kBookingStepCount,
  });

  /// 1-based.
  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= totalSteps; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i <= step ? Const.aqua : Const.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (i < totalSteps) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

/// Title, optional subtitle and the step counter, above every guided booking
/// step. Pass [step] as null on screens that sit outside the counted flow,
/// such as the add-on side path.
class BookingStepHeader extends StatelessWidget {
  const BookingStepHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.step,
    this.totalSteps = kBookingStepCount,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 12),
  });

  final String title;
  final String? subtitle;
  final int? step;
  final int totalSteps;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final currentStep = step;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentStep != null) ...[
            BookingProgressIndicator(step: currentStep, totalSteps: totalSteps),
            const SizedBox(height: 10),
            Text(
              context.t.sharedBooking
                  .step_of(current: currentStep, total: totalSteps),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Const.aqua,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Const.primaryTextColor,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Const.contentTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
