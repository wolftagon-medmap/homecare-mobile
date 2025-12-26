import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/physiotherapy/presentation/bloc/physiotherapy_appointment_flow_bloc.dart';
import 'package:m2health/features/physiotherapy/presentation/pages/schedule_physiotherapy_appointment.dart';
import 'package:m2health/features/physiotherapy/presentation/bloc/schedule_physiotherapy_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class PhysiotherapyAppointmentFlowPage extends StatefulWidget {
  const PhysiotherapyAppointmentFlowPage({super.key});

  @override
  State<PhysiotherapyAppointmentFlowPage> createState() =>
      _PhysiotherapyAppointmentFlowPageState();
}

class _PhysiotherapyAppointmentFlowPageState
    extends State<PhysiotherapyAppointmentFlowPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    final state = context.read<PhysiotherapyAppointmentFlowBloc>().state;
    final flowBloc = context.read<PhysiotherapyAppointmentFlowBloc>();

    if (state.submissionStatus == AppointmentSubmissionStatus.submitting) {
      return; // Prevent back navigation during submission
    }

    switch (state.currentStep) {
      case PhysiotherapyFlowStep.searchProfessional:
        Navigator.pop(context);
        break;
      case PhysiotherapyFlowStep.viewProfessionalDetail:
        flowBloc.add(const FlowStepChanged(PhysiotherapyFlowStep.searchProfessional));
        break;
      case PhysiotherapyFlowStep.scheduling:
        flowBloc.add(const FlowStepChanged(PhysiotherapyFlowStep.viewProfessionalDetail));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhysiotherapyAppointmentFlowBloc,
        PhysiotherapyAppointmentFlowState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        if (state.submissionStatus == AppointmentSubmissionStatus.success &&
            state.createdAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.physiotherapy_flow_success),
              backgroundColor: Colors.green,
            ),
          );

          GoRouter.of(context).goNamed(
            AppRoutes.appointmentDetail,
            extra: state.createdAppointment!.id!,
          );
        }
        if (state.submissionStatus == AppointmentSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage != null
                    ? context.l10n
                        .physiotherapy_flow_failure_with_reason(state.errorMessage!)
                    : context.l10n.physiotherapy_flow_failure,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.currentStep.index != _pageController.page?.round()) {
          _pageController.animateToPage(
            state.currentStep.index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) return;
            _onBack(context);
          },
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BlocProvider(
                  create: (context) => ProfessionalBloc(
                    getProfessionals: sl(),
                    toggleFavorite: sl(),
                  ),
                  child: SearchProfessionalPage(
                    role: 'physiotherapist',
                    onProfessionalSelected: (prof) {
                      context
                          .read<PhysiotherapyAppointmentFlowBloc>()
                          .add(FlowProfessionalSelected(prof));
                    },
                  ),
                ),
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (context) => ProfessionalDetailCubit(
                      getProfessionalDetail: sl(),
                    ),
                    child: ProfessionalDetailsPage(
                      professionalId: state.selectedProfessional!.id,
                      role: 'physiotherapist',
                      onButtonPressed: () {
                        context.read<PhysiotherapyAppointmentFlowBloc>().add(
                            const FlowStepChanged(PhysiotherapyFlowStep.scheduling));
                      },
                    ),
                  )
                else
                  const SizedBox(), // Placeholder for when no professional selected
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (context) => SchedulePhysiotherapyAppointmentCubit(
                      repository: sl(),
                    ),
                    child: SchedulePhysiotherapyAppointmentPage(
                        data: SchedulePhysiotherapyAppointmentPageData(
                      professional: state.selectedProfessional!,
                      title: state.type.getLabel(context),
                      isSubmitting: state.submissionStatus ==
                          AppointmentSubmissionStatus.submitting,
                      onSubmit: ({required timeSlot, required duration}) {
                        context
                            .read<PhysiotherapyAppointmentFlowBloc>()
                            .add(FlowTimeSlotSelected(timeSlot.startTime, duration));
                      },
                    )),
                  )
                else
                  const SizedBox(), // Placeholder
              ],
            ),
          ),
        );
      },
    );
  }
}
