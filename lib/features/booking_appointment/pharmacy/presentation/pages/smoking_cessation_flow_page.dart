import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/bloc/smoking_cessation_flow_cubit.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/smoking_cessation_form_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class SmokingCessationFlowPage extends StatefulWidget {
  const SmokingCessationFlowPage({super.key});

  @override
  State<SmokingCessationFlowPage> createState() =>
      _SmokingCessationFlowPageState();
}

class _SmokingCessationFlowPageState extends State<SmokingCessationFlowPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    final state = context.read<SmokingCessationFlowCubit>().state;
    final cubit = context.read<SmokingCessationFlowCubit>();

    if (state.submissionStatus == SmokingCessationSubmissionStatus.submitting) {
      return;
    }

    switch (state.currentStep) {
      case SmokingCessationFlowStep.form:
        Navigator.pop(context);
        break;
      case SmokingCessationFlowStep.searchProfessional:
        cubit.setStep(SmokingCessationFlowStep.form);
        break;
      case SmokingCessationFlowStep.professionalDetail:
        cubit.setStep(SmokingCessationFlowStep.searchProfessional);
        break;
      case SmokingCessationFlowStep.scheduling:
        cubit.setStep(SmokingCessationFlowStep.professionalDetail);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SmokingCessationFlowCubit, SmokingCessationFlowState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        if (state.submissionStatus ==
                SmokingCessationSubmissionStatus.success &&
            state.createdAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.booking_appointment_created_success),
              backgroundColor: Colors.green,
            ),
          );
          GoRouter.of(context).goNamed(
            AppRoutes.appointmentDetail,
            extra: state.createdAppointment!.id!,
          );
        }
        if (state.submissionStatus ==
            SmokingCessationSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    context.l10n.booking_appointment_created_failed,
              ),
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
                SmokingCessationFormPage(
                  initialForm: state.form,
                  onSubmit: (form) {
                    context.read<SmokingCessationFlowCubit>().updateForm(form);
                  },
                ),
                BlocProvider(
                  create: (context) => ProfessionalBloc(
                    getProfessionals: sl(),
                    toggleFavorite: sl(),
                  ),
                  child: SearchProfessionalPage(
                    role: 'pharmacist',
                    onProfessionalSelected: (prof) {
                      context
                          .read<SmokingCessationFlowCubit>()
                          .selectProfessional(prof);
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
                      role: 'pharmacist',
                      onButtonPressed: () {
                        context
                            .read<SmokingCessationFlowCubit>()
                            .setStep(SmokingCessationFlowStep.scheduling);
                      },
                    ),
                  ),
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (context) => ScheduleAppointmentCubit(
                      getAvailableTimeSlots: sl(),
                      rescheduleAppointment: sl(),
                    ),
                    child: ScheduleAppointmentPage(
                      data: ScheduleAppointmentPageData(
                        professional: state.selectedProfessional!,
                        isSubmitting: state.submissionStatus ==
                            SmokingCessationSubmissionStatus.submitting,
                        onSlotSelected: (timeSlot) {
                          context
                              .read<SmokingCessationFlowCubit>()
                              .selectTimeSlot(timeSlot.startTime);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
