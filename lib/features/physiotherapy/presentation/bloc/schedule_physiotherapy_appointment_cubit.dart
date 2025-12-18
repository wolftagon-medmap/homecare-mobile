import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/repositories/schedule_appointment_repository.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/usecases/get_available_time_slot.dart';

part 'schedule_physiotherapy_appointment_state.dart';

class SchedulePhysiotherapyAppointmentCubit
    extends Cubit<SchedulePhysiotherapyAppointmentState> {
  final ScheduleAppointmentRepository repository;

  static const String SERVICE_TYPE = "physiotherapy";

  SchedulePhysiotherapyAppointmentCubit({
    required this.repository,
  }) : super(const SchedulePhysiotherapyAppointmentState());

  Future<void> fetchSlots({
    required int providerId,
    required DateTime date,
  }) async {
    emit(SchedulePhysiotherapyAppointmentState.loading());

    final params = GetAvailableTimeSlotsParams(
      providerId: providerId,
      date: date,
      serviceType: SERVICE_TYPE,
    );
    final result = await repository.getAvailableTimeSlots(params);

    result.fold(
      (failure) =>
          emit(SchedulePhysiotherapyAppointmentState.error(failure.message)),
      (slots) {
        List<TimeSlot> finalSlots = List<TimeSlot>.from(slots);
        TimeSlot? newSelectedSlot;

        emit(SchedulePhysiotherapyAppointmentState.success(
          slots: finalSlots,
          selectedSlot: newSelectedSlot,
        ));
      },
    );
  }

  void selectSlot(TimeSlot slot) {
    emit(state.copyWith(selectedSlot: slot));
  }

  void selectDuration(int duration) {
    emit(state.copyWith(duration: duration));
  }
}
