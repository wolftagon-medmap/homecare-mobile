import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/bloc/second_opinion_imaging_flow_bloc.dart';
import 'package:m2health/features/second_opinion_imaging/presentation/pages/teleradiology.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class SecondOpinionImagingFlowPage extends StatefulWidget {
  const SecondOpinionImagingFlowPage({super.key});

  @override
  State<SecondOpinionImagingFlowPage> createState() =>
      _SecondOpinionImagingFlowPageState();
}

class _SecondOpinionImagingFlowPageState
    extends State<SecondOpinionImagingFlowPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    final state = context.read<SecondOpinionImagingFlowBloc>().state;
    final flowBloc = context.read<SecondOpinionImagingFlowBloc>();

    if (state.submissionStatus == AppointmentSubmissionStatus.submitting) {
      return;
    }

    switch (state.currentStep) {
      case SecondOpinionImagingFlowStep.form:
        Navigator.pop(context);
        break;
      case SecondOpinionImagingFlowStep.searchProfessional:
        flowBloc.add(const FlowStepChanged(SecondOpinionImagingFlowStep.form));
        break;
      case SecondOpinionImagingFlowStep.viewProfessionalDetail:
        flowBloc.add(const FlowStepChanged(SecondOpinionImagingFlowStep.searchProfessional));
        break;
      case SecondOpinionImagingFlowStep.scheduling:
        flowBloc.add(const FlowStepChanged(SecondOpinionImagingFlowStep.viewProfessionalDetail));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecondOpinionImagingFlowBloc,
        SecondOpinionImagingFlowState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        if (state.submissionStatus == AppointmentSubmissionStatus.success &&
            state.createdAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Second opinion request submitted successfully"),
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
              content: Text(state.errorMessage ?? "Failed to submit request"),
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
                const TeleradiologyPage(),
                BlocProvider(
                  create: (context) => ProfessionalBloc(
                    getProfessionals: sl(),
                    toggleFavorite: sl(),
                  ),
                  child: SearchProfessionalPage(
                    role: 'radiologist',
                    onProfessionalSelected: (prof) {
                      context
                          .read<SecondOpinionImagingFlowBloc>()
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
                      role: 'radiologist',
                      onButtonPressed: () {
                        context.read<SecondOpinionImagingFlowBloc>().add(
                            const FlowStepChanged(SecondOpinionImagingFlowStep.scheduling));
                      },
                    ),
                  )
                else
                  const SizedBox(),
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (context) => ScheduleAppointmentCubit(
                      getAvailableTimeSlots: sl(),
                      rescheduleAppointment: sl(),
                    ),
                    child: ScheduleAppointmentPage(
                        data: ScheduleAppointmentPageData(
                      professional: state.selectedProfessional!,
                      serviceType: 'second_opinion_imaging',
                      isSubmitting: state.submissionStatus ==
                          AppointmentSubmissionStatus.submitting,
                      onSlotSelected: (timeSlot) {
                        context
                            .read<SecondOpinionImagingFlowBloc>()
                            .add(FlowTimeSlotSelected(timeSlot.startTime));
                      },
                    )),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
