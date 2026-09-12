part of 'psychologist_booking_flow_bloc.dart';

class PsychologistBookingFlowState extends Equatable {
  final ProfessionalEntity? selectedProfessional;
  final bool isBookingAppointment;
  final AppointmentEntity? createdAppointment;
  final String? errorMessage;

  const PsychologistBookingFlowState({
    this.selectedProfessional,
    this.isBookingAppointment = false,
    this.createdAppointment,
    this.errorMessage,
  });

  PsychologistBookingFlowState copyWith({
    ProfessionalEntity? selectedProfessional,
    bool? isBookingAppointment,
    AppointmentEntity? createdAppointment,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PsychologistBookingFlowState(
      selectedProfessional: selectedProfessional ?? this.selectedProfessional,
      isBookingAppointment: isBookingAppointment ?? this.isBookingAppointment,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        selectedProfessional,
        isBookingAppointment,
        createdAppointment,
        errorMessage,
      ];
}
