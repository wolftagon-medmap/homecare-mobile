import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/chatbot/data/datasources/assistant_script_datasource.dart';
import 'package:m2health/features/chatbot/data/repositories/assistant_repository_impl.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';
import 'package:m2health/features/chatbot/presentation/pages/ai_assistant_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

AssistantCubit buildCubit() => AssistantCubit(
      repository: AssistantRepositoryImpl(
        source: const AssistantScriptLocalDataSource(),
      ),
    );

AssistantReady ready(AssistantCubit cubit) => cubit.state as AssistantReady;

int lastId(AssistantCubit cubit) => ready(cubit).blocks.last.id;

/// Drives the scripted dizziness path from the welcome grid to the next-step
/// menu, returning the text of every block produced along the way.
List<String> tapThroughOnce(AssistantCubit cubit) {
  cubit.choose(lastId(cubit), 'topic_symptom');
  cubit.choose(lastId(cubit), 'sym_dizzy');
  cubit.choose(lastId(cubit), 'onset_standing');

  final symptoms = lastId(cubit);
  cubit.toggle(symptoms, 'sx_headache');
  cubit.toggle(symptoms, 'sx_palpitations');
  cubit.submitSelection(symptoms);

  cubit.choose(lastId(cubit), 'med_bp');
  cubit.choose(lastId(cubit), 'for_self');

  final summaryId = ready(cubit).blocks.whereType<SummaryBlock>().last.id;
  cubit.choose(summaryId, 'summary_ok');

  return ready(cubit).blocks.map(describe).toList();
}

String describe(AssistantBlock block) => switch (block) {
      AssistantTextBlock(:final text) => 'assistant:$text',
      UserTextBlock(:final text) => 'user:$text',
      TopicGridBlock(:final title) => 'topics:$title',
      SingleChoiceBlock(:final prompt) => 'single:$prompt',
      MultiChoiceBlock(:final prompt) => 'multi:$prompt',
      SummaryBlock(:final title) => 'summary:$title',
      GuidanceBlock(:final title) => 'guidance:$title',
      NextStepBlock() => 'next_step',
      UnknownAssistantBlock(:final kind) => 'unknown:$kind',
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AssistantCubit', () {
    test('the scripted path produces the same transcript twice', () async {
      final cubit = buildCubit();
      await cubit.start();

      final first = tapThroughOnce(cubit);

      final restart = ready(cubit)
          .blocks
          .whereType<NextStepBlock>()
          .last
          .actions
          .firstWhere((action) => action.restart);
      cubit.act(restart);

      expect(ready(cubit).blocks.length, 1);
      expect(ready(cubit).blocks.single, isA<TopicGridBlock>());

      final second = tapThroughOnce(cubit);

      expect(second, first);
      expect(first.where((entry) => entry.startsWith('summary:')).length, 1);
      expect(first.where((entry) => entry == 'next_step').length, 1);
      await cubit.close();
    });

    test('a question cannot be answered twice', () async {
      final cubit = buildCubit();
      await cubit.start();

      final grid = lastId(cubit);
      cubit.choose(grid, 'topic_symptom');
      final afterFirst = ready(cubit).blocks.length;

      cubit.choose(grid, 'topic_lifestyle');

      expect(ready(cubit).blocks.length, afterFirst);
      await cubit.close();
    });

    test('the summary reflects the answers actually given', () async {
      final cubit = buildCubit();
      await cubit.start();

      cubit.choose(lastId(cubit), 'topic_symptom');
      cubit.choose(lastId(cubit), 'sym_dizzy');
      cubit.choose(lastId(cubit), 'onset_walking');
      final symptoms = lastId(cubit);
      cubit.toggle(symptoms, 'sx_none');
      cubit.submitSelection(symptoms);
      cubit.choose(lastId(cubit), 'med_none');
      cubit.choose(lastId(cubit), 'for_other');

      expect(ready(cubit).answers['onset'], 'When walking');
      expect(ready(cubit).answers['symptoms'], 'None of the above');
      expect(ready(cubit).answers['history'], 'No regular medication');
      await cubit.close();
    });

    test('an exclusive option clears the other ticks', () async {
      final cubit = buildCubit();
      await cubit.start();

      cubit.choose(lastId(cubit), 'topic_symptom');
      cubit.choose(lastId(cubit), 'sym_dizzy');
      cubit.choose(lastId(cubit), 'onset_standing');

      final symptoms = lastId(cubit);
      cubit.toggle(symptoms, 'sx_nausea');
      cubit.toggle(symptoms, 'sx_none');

      expect(ready(cubit).selections[symptoms], ['sx_none']);
      await cubit.close();
    });

    test('every reachable step exists and no branch dead-ends', () async {
      final cubit = buildCubit();
      await cubit.start();

      final topics = (ready(cubit).blocks.single as TopicGridBlock).topics;

      for (final topic in topics) {
        cubit.restart();
        cubit.choose(lastId(cubit), topic.replyId);
        expect(
          ready(cubit).blocks.length,
          greaterThan(1),
          reason: '${topic.replyId} produced no follow-up',
        );
      }
      await cubit.close();
    });

    test('free text at the welcome step enters the scripted path', () async {
      final cubit = buildCubit();
      await cubit.start();

      cubit.sendText('I feel dizzy');

      expect(ready(cubit).blocks.whereType<SingleChoiceBlock>(), isNotEmpty);
      await cubit.close();
    });

    test('free text mid-flow answers without advancing', () async {
      final cubit = buildCubit();
      await cubit.start();

      cubit.choose(lastId(cubit), 'topic_symptom');
      cubit.choose(lastId(cubit), 'sym_dizzy');
      final before = ready(cubit).blocks.whereType<SingleChoiceBlock>().length;

      cubit.sendText('is this serious?');

      expect(
        ready(cubit).blocks.whereType<SingleChoiceBlock>().length,
        before,
      );
      expect(ready(cubit).blocks.last, isA<AssistantTextBlock>());
      await cubit.close();
    });
  });

  group('AiAssistantPage', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({'ai_consent_accepted': true});
    });

    Future<void> pumpPage(
      WidgetTester tester,
      AssistantCubit cubit, {
      Key? key,
    }) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: BlocProvider<AssistantCubit>.value(
              key: key,
              value: cubit,
              child: AiAssistantPage(key: key),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders the welcome screen and taps into the script',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final cubit = buildCubit();
      await pumpPage(tester, cubit);

      expect(find.text('What can I help you with today?'), findsOneWidget);
      expect(find.text('I have a symptom'), findsOneWidget);
      expect(find.text('Important'), findsOneWidget);

      await tester.tap(find.text('I have a symptom'));
      await tester.pumpAndSettle();

      expect(find.text('Dizziness'), findsOneWidget);
      await cubit.close();
    });

    testWidgets('the whole flow renders twice from a cold page',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      for (var pass = 0; pass < 2; pass++) {
        final cubit = buildCubit();
        await pumpPage(tester, cubit, key: ValueKey<int>(pass));

        expect(
          find.text('What can I help you with today?'),
          findsOneWidget,
          reason: 'welcome screen missing on pass \$pass',
        );

        tapThroughOnce(cubit);
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.text('General guidance'),
          -300,
          scrollable: find.byType(Scrollable).first,
        );
        expect(
          find.text('General guidance'),
          findsOneWidget,
          reason: 'guidance missing on pass \$pass',
        );

        await tester.scrollUntilVisible(
          find.text('Ask Another Question'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Ask Another Question'), findsOneWidget);
        await cubit.close();
      }
    });
  });
}
