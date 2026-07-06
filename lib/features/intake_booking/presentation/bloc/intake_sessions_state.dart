part of 'intake_sessions_cubit.dart';

sealed class IntakeSessionsState {
  const IntakeSessionsState();
}

class IntakeSessionsLoading extends IntakeSessionsState {
  const IntakeSessionsLoading();
}

class IntakeSessionsLoaded extends IntakeSessionsState {
  final List<IntakeSessionSummary> sessions;
  const IntakeSessionsLoaded(this.sessions);
}

class IntakeSessionsError extends IntakeSessionsState {
  final String message;
  const IntakeSessionsError(this.message);
}
