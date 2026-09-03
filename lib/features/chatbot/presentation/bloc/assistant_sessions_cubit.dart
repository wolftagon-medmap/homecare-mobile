import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_session_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_sessions_state.dart';

class AssistantSessionsCubit extends Cubit<AssistantSessionsState> {
  final AssistantSessionRepository repository;
  final String? currentSessionId;

  AssistantSessionsCubit({
    required this.repository,
    this.currentSessionId,
  }) : super(const AssistantSessionsLoading());

  Future<void> load() async {
    emit(const AssistantSessionsLoading());
    final result = await repository.sessions();
    result.fold(
      (failure) {
        log('sessions failed', name: 'chatbot.sessions', error: failure);
        emit(AssistantSessionsFailed(failure.message));
      },
      (sessions) => emit(AssistantSessionsLoaded(sessions)),
    );
  }

  Future<void> delete(String id) async {
    final current = state;
    if (current is! AssistantSessionsLoaded) return;
    emit(AssistantSessionsLoaded(
      current.sessions.where((session) => session.id != id).toList(),
    ));
    final result = await repository.delete(id);
    await result.fold(
      (failure) async {
        log('delete failed', name: 'chatbot.sessions', error: failure);
        await load();
      },
      (_) async {},
    );
  }
}
