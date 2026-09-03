part of 'care_task_detail_cubit.dart';

@immutable
abstract class CareTaskDetailState {}

class CareTaskDetailInitial extends CareTaskDetailState {}

class CareTaskDetailLoading extends CareTaskDetailState {}

class CareTaskDetailLoaded extends CareTaskDetailState {
  final PatientCareTaskDetail detail;
  CareTaskDetailLoaded(this.detail);
}

class CareTaskDetailError extends CareTaskDetailState {
  final String message;
  CareTaskDetailError(this.message);
}

/// What came of asking again. `nobodyAvailable` is not an error — the booking
/// survives it untouched, which is the whole point of a retry.
enum CareTaskRetryOutcome { asked, nobodyAvailable, failed }
