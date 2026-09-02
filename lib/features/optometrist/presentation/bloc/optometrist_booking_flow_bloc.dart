import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/optometrist/domain/usecases/create_optometry_appointment.dart';

part 'optometrist_booking_flow_event.dart';
part 'optometrist_booking_flow_state.dart';

class OptometristBookingFlowBloc
    extends Bloc<OptometristBookingFlowEvent, OptometristBookingFlowState> {
  final CreateOptometryAppointment _createAppointment;

  OptometristBookingFlowBloc({
    required CreateOptometryAppointment createAppointment,
  })  : _createAppointment = createAppointment,
        super(const OptometristBookingFlowState()) {
    on<OptometristFlowProfessionalSelected>(_onProfessionalSelected);
    on<OptometristFlowTimeSlotSelected>(_onTimeSlotSelected);
  }

  void _onProfessionalSelected(
    OptometristFlowProfessionalSelected event,
    Emitter<OptometristBookingFlowState> emit,
  ) {
    emit(state.copyWith(selectedProfessional: event.professional));
  }

  Future<void> _onTimeSlotSelected(
    OptometristFlowTimeSlotSelected event,
    Emitter<OptometristBookingFlowState> emit,
  ) async {
    emit(state.copyWith(isBookingAppointment: true, clearError: true));

    final params = CreateOptometryAppointmentParams(
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
