import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';

/// A detour, not a step: it passes no `step` to the header, so the counter and
/// progress bar disappear.
class AddOnPage extends StatelessWidget {
  const AddOnPage({super.key, required this.args});

  final GuidedBookingStepArgs args;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocBuilder<GuidedBookingCubit, GuidedBookingState>(
      builder: (context, state) {
        final addOns =
            PriceTableCubit.of(context).addOnsFor(state.pricingCategory);
        final selected = state.draft.addOnCodes;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              t.add_ons.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: addOns.isEmpty
              ? BookingEmptyState(message: t.add_ons.empty)
              : ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    BookingStepHeader(
                      title: t.add_ons.title,
                      subtitle: t.add_ons.subtitle,
                    ),
                    for (final addOn in addOns)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: MultiSelectListTile(
                          title: addOn.name,
                          selected: selected.contains(addOn.code),
                          onChanged: (_) => cubit.toggleAddOn(addOn.code),
                          trailing: PricePill(
                            amount: addOn.floorPrice,
                            variant: PricePillVariant.exact,
                            dense: true,
                          ),
                        ),
                      ),
                  ],
                ),
          bottomNavigationBar: StickyBottomCta(
            label: t.cta.kContinue,
            onPressed: () => context.pop(),
            secondaryLabel: selected.isEmpty ? null : t.cta.skip,
            onSecondary: selected.isEmpty ? null : () => context.pop(),
            footer: selected.isEmpty
                ? null
                : Text(
                    t.add_ons.selected(count: selected.length),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
          ),
        );
      },
    );
  }
}
