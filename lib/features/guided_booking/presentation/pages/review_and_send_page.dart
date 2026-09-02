import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/draft_summary_tile.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/features/pricing/presentation/widgets/estimate_breakdown.dart';
import 'package:m2health/i18n/translations.g.dart';

class ReviewAndSendPage extends StatelessWidget {
  const ReviewAndSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocConsumer<GuidedBookingCubit, GuidedBookingState>(
      listenWhen: (previous, current) =>
          previous.submitted == null && current.submitted != null,
      listener: (context, state) => context.push(
        GuidedBookingRoutes.sent,
        extra: GuidedBookingStepArgs(cubit),
      ),
      builder: (context, state) {
        final draft = state.draft;
        final estimate = PriceTableCubit.of(context).estimateFor(
          serviceCodes: state.serviceCodes,
          addOnCodes: draft.addOnCodes,
          professionalId: draft.professionalId,
        );

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              t.review.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              BookingStepHeader(
                title: t.review.title,
                subtitle: t.review.subtitle,
                step: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DraftSummaryTile(
                      label: t.review.service,
                      value: state.selectedSubCategory?.label ??
                          state.catalogue?.title ??
                          draft.category,
                    ),
                    DraftSummaryTile(
                      label: t.review.issues,
                      value: state.selectedIssueLabels.isEmpty
                          ? t.review.none
                          : state.selectedIssueLabels.join(', '),
                      onEdit: () => _edit(context, GuidedBookingRoutes.issues),
                    ),
                    DraftSummaryTile(
                      label: t.review.remarks,
                      value:
                          draft.remarks.isEmpty ? t.review.none : draft.remarks,
                      onEdit: () => _edit(context, GuidedBookingRoutes.issues),
                    ),
                    if (state.hasAddOnPath)
                      DraftSummaryTile(
                        label: t.review.add_ons,
                        value: _addOnLabels(context, state),
                        onEdit: () =>
                            _edit(context, GuidedBookingRoutes.addOns),
                      ),
                    DraftSummaryTile(
                      label: t.review.location,
                      value: state.selectedAddress?.formattedAddress ??
                          state.selectedAddress?.label ??
                          t.review.none,
                      onEdit: () =>
                          _edit(context, GuidedBookingRoutes.professional),
                    ),
                    DraftSummaryTile(
                      label: t.review.professional,
                      value: state.selectedProfessional?.name ?? t.review.none,
                      onEdit: () =>
                          _edit(context, GuidedBookingRoutes.professional),
                    ),
                    DraftSummaryTile(
                      label: t.review.schedule,
                      value: draft.preferredAt == null
                          ? t.review.none
                          : DateFormat('EEE d MMM, HH:mm')
                              .format(draft.preferredAt!),
                      onEdit: () =>
                          _edit(context, GuidedBookingRoutes.dateTime),
                    ),
                    const Divider(height: 28),
                    EstimateBreakdownView(estimate: estimate),
                    const SizedBox(height: 8),
                    Text(
                      t.review.estimate_note,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: StickyBottomCta(
            label: t.review.send,
            isLoading: state.isSubmitting,
            onPressed: draft.isSubmittable ? cubit.submit : null,
          ),
        );
      },
    );
  }

  void _edit(BuildContext context, String route) => context.push(
        route,
        extra: GuidedBookingStepArgs(
          context.read<GuidedBookingCubit>(),
          returnToReview: true,
        ),
      );

  String _addOnLabels(BuildContext context, GuidedBookingState state) {
    final table = PriceTableCubit.of(context);
    final labels = [
      for (final code in state.draft.addOnCodes)
        table.serviceByCode(code)?.name ?? code,
    ];
    return labels.isEmpty
        ? context.t.guidedBooking.review.none
        : labels.join(', ');
  }
}
