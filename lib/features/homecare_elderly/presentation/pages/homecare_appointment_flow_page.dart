import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/homecare_elderly/domain/entities/billing_type.dart';
import 'package:m2health/features/homecare_elderly/presentation/bloc/homecare_appointment_flow_bloc.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/features/payment/presentation/pages/payment_page.dart';

import 'package:m2health/features/subscription/presentation/bloc/subscription_cubit.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_state.dart';

class HomecareAppointmentFlowPage extends StatefulWidget {
  final List<String> selectedTasks;

  const HomecareAppointmentFlowPage({
    super.key,
    required this.selectedTasks,
  });

  @override
  State<HomecareAppointmentFlowPage> createState() =>
      _HomecareAppointmentFlowPageState();
}

class _HomecareAppointmentFlowPageState
    extends State<HomecareAppointmentFlowPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Ensure subscription data is fresh
    context.read<SubscriptionCubit>().fetchSubscriptionData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    final state = context.read<HomecareAppointmentFlowBloc>().state;
    final flowBloc = context.read<HomecareAppointmentFlowBloc>();

    if (state.submissionStatus == AppointmentSubmissionStatus.submitting) {
      return;
    }

    switch (state.currentStep) {
      case HomecareFlowStep.searchProfessional:
        Navigator.pop(context);
        break;
      case HomecareFlowStep.professionalDetails:
        flowBloc
            .add(const FlowStepChanged(HomecareFlowStep.searchProfessional));
        break;
      case HomecareFlowStep.schedule:
        flowBloc
            .add(const FlowStepChanged(HomecareFlowStep.professionalDetails));
        break;
      case HomecareFlowStep.review:
        flowBloc.add(const FlowStepChanged(HomecareFlowStep.schedule));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomecareAppointmentFlowBloc(
        createHomecareAppointment: sl(),
        getHomecareRates: sl(),
      )..add(FlowStarted(widget.selectedTasks)),
      child: BlocConsumer<HomecareAppointmentFlowBloc,
          HomecareAppointmentFlowState>(
        listenWhen: (previous, current) =>
            previous.submissionStatus != current.submissionStatus ||
            previous.currentStep != current.currentStep,
        listener: (context, state) {
          if (state.submissionStatus == AppointmentSubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment created successfully'),
                backgroundColor: Colors.green,
              ),
            );

            if (state.billingType == BillingType.hourly) {
              GoRouter.of(context).push(
                AppRoutes.payment,
                extra: state.createdAppointment!,
              );
            } else {
              GoRouter.of(context).go(AppRoutes.appointmentDetail,
                  extra: state.createdAppointment!.id);
            }
          }
          if (state.submissionStatus == AppointmentSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Failed to create appointment',
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
                      role: 'caregiver',
                      onProfessionalSelected: (prof) {
                        context
                            .read<HomecareAppointmentFlowBloc>()
                            .add(ProviderSelected(prof));
                      },
                    ),
                  ),
                  if (state.selectedProvider != null)
                    BlocProvider(
                      create: (context) => ProfessionalDetailCubit(
                        getProfessionalDetail: sl(),
                      ),
                      child: ProfessionalDetailsPage(
                        professionalId: state.selectedProvider!.id,
                        role: 'caregiver', // or state.selectedProvider!.role
                        onButtonPressed: () {
                          context.read<HomecareAppointmentFlowBloc>().add(
                              const FlowStepChanged(HomecareFlowStep.schedule));
                        },
                      ),
                    )
                  else
                    const SizedBox(), // Placeholder
                  if (state.selectedProvider != null)
                    BlocProvider(
                      create: (context) => ScheduleAppointmentCubit(
                        getAvailableTimeSlots: sl(),
                        rescheduleAppointment: sl(),
                      ),
                      child: ScheduleAppointmentPage(
                        data: ScheduleAppointmentPageData(
                          professional: state.selectedProvider!,
                          serviceType: 'homecare',
                          isSubmitting:
                              false, // Submission handled in review page
                          onSlotSelected: (time) {
                            context
                                .read<HomecareAppointmentFlowBloc>()
                                .add(TimeSlotSelected(time));
                          },
                        ),
                      ),
                    )
                  else
                    const SizedBox(), // Placeholder
                  _HomecareReviewPage(state: state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomecareReviewPage extends StatelessWidget {
  final HomecareAppointmentFlowState state;

  const _HomecareReviewPage({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review & Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 24),
            _buildTaskList(),
            const SizedBox(height: 24),
            _buildBillingSection(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildSummaryCard() {
    final provider = state.selectedProvider;
    final slot = state.selectedTimeSlot!;
    final localStartTime = slot.startTime.toLocal();
    final localEndTime = slot.endTime.toLocal();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (provider != null)
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          provider.avatar ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey[600],
                            );
                          },
                        )),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(provider.jobTitle ?? 'Caregiver'),
                      ],
                    ),
                  ),
                ],
              ),
            const Divider(height: 32),
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Const.aqua),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, d MMMM y').format(localStartTime),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Const.aqua),
                const SizedBox(width: 8),
                Text(
                  ' ${DateFormat('HH:mm aa').format(localStartTime)} - ${DateFormat('HH:mm aa').format(localEndTime)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requested Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        state.selectedTasks.isEmpty
            ? const Text('No tasks selected.')
            : Column(
                children: state.selectedTasks
                    .map((task) => ListTile(
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: -4, horizontal: 0),
                          leading:
                              const Icon(Icons.check_circle, color: Const.aqua),
                          title: Text(task),
                        ))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildBillingSection(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, subscriptionState) {
        const HOMECARE_DURATION_HOURS = 2;
        final subscriptionBalance = subscriptionState.totalBalance;
        final canUseSubscription =
            subscriptionBalance >= HOMECARE_DURATION_HOURS;
        final hourlyRate = state.hourlyRate ?? 0;
        final totalHourlyCost = hourlyRate * HOMECARE_DURATION_HOURS;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Billing Option',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: RadioGroup<BillingType>(
                groupValue: state.billingType,
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<HomecareAppointmentFlowBloc>()
                        .add(BillingTypeChanged(value));
                  }
                },
                child: Column(
                  children: [
                    RadioListTile<BillingType>(
                      title: const Text('Hourly Rate',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          )),
                      subtitle: Text(
                          '\$${totalHourlyCost.toStringAsFixed(2)} (2 Hours)',
                          style: const TextStyle(
                            fontSize: 12,
                          )),
                      value: BillingType.hourly,
                      groupValue: state.billingType,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<HomecareAppointmentFlowBloc>()
                              .add(BillingTypeChanged(value));
                        }
                      },
                      activeColor: Const.aqua,
                    ),
                    const Divider(height: 1),
                    RadioListTile<BillingType>(
                      title: const Text('Use Subscription Balance',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          )),
                      subtitle: Text(
                        canUseSubscription
                            ? 'Deduct 2 Hours (Balance: $subscriptionBalance h)'
                            : 'Insufficient Balance ($subscriptionBalance h)',
                        style: TextStyle(
                          color: canUseSubscription ? null : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                      value: BillingType.subscription,
                      enabled: canUseSubscription,
                      activeColor: Const.aqua,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: ElevatedButton(
        onPressed:
            state.submissionStatus == AppointmentSubmissionStatus.submitting
                ? null
                : () {
                    context
                        .read<HomecareAppointmentFlowBloc>()
                        .add(const SubmitAppointment());
                  },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35C5CF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.submissionStatus == AppointmentSubmissionStatus.submitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
