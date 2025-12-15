import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/homecare_elderly/domain/entities/billing_type.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/create_homecare_appointment.dart';

part 'homecare_appointment_flow_event.dart';
part 'homecare_appointment_flow_state.dart';

class HomecareAppointmentFlowBloc
    extends Bloc<HomecareAppointmentFlowEvent, HomecareAppointmentFlowState> {
  final CreateHomecareAppointment createHomecareAppointment;

  HomecareAppointmentFlowBloc({
    required this.createHomecareAppointment,
  }) : super(const HomecareAppointmentFlowState(selectedTasks: [])) {
    on<FlowStarted>(_onFlowStarted);
    on<FlowStepChanged>(_onStepChanged);
    on<ProviderSelected>(_onProviderSelected);
    on<TimeSlotSelected>(_onTimeSlotSelected);
    on<BillingTypeChanged>(_onBillingTypeChanged);
    on<SubmitAppointment>(_onSubmitAppointment);
  }

  void _onFlowStarted(
      FlowStarted event, Emitter<HomecareAppointmentFlowState> emit) {
    emit(state.copyWith(selectedTasks: event.tasks));
  }

  void _onStepChanged(
      FlowStepChanged event, Emitter<HomecareAppointmentFlowState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onProviderSelected(
      ProviderSelected event, Emitter<HomecareAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedProvider: event.professional,
      currentStep: HomecareFlowStep.professionalDetails,
    ));
  }

  void _onTimeSlotSelected(
      TimeSlotSelected event, Emitter<HomecareAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedTimeSlot: event.slot,
      currentStep: HomecareFlowStep.review,
    ));
  }

  void _onBillingTypeChanged(
      BillingTypeChanged event, Emitter<HomecareAppointmentFlowState> emit) {
    emit(state.copyWith(billingType: event.billingType));
  }

  void _onSubmitAppointment(
      SubmitAppointment event, Emitter<HomecareAppointmentFlowState> emit) async {
    emit(state.copyWith(
        submissionStatus: AppointmentSubmissionStatus.submitting));

    log('Submitting Homecare Appointment:');
    log('Tasks: ${state.selectedTasks}');
    log('Provider: ${state.selectedProvider?.id}');
    log('Time: ${state.selectedTimeSlot}');
    log('Billing: ${state.billingType}');

    if (state.selectedProvider == null || state.selectedTimeSlot == null) {
      emit(state.copyWith(
        submissionStatus: AppointmentSubmissionStatus.failure,
        errorMessage: 'Provider or Time Slot not selected.',
      ));
      return;
    }

    final params = CreateHomecareAppointmentParams(
      providerId: state.selectedProvider!.id,
      startDatetime: state.selectedTimeSlot!.startTime,
      tasks: state.selectedTasks,
      billingType: state.billingType,
    );

    final result = await createHomecareAppointment(params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: AppointmentSubmissionStatus.failure,
          errorMessage: 'Failed to create appointment:\n${failure.message}',
        ));
      },
      (appointment) {
        emit(state.copyWith(
          submissionStatus: AppointmentSubmissionStatus.success,
          createdAppointment: appointment,
        ));
      },
    );
  }

  @override
  void onEvent(HomecareAppointmentFlowEvent event) {
    super.onEvent(event);
    log('HomecareAppointmentFlowBloc Event: $event');
  }
}