part of 'screening_appointment_action_cubit.dart';

sealed class ScreeningAppointmentActionState extends Equatable {
  const ScreeningAppointmentActionState();

  @override
  List<Object?> get props => [];
}

final class ScreeningAppointmentActionInitial
    extends ScreeningAppointmentActionState {}

final class ScreeningAppointmentActionLoading
    extends ScreeningAppointmentActionState {}

final class ScreeningAppointmentActionSuccess
    extends ScreeningAppointmentActionState {
  final String? message;
  const ScreeningAppointmentActionSuccess({this.message});
  @override
  List<Object?> get props => [message];
}

final class ScreeningAppointmentActionError
    extends ScreeningAppointmentActionState {
  final String message;
  const ScreeningAppointmentActionError(this.message);
  @override
  List<Object?> get props => [message];
}
