part of 'schedule_physiotherapy_appointment_cubit.dart';

class SchedulePhysiotherapyAppointmentState extends Equatable {
  final ActionStatus status; // for fetching available time slots
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final String? errorMessage; // error for fetching slots

  final int? duration;

  const SchedulePhysiotherapyAppointmentState({
    this.status = ActionStatus.initial,
    this.slots = const [],
    this.selectedSlot,
    this.errorMessage,
    this.duration,
  });

  SchedulePhysiotherapyAppointmentState copyWith({
    ActionStatus? status,
    List<TimeSlot>? slots,
    TimeSlot? selectedSlot,
    String? errorMessage,
    int? duration,
  }) {
    return SchedulePhysiotherapyAppointmentState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      errorMessage: errorMessage ?? this.errorMessage,
      duration: duration ?? this.duration,
    );
  }

  factory SchedulePhysiotherapyAppointmentState.initial() {
    return const SchedulePhysiotherapyAppointmentState();
  }

  factory SchedulePhysiotherapyAppointmentState.loading() {
    return const SchedulePhysiotherapyAppointmentState(
        status: ActionStatus.loading);
  }

  factory SchedulePhysiotherapyAppointmentState.success({
    required List<TimeSlot> slots,
    TimeSlot? selectedSlot,
  }) {
    return SchedulePhysiotherapyAppointmentState(
      status: ActionStatus.success,
      slots: slots,
      selectedSlot: selectedSlot,
    );
  }

  factory SchedulePhysiotherapyAppointmentState.error(String errorMessage) {
    return SchedulePhysiotherapyAppointmentState(
      status: ActionStatus.error,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        slots,
        selectedSlot,
        errorMessage,
        duration,
      ];
}
