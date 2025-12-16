part of 'homecare_appointment_flow_bloc.dart';

abstract class HomecareAppointmentFlowEvent extends Equatable {
  const HomecareAppointmentFlowEvent();

  @override
  List<Object?> get props => [];
}

class FlowStarted extends HomecareAppointmentFlowEvent {
  final List<String> tasks;

  const FlowStarted(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class ProviderSelected extends HomecareAppointmentFlowEvent {
  final ProfessionalEntity professional;

  const ProviderSelected(this.professional);

  @override
  List<Object?> get props => [professional];
}

class TimeSlotSelected extends HomecareAppointmentFlowEvent {
  final TimeSlot slot;

  const TimeSlotSelected(this.slot);

  @override
  List<Object?> get props => [slot];
}

class BillingTypeChanged extends HomecareAppointmentFlowEvent {
  final BillingType billingType;

  const BillingTypeChanged(this.billingType);

  @override
  List<Object?> get props => [billingType];
}

class FlowStepChanged extends HomecareAppointmentFlowEvent {
  final HomecareFlowStep step;

  const FlowStepChanged(this.step);

  @override
  List<Object?> get props => [step];
}

class SubmitAppointment extends HomecareAppointmentFlowEvent {
  const SubmitAppointment();
}
