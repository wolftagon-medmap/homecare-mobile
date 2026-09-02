import 'package:flutter/material.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';

/// `Starting from $X` — the admin floor for the cheapest service in the
/// category. Renders nothing until prices have loaded, or when the category has
/// none, so it is safe to drop into any card.
class StartingFromPrice extends StatelessWidget {
  const StartingFromPrice({
    super.key,
    required this.category,
    this.dense = false,
    this.padding,
  });

  final String category;
  final bool dense;

  /// Applied only when there is a price, so an unpriced category leaves no gap.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final amount = PriceTableCubit.of(context).startingFromFor(category);
    if (amount == null) return const SizedBox.shrink();

    final pill = PricePill(amount: amount, dense: dense);
    if (padding == null) return pill;

    return Padding(
      padding: padding!,
      child: Align(alignment: Alignment.centerLeft, child: pill),
    );
  }
}

/// `from $Y` — the cheapest price *this* professional charges in the category.
/// The exact figure for a given selection belongs on the review screen; this is
/// a starting point, floor-clamped like every other price.
class ProfessionalFromPrice extends StatelessWidget {
  const ProfessionalFromPrice({
    super.key,
    required this.professionalId,
    required this.category,
    this.dense = false,
  });

  final int professionalId;
  final String category;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final amount =
        PriceTableCubit.of(context).professionalFrom(professionalId, category);
    if (amount == null) return const SizedBox.shrink();

    return PricePill(
      amount: amount,
      variant: PricePillVariant.from,
      dense: dense,
    );
  }
}
