import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';

import '../../domain/entities/estimate_revision.dart';

/// The `estimate_revision` action card.
///
/// **This widget does no arithmetic.** Every amount, and both totals, arrive
/// already calculated by the pricing module and are rendered through A0's
/// [PricePill]. The single subtraction is `delta`, on two numbers that were both
/// handed to it. Pricing owns the money; this owns the pixels.
class EstimateRevisionCard extends StatelessWidget {
  final EstimateRevision revision;

  /// Only the patient approves. The professional who proposed it watches.
  final bool canApprove;
  final VoidCallback? onApprove;
  final bool busy;

  const EstimateRevisionCard({
    super.key,
    required this.revision,
    required this.canApprove,
    this.onApprove,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final pending = revision.isPending;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: pending ? Const.tosca : Const.borderSubtle),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined,
                  size: 18, color: Const.tosca),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Revised estimate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Const.primaryTextColor,
                  ),
                ),
              ),
              if (!pending)
                StatusPill(
                  tone: revision.status == EstimateRevisionStatus.approved
                      ? BookingStatusTone.confirmed
                      : BookingStatusTone.info,
                  label: revision.status == EstimateRevisionStatus.approved
                      ? 'Approved'
                      : 'Withdrawn',
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final line in revision.lines) _LineRow(line: line),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Const.borderSubtle),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'New estimated total',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Const.primaryTextColor,
                  ),
                ),
              ),
              PricePill(
                amount: revision.proposedTotal,
                variant: PricePillVariant.exact,
                currency: revision.currency,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _deltaLabel,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          if (revision.note != null && revision.note!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Const.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                revision.note!,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey[800], height: 1.35),
              ),
            ),
          ],
          if (pending && canApprove) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: busy ? null : onApprove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.tosca,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: const Text(
                  'Approve',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String get _deltaLabel {
    final delta = revision.delta;
    final was =
        '${revision.currency}${revision.currentTotal.toStringAsFixed(2)}';
    if (delta == 0) return 'Unchanged from $was';
    final direction = delta > 0 ? 'up' : 'down';
    final amount = '${revision.currency}${delta.abs().toStringAsFixed(2)}';
    return '$direction $amount from $was';
  }
}

class _LineRow extends StatelessWidget {
  final EstimateLine line;

  const _LineRow({required this.line});

  @override
  Widget build(BuildContext context) {
    final removed = line.change == EstimateLineChange.removed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (line.change != EstimateLineChange.unchanged) ...[
            Icon(
              removed ? Icons.remove_circle_outline : Icons.add_circle_outline,
              size: 15,
              color: removed ? const Color(0xFFD64545) : Const.tosca,
            ),
            const SizedBox(width: 6),
          ] else
            const SizedBox(width: 21),
          Expanded(
            child: Text(
              line.label,
              style: TextStyle(
                fontSize: 13,
                color: removed ? Colors.grey[500] : Const.primaryTextColor,
                decoration: removed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          PricePill(
            amount: line.amount,
            variant: PricePillVariant.exact,
            dense: true,
            color: removed ? Colors.grey : null,
          ),
        ],
      ),
    );
  }
}
