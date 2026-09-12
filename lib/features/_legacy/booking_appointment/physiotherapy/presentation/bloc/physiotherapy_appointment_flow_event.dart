part of 'physiotherapy_appointment_flow_bloc.dart';

sealed class PhysiotherapyAppointmentFlowEvent extends Equatable {
  const PhysiotherapyAppointmentFlowEvent();

  @override
  List<Object?> get props => [];
}

class FlowStepChanged extends PhysiotherapyAppointmentFlowEvent {
  final PhysiotherapyFlowStep step;
  const FlowStepChanged(this.step);
  @override
  List<Object> get props => [step];
}

class FlowProfessionalSelected extends PhysiotherapyAppointmentFlowEvent {
  final ProfessionalEntity professional;
  const FlowProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class FlowTimeSlotSelected extends PhysiotherapyAppointmentFlowEvent {
  final DateTime timeSlot;
  final int duration;
  const FlowTimeSlotSelected(this.timeSlot, this.duration);
  @override
  List<Object> get props => [timeSlot, duration];
}

class FlowSubmitAppointment extends PhysiotherapyAppointmentFlowEvent {}
