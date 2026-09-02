import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/psychologist/domain/usecases/create_psychology_appointment.dart';

part 'psychologist_booking_flow_event.dart';
part 'psychologist_booking_flow_state.dart';

class PsychologistBookingFlowBloc
    extends Bloc<PsychologistBookingFlowEvent, PsychologistBookingFlowState> {
  final CreatePsychologyAppointment _createAppointment;

  PsychologistBookingFlowBloc({
    required CreatePsychologyAppointment createAppointment,
  })  : _createAppointment = createAppointment,
        super(const PsychologistBookingFlowState()) {
    on<PsychologistFlowProfessionalSelected>(_onProfessionalSelected);
    on<PsychologistFlowTimeSlotSelected>(_onTimeSlotSelected);
  }

  void _onProfessionalSelected(
    PsychologistFlowProfessionalSelected event,
    Emitter<PsychologistBookingFlowState> emit,
  ) {
    emit(state.copyWith(selectedProfessional: event.professional));
  }

  Future<void> _onTimeSlotSelected(
    PsychologistFlowTimeSlotSelected event,
    Emitter<PsychologistBookingFlowState> emit,
  ) async {
    emit(state.copyWith(isBookingAppointment: true, clearError: true));

    final params = CreatePsychologyAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: event.slot.startTime,
    );

    final result = await _createAppointment(params);
    result.fold(
      (failure) => emit(state.copyWith(
        isBookingAppointment: false,
        errorMessage: failure.message,
      )),
      (appointment) => emit(state.copyWith(
        isBookingAppointment: false,
        createdAppointment: appointment,
      )),
    );
  }
}
