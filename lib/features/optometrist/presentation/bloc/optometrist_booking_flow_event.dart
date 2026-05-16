part of 'optometrist_booking_flow_bloc.dart';

sealed class OptometristBookingFlowEvent extends Equatable {
  const OptometristBookingFlowEvent();

  @override
  List<Object?> get props => [];
}

class OptometristFlowProfessionalSelected extends OptometristBookingFlowEvent {
  final ProfessionalEntity professional;
  const OptometristFlowProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class OptometristFlowTimeSlotSelected extends OptometristBookingFlowEvent {
  final TimeSlot slot;
  const OptometristFlowTimeSlotSelected(this.slot);
  @override
  List<Object> get props => [slot];
}
