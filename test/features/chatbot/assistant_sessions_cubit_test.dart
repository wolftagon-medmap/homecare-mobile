import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session_summary.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_sessions_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_sessions_state.dart';

import 'fakes/fake_assistant_repository.dart';

void main() {
  final active = AssistantSessionSummary(
    id: 'a',
    active: true,
    preview: 'I feel dizzy',
    lastMessageAt: DateTime.utc(2026, 10, 1),
    createdAt: DateTime.utc(2026, 9, 30),
  );
  const archived = AssistantSessionSummary(
    id: 'b',
    active: false,
    preview: null,
    lastMessageAt: null,
    createdAt: null,
  );

  late FakeAssistantRepository repository;
  late AssistantSessionsCubit cubit;

  setUp(() {
    repository = FakeAssistantRepository()..sessionList = [active, archived];
    cubit = AssistantSessionsCubit(
      repository: repository,
      currentSessionId: 'a',
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.closeStream();
  });

  test('load maps the server summaries', () async {
    await cubit.load();

    expect(cubit.state, AssistantSessionsLoaded([active, archived]));
  });

  test('delete calls the repository and reloads', () async {
    await cubit.load();

    await cubit.delete('b');

    expect(repository.deletedSessions, ['b']);
    expect(cubit.state, AssistantSessionsLoaded([active]));
  });

  test('a failed delete reloads the list', () async {
    await cubit.load();
    repository.failDelete = true;

    await cubit.delete('b');

    expect(repository.deletedSessions, ['b']);
    expect(cubit.state, AssistantSessionsLoaded([active, archived]));
  });

  test('a failed load shows the failed state', () async {
    repository.failSessions = true;

    await cubit.load();

    expect(cubit.state, const AssistantSessionsFailed('sessions failed'));
  });
}
