import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_state.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/professional_profile/presentation/widgets/public_profile_body.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

/// Choosing a professional happens here, not on the list: continuing from this
/// page is what selects them.
class GuidedProfessionalDetailPage extends StatelessWidget {
  const GuidedProfessionalDetailPage({
    super.key,
    required this.args,
    required this.professional,
  });

  final GuidedBookingStepArgs args;
  final BookingProfessional professional;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfessionalDetailCubit(getProfessionalDetail: sl())
        ..fetchProfessionalDetail(professional.id),
      child: _DetailView(args: args, professional: professional),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.args, required this.professional});

  final GuidedBookingStepArgs args;
  final BookingProfessional professional;

  void _choose(BuildContext context) {
    args.cubit.selectProfessional(professional.id);
    if (args.returnToReview) {
      context
        ..pop()
        ..pop();
      return;
    }
    context.push(
      GuidedBookingRoutes.dateTime,
      extra: GuidedBookingStepArgs(args.cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.professional;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          professional.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<ProfessionalDetailCubit, ProfessionalDetailState>(
        builder: (context, state) {
          if (state is ProfessionalDetailLoading ||
              state is ProfessionalDetailInitial) {
            return BookingLoadingState(message: t.loading);
          }
          if (state is ProfessionalDetailError) {
            return BookingErrorState(
              message: state.message,
              onRetry: () => context
                  .read<ProfessionalDetailCubit>()
                  .fetchProfessionalDetail(professional.id),
            );
          }
          if (state is ProfessionalDetailLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: PublicProfileBody(professional: state.professional),
            );
          }
          return BookingErrorState(
            message: t.error,
            onRetry: () => context
                .read<ProfessionalDetailCubit>()
                .fetchProfessionalDetail(professional.id),
          );
        },
      ),
      bottomNavigationBar: StickyBottomCta(
        label: t.choose_cta,
        onPressed: () => _choose(context),
      ),
    );
  }
}
