import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/second_opinion_imaging/domain/repositories/second_opinion_imaging_repository.dart';

part 'second_opinion_imaging_flow_state.dart';

sealed class SecondOpinionImagingFlowEvent extends Equatable {
  const SecondOpinionImagingFlowEvent();

  @override
  List<Object?> get props => [];
}

class FlowStepChanged extends SecondOpinionImagingFlowEvent {
  final SecondOpinionImagingFlowStep step;
  const FlowStepChanged(this.step);
  @override
  List<Object> get props => [step];
}

class FlowProfessionalSelected extends SecondOpinionImagingFlowEvent {
  final ProfessionalEntity professional;
  const FlowProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class FlowTimeSlotSelected extends SecondOpinionImagingFlowEvent {
  final DateTime timeSlot;
  const FlowTimeSlotSelected(this.timeSlot);
  @override
  List<Object> get props => [timeSlot];
}

class FlowFormSubmitted extends SecondOpinionImagingFlowEvent {
  final String diseaseName;
  final String? diseaseHistory;
  final String? biomarker;
  final List<SecondOpinionImageFile> images;

  const FlowFormSubmitted({
    required this.diseaseName,
    this.diseaseHistory,
    this.biomarker,
    this.images = const [],
  });

  @override
  List<Object?> get props => [diseaseName, diseaseHistory, biomarker, images];
}

class FlowSubmitAppointment extends SecondOpinionImagingFlowEvent {}

class SecondOpinionImagingFlowBloc extends Bloc<SecondOpinionImagingFlowEvent, SecondOpinionImagingFlowState> {
  final SecondOpinionImagingRepository repository;

  SecondOpinionImagingFlowBloc({
    required this.repository,
    required String serviceType,
  }) : super(SecondOpinionImagingFlowState.initial(serviceType)) {
    on<FlowStepChanged>(_onStepChanged);
    on<FlowFormSubmitted>(_onFormSubmitted);
    on<FlowProfessionalSelected>(_onProfessionalSelected);
    on<FlowTimeSlotSelected>(_onTimeSlotSelected);
    on<FlowSubmitAppointment>(_onSubmitAppointment);
  }

  void _onStepChanged(FlowStepChanged event, Emitter<SecondOpinionImagingFlowState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onFormSubmitted(FlowFormSubmitted event, Emitter<SecondOpinionImagingFlowState> emit) {
    emit(state.copyWith(
      diseaseName: event.diseaseName,
      diseaseHistory: event.diseaseHistory,
      biomarker: event.biomarker,
      images: event.images,
      currentStep: SecondOpinionImagingFlowStep.searchProfessional,
    ));
  }

  void _onProfessionalSelected(FlowProfessionalSelected event, Emitter<SecondOpinionImagingFlowState> emit) {
    emit(state.copyWith(
      selectedProfessional: event.professional,
      currentStep: SecondOpinionImagingFlowStep.viewProfessionalDetail,
    ));
  }

  void _onTimeSlotSelected(FlowTimeSlotSelected event, Emitter<SecondOpinionImagingFlowState> emit) {
    emit(state.copyWith(
      selectedTimeSlot: event.timeSlot,
    ));
    add(FlowSubmitAppointment());
  }

  void _onSubmitAppointment(FlowSubmitAppointment event, Emitter<SecondOpinionImagingFlowState> emit) async {
    emit(state.copyWith(submissionStatus: AppointmentSubmissionStatus.submitting));

    final params = CreateSecondOpinionImagingAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!,
      serviceType: state.serviceType,
      diseaseName: state.diseaseName!,
      diseaseHistory: state.diseaseHistory,
      biomarker: state.biomarker,
      images: state.images,
    );

    final result = await repository.createAppointment(params);
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
