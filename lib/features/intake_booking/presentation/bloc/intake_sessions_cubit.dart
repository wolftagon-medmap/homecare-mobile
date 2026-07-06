import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/intake_booking/domain/entities/session_summary.dart';
import 'package:m2health/features/intake_booking/domain/repositories/intake_repository.dart';

part 'intake_sessions_state.dart';

/// Drives the booking-chat session-history list: load and delete. Only past
/// (non-active) sessions are deletable — the backend enforces it too.
class IntakeSessionsCubit extends Cubit<IntakeSessionsState> {
  final IntakeRepository _repository;

  IntakeSessionsCubit({required IntakeRepository repository})
      : _repository = repository,
        super(const IntakeSessionsLoading());

  Future<void> load() async {
    emit(const IntakeSessionsLoading());
    try {
      final sessions = await _repository.listSessions();
      emit(IntakeSessionsLoaded(sessions));
    } catch (e, stackTrace) {
      log('Error loading intake sessions: $e',
          name: 'IntakeSessionsCubit', error: e, stackTrace: stackTrace);
      emit(const IntakeSessionsError('Failed to load conversations'));
    }
  }

  Future<void> delete(String sessionId) async {
    final current = state;
    if (current is! IntakeSessionsLoaded) return;
    // Optimistic removal; reload restores the truth on failure.
    emit(IntakeSessionsLoaded(
        current.sessions.where((s) => s.id != sessionId).toList()));
    try {
      await _repository.deleteSession(sessionId);
    } catch (e, stackTrace) {
      log('Error deleting intake session: $e',
          name: 'IntakeSessionsCubit', error: e, stackTrace: stackTrace);
      await load();
    }
  }
}
