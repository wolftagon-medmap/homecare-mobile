import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The care-task states the patient sees on step 7 of the guided flow, plus a
/// neutral tone for anything else.
enum BookingStatusTone { pending, confirmed, proposed, cancelled, info }

/// Status badge for care tasks and appointments.
///
/// The four flow states carry a default label from the shared namespace; pass
/// [label] to override it. [BookingStatusTone.info] has no default — give it
/// one.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.tone,
    this.label,
    this.dense = false,
  });

  final BookingStatusTone tone;
  final String? label;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final text = label ?? _defaultLabel(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(dense ? 6 : 8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: dense ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color get _color => switch (tone) {
        BookingStatusTone.pending => const Color(0xFFE0A008),
        BookingStatusTone.confirmed => Const.tosca,
        BookingStatusTone.proposed => Const.primaryBlue,
        BookingStatusTone.cancelled => const Color(0xFFD64545),
        BookingStatusTone.info => Const.contentTextColor,
      };

  String _defaultLabel(BuildContext context) {
    final status = context.t.sharedBooking.status;
    return switch (tone) {
      BookingStatusTone.pending => status.pending,
      BookingStatusTone.confirmed => status.confirmed,
      BookingStatusTone.proposed => status.proposed,
      BookingStatusTone.cancelled => status.cancelled,
      BookingStatusTone.info => '',
    };
  }
}
