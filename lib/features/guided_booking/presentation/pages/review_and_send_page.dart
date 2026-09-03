import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/booking_flow_progress.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_avatar.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_stats.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/review_section.dart';
import 'package:m2health/features/pricing/domain/entities/estimate.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/features/pricing/presentation/widgets/estimate_breakdown.dart';
import 'package:m2health/features/pricing/presentation/widgets/starting_from_price.dart';
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
          backgroundColor: const Color(0xFFF7F9FA),
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
                step: GuidedBookingStep.review,
              ),
              Expanded(child: _body(context, state, estimate)),
            ],
          ),
          bottomNavigationBar: StickyBottomCta(
            label: t.review.send,
            isLoading: state.isSubmitting,
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.t.pricing.estimate_total,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PricePill(
                  amount: estimate.total,
                  variant: PricePillVariant.exact,
                ),
              ],
            ),
            onPressed: draft.isSubmittable ? cubit.submit : null,
          ),
        );
      },
    );
  }

  Widget _body(
    BuildContext context,
    GuidedBookingState state,
    Estimate estimate,
  ) {
    final t = context.t.guidedBooking.review;
    final draft = state.draft;
    final professional = state.selectedProfessional;
    final preferredAt = draft.preferredAt;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        BookingStepHeader(
          title: t.title,
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 14),
        ),
        ReviewSection(
          label: t.service,
          onEdit: () => _edit(context, GuidedBookingRoutes.issues),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.selectedSubCategory?.label ??
                    state.catalogue?.title ??
                    draft.category,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (state.selectedIssueLabels.isNotEmpty) ...[
                const SizedBox(height: 10),
                ReviewChips(labels: state.selectedIssueLabels),
              ],
              if (draft.remarks.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  draft.remarks,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (state.hasAddOnPath) ...[
          const SizedBox(height: 12),
          ReviewSection(
            label: t.add_ons,
            onEdit: () => _edit(context, GuidedBookingRoutes.addOns),
            child: draft.addOnCodes.isEmpty
                ? _Muted(t.none)
                : ReviewChips(labels: _addOnLabels(context, state)),
          ),
        ],
        const SizedBox(height: 12),
        ReviewSection(
          label: t.professional,
          onEdit: () => _edit(context, GuidedBookingRoutes.professional),
          child: professional == null
              ? _Muted(t.none)
              : Row(
                  children: [
                    ProfessionalAvatar(professional: professional, radius: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            professional.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (professional.jobTitle != null)
                            Text(
                              professional.jobTitle!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          const SizedBox(height: 4),
                          ProfessionalStats(
                            professional: professional,
                            showExperience: false,
                          ),
                        ],
                      ),
                    ),
                    ProfessionalFromPrice(
                      professionalId: professional.id,
                      category: state.pricingCategory,
                      dense: true,
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        ReviewSection(
          label: t.schedule,
          onEdit: () => _edit(context, GuidedBookingRoutes.dateTime),
          child: preferredAt == null
              ? _Muted(t.none)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('EEEE d MMMM').format(preferredAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('HH:mm').format(preferredAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Const.tosca,
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        ReviewSection(
          label: t.location,
          onEdit: () => _edit(context, GuidedBookingRoutes.professional),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Const.tosca,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  state.selectedAddress?.formattedAddress ??
                      state.selectedAddress?.label ??
                      t.none,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Const.borderSubtle),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EstimateBreakdownView(estimate: estimate, showDisclaimer: false),
              const SizedBox(height: 10),
              Text(
                t.estimate_note,
                style: const TextStyle(fontSize: 11.5, color: Colors.black54),
              ),
            ],
          ),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            state.errorMessage!,
            style: const TextStyle(fontSize: 12, color: Colors.redAccent),
          ),
        ],
      ],
    );
  }

  void _edit(BuildContext context, String route) => context.push(
        route,
        extra: GuidedBookingStepArgs(
          context.read<GuidedBookingCubit>(),
          returnToReview: true,
        ),
      );

  List<String> _addOnLabels(BuildContext context, GuidedBookingState state) {
    final table = PriceTableCubit.of(context);
    return [
      for (final code in state.draft.addOnCodes)
        table.serviceByCode(code)?.name ?? code,
    ];
  }
}

class _Muted extends StatelessWidget {
  const _Muted(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black45),
    );
  }
}
