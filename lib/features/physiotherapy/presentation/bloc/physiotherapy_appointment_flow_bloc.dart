import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/physiotherapy/const.dart';
import 'package:m2health/features/physiotherapy/domain/usecases/create_physiotherapy_appointment.dart';

part 'physiotherapy_appointment_flow_event.dart';
part 'physiotherapy_appointment_flow_state.dart';

class PhysiotherapyAppointmentFlowBloc extends Bloc<
    PhysiotherapyAppointmentFlowEvent, PhysiotherapyAppointmentFlowState> {
  final CreatePhysiotherapyAppointment createPhysiotherapyAppointment;

  PhysiotherapyAppointmentFlowBloc({
    required this.createPhysiotherapyAppointment,
    required PhysiotherapyType type,
  }) : super(PhysiotherapyAppointmentFlowState.initial(type)) {
    on<FlowStepChanged>(_onStepChanged);
    on<FlowProfessionalSelected>(_onProfessionalSelected);
    on<FlowTimeSlotSelected>(_onTimeSlotSelected);
    on<FlowSubmitAppointment>(_onSubmitAppointment);
  }

  void _onStepChanged(
      FlowStepChanged event, Emitter<PhysiotherapyAppointmentFlowState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onProfessionalSelected(FlowProfessionalSelected event,
      Emitter<PhysiotherapyAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedProfessional: event.professional,
      currentStep: PhysiotherapyFlowStep.viewProfessionalDetail,
    ));
  }

  void _onTimeSlotSelected(FlowTimeSlotSelected event,
      Emitter<PhysiotherapyAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedTimeSlot: event.timeSlot,
      selectedDuration: event.duration,
    ));
    add(FlowSubmitAppointment());
  }

  void _onSubmitAppointment(FlowSubmitAppointment event,
      Emitter<PhysiotherapyAppointmentFlowState> emit) async {
    emit(state.copyWith(
        submissionStatus: AppointmentSubmissionStatus.submitting));

    final typeString = state.type == PhysiotherapyType.musculoskeletal
        ? 'musculoskeletal'
        : 'neurological';
    final serviceCode =
        'physiotherapy.$typeString.${state.selectedDuration}_minutes';

    final params = CreatePhysiotherapyAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!,
      duration: state.selectedDuration!,
      serviceCode: serviceCode,
    );

    final result = await createPhysiotherapyAppointment(params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: AppointmentSubmissionStatus.failure,
          errorMessage: failure.message,
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
}
