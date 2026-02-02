import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/smoking_cessation_form.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/usecases/create_pharmacy_appointment.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

part 'smoking_cessation_flow_state.dart';

class SmokingCessationFlowCubit extends Cubit<SmokingCessationFlowState> {
  final CreatePharmacyAppointment createPharmacyAppointment;

  SmokingCessationFlowCubit({
    required this.createPharmacyAppointment,
  }) : super(const SmokingCessationFlowState());

  void setStep(SmokingCessationFlowStep step) {
    emit(state.copyWith(currentStep: step));
  }

  void updateForm(SmokingCessationForm form) {
    emit(state.copyWith(
      form: form,
      currentStep: SmokingCessationFlowStep.searchProfessional,
    ));
  }

  void selectProfessional(ProfessionalEntity professional) {
    emit(state.copyWith(
      selectedProfessional: professional,
      currentStep: SmokingCessationFlowStep.professionalDetail,
    ));
  }

  void selectTimeSlot(DateTime timeSlot) {
    emit(state.copyWith(selectedTimeSlot: timeSlot));
    submitAppointment();
  }

  Future<void> submitAppointment() async {
    if (state.selectedProfessional == null || state.selectedTimeSlot == null) {
      return;
    }

    emit(state.copyWith(
        submissionStatus: SmokingCessationSubmissionStatus.submitting));

    final params = CreatePharmacyAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!,
      pharmacyCase: PharmacyCase(
        serviceType: 'smoking_cessation',
        smokingCessationForm: state.form,
      ),
    );

    final result = await createPharmacyAppointment(params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: SmokingCessationSubmissionStatus.failure,
          errorMessage: 'Failed to create appointment',
        ));
      },
      (appointment) {
        emit(state.copyWith(
          submissionStatus: SmokingCessationSubmissionStatus.success,
          createdAppointment: appointment,
        ));
      },
    );
  }
}
