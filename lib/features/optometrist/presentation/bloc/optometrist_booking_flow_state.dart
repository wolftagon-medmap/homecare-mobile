part of 'optometrist_booking_flow_bloc.dart';

class OptometristBookingFlowState extends Equatable {
  final ProfessionalEntity? selectedProfessional;
  final bool isBookingAppointment;
  final AppointmentEntity? createdAppointment;
  final String? errorMessage;

  const OptometristBookingFlowState({
    this.selectedProfessional,
    this.isBookingAppointment = false,
    this.createdAppointment,
    this.errorMessage,
  });

  OptometristBookingFlowState copyWith({
    ProfessionalEntity? selectedProfessional,
    bool? isBookingAppointment,
    AppointmentEntity? createdAppointment,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OptometristBookingFlowState(
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
