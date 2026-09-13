import 'package:flutter/material.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/etc/pricing/domain/entities/estimate.dart';
import 'package:m2health/i18n/translations.g.dart';

/// The full breakdown, for the review step and the estimate-revision card.
/// Dumb: pass it an [Estimate] from `PriceTable.estimateFor`, it renders.
class EstimateBreakdownView extends StatelessWidget {
  const EstimateBreakdownView({
    super.key,
    required this.estimate,
    this.showTitle = true,
    this.showDisclaimer = true,
  });

  final Estimate estimate;
  final bool showTitle;
  final bool showDisclaimer;

  @override
  Widget build(BuildContext context) {
    final t = context.t.pricing;

    if (estimate.lines.isEmpty) {
      return Text(
        t.estimate_empty,
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      );
    }

    final addOns = estimate.addOnLines.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            t.estimate_title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
        ],
        for (final line in estimate.baseLines) _EstimateRow(line: line),
        if (addOns.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            t.add_ons,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          for (final line in addOns) _EstimateRow(line: line),
        ],
        const Divider(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.estimate_total,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            PricePill(
              amount: estimate.total,
              variant: PricePillVariant.exact,
            ),
          ],
        ),
        if (showDisclaimer) ...[
          const SizedBox(height: 8),
          Text(
            t.estimate_disclaimer,
            style: const TextStyle(fontSize: 11.5, color: Colors.black54),
          ),
        ],
      ],
    );
  }
}

class _EstimateRow extends StatelessWidget {
  const _EstimateRow({required this.line});

  final EstimateLine line;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.label, style: const TextStyle(fontSize: 13)),
                if (line.isHourly)
                  Text(
                    context.t.pricing.hours(count: _count(line.quantity)),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${_money(line.amount)}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  static String _count(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();

  static String _money(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
}
