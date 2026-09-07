import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/core/presentation/widgets/service_widgets.dart';
import 'package:m2health/core/services/questionnaire_service.dart';
import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/pricing/presentation/widgets/starting_from_price.dart';
import 'package:m2health/features/smoking_cessation/presentation/bloc/smoking_cessation_flow_cubit.dart';
import 'package:m2health/features/smoking_cessation/presentation/pages/smoking_cessation_flow_page.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/booking_flow_progress.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

/// One generic page for every service's sub-service picker, rendered from the
/// catalogue payload rather than nine hand-written screens.
class SubServicePage extends StatelessWidget {
  const SubServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocBuilder<GuidedBookingCubit, GuidedBookingState>(
      builder: (context, state) {
        final subCategories = state.catalogue?.subCategories ?? const [];

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
                step: GuidedBookingStep.subService,
              ),
              Expanded(
                child: subCategories.isEmpty
                    ? BookingEmptyState(message: t.sub_service.empty)
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 24),
                        children: [
                          // BookingStepHeader(title: t.sub_service.title),
                          for (final sub in subCategories)
                            ServiceSelectionCard(
                              title: sub.label,
                              description: sub.description ?? '',
                              imagePath:
                                  sub.image ?? 'assets/icons/ilu_nurse.png',
                              backgroundColor: _background(sub),
                              priceTag: StartingFromPrice(
                                category: state.pricingCategory,
                              ),
                              onTap: () {
                                if (sub.legacyFlow != null) {
                                  _openLegacyFlow(context, sub.legacyFlow!);
                                  return;
                                }
                                cubit.selectSubCategory(sub.code);
                                context.push(
                                  GuidedBookingRoutes.issues,
                                  extra: GuidedBookingStepArgs(cubit),
                                );
                              },
                            ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Quit Smoking is the one sub-service that keeps its own screen: its four
  /// structured fields carry clinical meaning a multi-select would lose.
  void _openLegacyFlow(BuildContext context, String flow) {
    if (flow != 'smoking_cessation') return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => SmokingCessationFlowCubit(
            createPharmacyAppointment: sl(),
            questionnaireService: sl<QuestionnaireService>(),
          ),
          child: const SmokingCessationFlowPage(),
        ),
      ),
    );
  }

  Color _background(IssueSubCategory sub) {
    final raw = sub.background;
    if (raw == null) return const Color(0xFFF2F4F7);
    final value = int.tryParse(raw.replaceFirst('#', ''), radix: 16);
    if (value == null) return const Color(0xFFF2F4F7);
    return Color(raw.length > 7 ? value : 0xFF000000 | value);
  }
}
