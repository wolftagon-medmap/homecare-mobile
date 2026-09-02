import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/i18n/translations.g.dart';

/// How a price is framed. See refined-booking-flow.md §4.
enum PricePillVariant {
  /// Service card and service detail — the admin floor price.
  startingFrom,

  /// Professional card — that professional's base price for this service.
  from,

  /// A settled figure, such as a line in the estimate breakdown.
  exact,
}

/// Renders a price the same way everywhere it appears in the booking flow.
class PricePill extends StatelessWidget {
  const PricePill({
    super.key,
    required this.amount,
    this.variant = PricePillVariant.startingFrom,
    this.currency = r'$',
    this.dense = false,
    this.color,
  });

  final num amount;
  final PricePillVariant variant;
  final String currency;
  final bool dense;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tone = color ?? Const.tosca;
    final price = '$currency${_format(amount)}';
    final label = switch (variant) {
      PricePillVariant.startingFrom =>
        context.t.sharedBooking.starting_from(price: price),
      PricePillVariant.from => context.t.sharedBooking.from_price(price: price),
      PricePillVariant.exact => price,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(dense ? 6 : 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: dense ? 11 : 13,
          fontWeight: FontWeight.w600,
          color: tone,
        ),
      ),
    );
  }

  /// Whole amounts read as `$80`, anything else keeps two decimals.
  static String _format(num amount) =>
      amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(2);
}
