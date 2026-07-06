part of 'patient_inbox_cubit.dart';

@immutable
abstract class PatientInboxState {}

class PatientInboxInitial extends PatientInboxState {}

class PatientInboxLoading extends PatientInboxState {}

class PatientInboxLoaded extends PatientInboxState {
  final List<PatientInboxItem> items;
  PatientInboxLoaded(this.items);
}

class PatientInboxActionSucceed extends PatientInboxState {
  final String message;
  PatientInboxActionSucceed(this.message);
}

class PatientInboxError extends PatientInboxState {
  final String message;
  PatientInboxError(this.message);
}
