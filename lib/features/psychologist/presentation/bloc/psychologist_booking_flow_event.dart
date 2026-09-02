part of 'psychologist_booking_flow_bloc.dart';

sealed class PsychologistBookingFlowEvent extends Equatable {
  const PsychologistBookingFlowEvent();

  @override
  List<Object?> get props => [];
}

class PsychologistFlowProfessionalSelected extends PsychologistBookingFlowEvent {
  final ProfessionalEntity professional;
  const PsychologistFlowProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class PsychologistFlowTimeSlotSelected extends PsychologistBookingFlowEvent {
  final TimeSlot slot;
  const PsychologistFlowTimeSlotSelected(this.slot);
  @override
  List<Object> get props => [slot];
}
