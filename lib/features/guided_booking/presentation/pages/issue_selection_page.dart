import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/remarks_field.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/booking_flow_progress.dart';
import 'package:m2health/i18n/translations.g.dart';

class IssueSelectionPage extends StatelessWidget {
  const IssueSelectionPage({super.key, required this.args});

  final GuidedBookingStepArgs args;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocBuilder<GuidedBookingCubit, GuidedBookingState>(
      builder: (context, state) {
        final issues = state.visibleIssues;
        final canContinue = state.draft.hasIssues;
        final hasAddOns = state.hasAddOnPath &&
            PriceTableCubit.of(context)
                .addOnsFor(state.pricingCategory)
                .isNotEmpty;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              state.catalogue?.title ?? t.namespace_title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: Column(
            children: [
              BookingFlowProgress(
                state: state,
                step: GuidedBookingStep.issues,
              ),
              Expanded(
                child: issues.isEmpty
                    ? BookingEmptyState(message: t.issues.empty)
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 24),
                        children: [
                          BookingStepHeader(
                            title: t.issues.title,
                            subtitle: t.issues.subtitle,
                          ),
                          for (final issue in issues)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              child: MultiSelectListTile(
                                title: issue.label,
                                subtitle: issue.description,
                                selected:
                                    state.draft.issueCodes.contains(issue.code),
                                onChanged: (_) => cubit.toggleIssue(issue.code),
                              ),
                            ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: RemarksField(
                              label: t.issues.remarks_label,
                              description: t.issues.remarks_hint,
                              initialValue: state.draft.remarks,
                              onChanged: cubit.setRemarks,
                            ),
                          ),
                          if (hasAddOns)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                              child: TextButton.icon(
                                onPressed: () => context.push(
                                  GuidedBookingRoutes.addOns,
                                  extra: GuidedBookingStepArgs(cubit),
                                ),
                                icon: const Icon(Icons.add_circle_outline,
                                    size: 18),
                                label: Text(t.issues.add_ons_link),
                                style: TextButton.styleFrom(
                                  foregroundColor: Const.aqua,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
          bottomNavigationBar: StickyBottomCta(
            label: t.cta.kContinue,
            onPressed: canContinue
                ? () {
                    if (args.returnToReview) {
                      context.pop();
                    } else {
                      context.push(
                        GuidedBookingRoutes.professional,
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
}
