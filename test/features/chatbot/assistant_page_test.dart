import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/services/ai_tools_service.dart';
import 'package:m2health/features/chatbot/data/models/assistant_block_model.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session_summary.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/pages/ai_assistant_page.dart';
import 'package:m2health/features/chatbot/presentation/pages/assistant_session_viewer_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes/fake_assistant_repository.dart';
import 'fixtures/contract_blocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAssistantRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'ai_consent_accepted': true});
    await sl.reset();
    sl.registerFactory(
      () => VoiceInputCubit(aiToolsService: AIToolsService(Dio())),
    );
    repository = FakeAssistantRepository();
  });

  tearDown(() async {
    await repository.closeStream();
    await sl.reset();
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Future<void> answered(WidgetTester tester) async {
    repository.push(assistantBlockFromJson(assistantTextJson));
    await settle(tester);
  }

  Future<void> tap(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label));
    await tester.pump();
    await tester.tap(find.text(label));
    await settle(tester);
  }

  Future<AssistantCubit> pumpAssistant(WidgetTester tester) async {
    useTallScreen(tester);
    final cubit = AssistantCubit(repository: repository);
    addTearDown(cubit.close);
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: BlocProvider<AssistantCubit>.value(
            value: cubit,
            child: const AiAssistantPage(),
          ),
        ),
      ),
    );
    await settle(tester);
    return cubit;
  }

  testWidgets('the topic grid shows the hero and all eight topics',
      (tester) async {
    repository.historyBlocks = [assistantBlockFromJson(topicGridJson)];
    await pumpAssistant(tester);

    expect(find.textContaining('Health Assistant'), findsOneWidget);
    expect(find.text('What can I help you with today?'), findsOneWidget);
    expect(find.text('I have a symptom'), findsOneWidget);
    expect(find.text('Something else'), findsOneWidget);
    expect(find.text('Or type your question here...'), findsOneWidget);
  });

  testWidgets('an empty history still shows the hero and the composer',
      (tester) async {
    await pumpAssistant(tester);

    expect(find.textContaining('Health Assistant'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_outlined), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('tapping a topic sends topic:<code>', (tester) async {
    repository.historyBlocks = [assistantBlockFromJson(topicGridJson)];
    await pumpAssistant(tester);

    await tap(tester, 'I have a symptom');

    expect(repository.sentReplies.single.replyId, 'topic:symptom');
    expect(repository.sentReplies.single.label, 'I have a symptom');
    await answered(tester);
  });

  testWidgets('a streamed question renders and tapping an option sends it',
      (tester) async {
    repository.historyBlocks = [assistantBlockFromJson(topicGridJson)];
    await pumpAssistant(tester);

    await tap(tester, 'I have a symptom');
    repository.push(assistantBlockFromJson(singleQuestionJson));
    await settle(tester);

    expect(find.text('When do you usually feel dizzy?'), findsOneWidget);
    expect(find.text('When walking'), findsOneWidget);

    await tap(tester, 'When walking');

    expect(repository.sentReplies.last.replyId, 'hc:q1:1');
    expect(repository.sentReplies.last.label, 'When walking');
    await answered(tester);
  });

  testWidgets('guidance renders the disclaimer', (tester) async {
    repository.historyBlocks = [assistantBlockFromJson(guidanceJson)];
    await pumpAssistant(tester);

    expect(find.text('General guidance'), findsOneWidget);
    expect(find.textContaining('not a diagnosis'), findsOneWidget);
    expect(find.text('Medication Support'), findsOneWidget);
  });

  testWidgets('a confirm request shows Confirm and Cancel', (tester) async {
    repository.historyBlocks = [assistantBlockFromJson(confirmRequestJson)];
    await pumpAssistant(tester);

    await tap(tester, 'Confirm');

    expect(repository.sentReplies.single.replyId, 'confirm:abc');
    expect(repository.sentReplies.single.label, 'Confirm');
    await answered(tester);
  });

  testWidgets('a past conversation is read-only and sends nothing',
      (tester) async {
    useTallScreen(tester);
    repository.historyBlocks = [assistantBlockFromJson(topicGridJson)];
    final cubit = AssistantCubit(repository: repository);
    addTearDown(cubit.close);

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: BlocProvider<AssistantCubit>.value(
            value: cubit,
            child: const AssistantSessionViewerPage(
              session: AssistantSessionSummary(
                id: 'old',
                active: false,
                preview: 'dizzy',
                lastMessageAt: null,
                createdAt: null,
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);

    expect(find.text('I have a symptom'), findsOneWidget);
    expect(find.text('This conversation is read-only.'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tap(tester, 'I have a symptom');

    expect(repository.sentReplies, isEmpty);
    expect(repository.historyRequests, ['old']);
  });
}
