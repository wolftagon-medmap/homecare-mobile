import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/services/ai_tools_service.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/injection.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';
import 'package:m2health/features/chatbot/presentation/pages/ai_assistant_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Drives the assistant through the app's real `get_it` graph rather than
/// hand-built collaborators, because the wiring is what the widget tests cannot
/// see: a registration missing from `initChatbotModule` compiles perfectly and
/// throws the moment a screen opens.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'ai_consent_accepted': true});
    await sl.reset();
    sl.registerFactory(
      () => VoiceInputCubit(aiToolsService: AIToolsService(Dio())),
    );
    initChatbotModule(sl);
  });

  tearDown(() => sl.reset());

  Future<AssistantCubit> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final cubit = sl<AssistantCubit>();
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
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('the assistant resolves from the real service locator',
      (tester) async {
    final cubit = await pump(tester);

    expect(cubit.state, isA<AssistantReady>());
    expect(find.text('What can I help you with today?'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_outlined), findsOneWidget);
    await cubit.close();
  });

  testWidgets('a finished conversation opens read-only from history',
      (tester) async {
    final cubit = await pump(tester);

    await tester.tap(find.text('I have a symptom'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Dizziness'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dizziness'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_comment_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start new'));
    await tester.pumpAndSettle();

    expect(
      (cubit.state as AssistantReady).blocks.single,
      isA<TopicGridBlock>(),
    );

    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    expect(find.text('Conversation History'), findsOneWidget);
    final saved = find.text('I have a symptom');
    expect(saved, findsOneWidget);

    await tester.tap(saved);
    await tester.pumpAndSettle();

    expect(find.text('Read-only'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text("I've been feeling dizzy for the past few days."),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('When do you usually feel dizzy?'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Dizziness'),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Dizziness'), findsWidgets);
    await cubit.close();
  });
}
