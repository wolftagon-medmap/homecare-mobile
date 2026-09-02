import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/pages/issue_selection_page.dart';
import 'package:m2health/features/guided_booking/presentation/pages/sub_service_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

/// Owns the one cubit the whole flow shares, and applies the skip rule: a
/// category with 0 or 1 sub-services never shows step 1b.
class GuidedBookingEntryPage extends StatelessWidget {
  const GuidedBookingEntryPage({super.key, required this.args});

  final GuidedBookingArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GuidedBookingCubit>(
      create: (_) => sl<GuidedBookingCubit>(param1: args)..loadCatalogue(),
      child: const _GuidedBookingEntryView(),
    );
  }
}

class _GuidedBookingEntryView extends StatelessWidget {
  const _GuidedBookingEntryView();

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;

    return BlocBuilder<GuidedBookingCubit, GuidedBookingState>(
      builder: (context, state) {
        switch (state.catalogueStatus) {
          case BookingLoadStatus.initial:
          case BookingLoadStatus.loading:
            return const Scaffold(
              backgroundColor: Colors.white,
              body: BookingLoadingState(),
            );
          case BookingLoadStatus.failure:
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
              body: BookingErrorState(
                message: state.errorMessage ?? t.issues.error,
                onRetry: context.read<GuidedBookingCubit>().loadCatalogue,
              ),
            );
          case BookingLoadStatus.ready:
            final needsSubService =
                state.catalogue?.needsSubServiceStep ?? false;
            return needsSubService
                ? const SubServicePage()
                : IssueSelectionPage(
                    args: GuidedBookingStepArgs(
                      context.read<GuidedBookingCubit>(),
                    ),
                  );
        }
      },
    );
  }
}
