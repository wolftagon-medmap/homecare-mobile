import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/pricing/domain/entities/estimate_revision.dart';
import 'package:m2health/features/pricing/presentation/widgets/estimate_breakdown.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The body of an `estimate_revision` message. Dumb: the messaging feature puts
/// it inside its own bubble and supplies the two callbacks.
///
/// Pass [onApprove] and [onReject] on the patient side only; a professional
/// sees the same card without buttons.
class EstimateRevisionCard extends StatelessWidget {
  const EstimateRevisionCard({
    super.key,
    required this.revision,
    this.onApprove,
    this.onReject,
    this.isResponding = false,
  });

  final EstimateRevision revision;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool isResponding;

  @override
  Widget build(BuildContext context) {
    final t = context.t.pricing;
    final canRespond = revision.awaitingPatient && onApprove != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6E9EE)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.revision_title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusPill(status: revision.status),
            ],
          ),
          if (revision.note != null) ...[
            const SizedBox(height: 6),
            Text(
              revision.note!,
              style: const TextStyle(fontSize: 12.5, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 12),
          EstimateBreakdownView(
            estimate: revision.estimate,
            showTitle: false,
          ),
          const SizedBox(height: 6),
          Text(
            t.revision_was(price: _money(revision.previousTotal)),
            style: const TextStyle(fontSize: 11.5, color: Colors.black54),
          ),
          if (canRespond) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isResponding ? null : onReject,
                    child: Text(context.t.global.cancel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Const.tosca),
                    onPressed: isResponding ? null : onApprove,
                    child: isResponding
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(t.revision_approved),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _money(double value) =>
      value % 1 == 0 ? '\$${value.toInt()}' : '\$${value.toStringAsFixed(2)}';
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final EstimateRevisionStatus status;

  @override
  Widget build(BuildContext context) {
    final t = context.t.pricing;

    return switch (status) {
      EstimateRevisionStatus.proposed => StatusPill(
          tone: BookingStatusTone.pending,
          label: t.revision_proposed,
          dense: true),
      EstimateRevisionStatus.approved => StatusPill(
          tone: BookingStatusTone.confirmed,
          label: t.revision_approved,
          dense: true),
      EstimateRevisionStatus.rejected => StatusPill(
          tone: BookingStatusTone.cancelled,
          label: t.revision_rejected,
          dense: true),
      EstimateRevisionStatus.superseded => StatusPill(
          tone: BookingStatusTone.info, label: t.revision_title, dense: true),
    };
  }
}
