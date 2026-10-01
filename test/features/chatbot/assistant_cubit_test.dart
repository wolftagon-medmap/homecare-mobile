import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/chatbot/data/models/assistant_block_model.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';

import 'fakes/fake_assistant_repository.dart';
import 'fixtures/contract_blocks.dart';

TopicGridBlock _grid() =>
    assistantBlockFromJson(topicGridJson) as TopicGridBlock;
QuestionBlock _single() =>
    assistantBlockFromJson(singleQuestionJson) as QuestionBlock;
QuestionBlock _multi() =>
    assistantBlockFromJson(multiQuestionJson) as QuestionBlock;
SummaryBlock _summary() => assistantBlockFromJson(summaryJson) as SummaryBlock;
GuidanceBlock _guidance() =>
    assistantBlockFromJson(guidanceJson) as GuidanceBlock;
NextStepBlock _nextStep() =>
    assistantBlockFromJson(nextStepJson) as NextStepBlock;
ConfirmRequestBlock _confirm() =>
    assistantBlockFromJson(confirmRequestJson) as ConfirmRequestBlock;

AssistantReady _ready(AssistantCubit cubit) => cubit.state as AssistantReady;

void main() {
  late FakeAssistantRepository repository;
  late AssistantCubit cubit;

  Future<void> startWith(List<AssistantBlock> history) async {
    repository.historyBlocks = history;
    await cubit.start();
    await pumpEventQueue();
  }

  setUp(() {
    repository = FakeAssistantRepository();
    cubit = AssistantCubit(repository: repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.closeStream();
  });

  test('start loads history and subscribes after the highest id', () async {
    await startWith([_grid()]);

    final state = _ready(cubit);
    expect(state.sessionId, 'session-1');
    expect(state.blocks, [_grid()]);
    expect(state.connected, isTrue);
    expect(state.readOnly, isFalse);
    expect(repository.streamCursors, [1]);
  });

  test('start failure emits AssistantFailed', () async {
    repository.failStart = true;
    await cubit.start();

    expect(
      cubit.state,
      const AssistantFailed(AssistantError.load),
    );
  });

  test('history failure emits AssistantFailed', () async {
    repository.failHistory = true;
    await cubit.start();

    expect(cubit.state, isA<AssistantFailed>());
  });

  test('a stream block is appended and a duplicate id is ignored', () async {
    await startWith([_grid()]);

    repository.push(_single());
    await pumpEventQueue();
    repository.push(_single());
    await pumpEventQueue();
    repository.push(_grid());
    await pumpEventQueue();

    expect(_ready(cubit).blocks, [_grid(), _single()]);
  });

  test('selectTopic sends the topic reply, resolves, then waits for a block',
      () async {
    await startWith([_grid()]);
    final topic = _grid().topics.first;

    await cubit.selectTopic(1, topic);

    final state = _ready(cubit);
    expect(repository.sentReplies.single.replyId, 'topic:symptom');
    expect(repository.sentReplies.single.label, 'I have a symptom');
    expect(state.resolved[1], 'topic:symptom');
    expect(state.awaitingReply, isTrue);
    expect(state.blocks.last, isA<UserTextBlock>());
    expect(state.blocks.last.id, lessThan(0));

    repository.push(_single());
    await pumpEventQueue();

    expect(_ready(cubit).awaitingReply, isFalse);
  });

  test('chooseOption sends hc:<questionId>:<index> with the option label',
      () async {
    await startWith([_single()]);

    await cubit.chooseOption(20, _single(), 2);

    expect(repository.sentReplies.single.replyId, 'hc:q1:2');
    expect(repository.sentReplies.single.label, "I'm not sure");
    expect(_ready(cubit).resolved[20], '2');
  });

  test('multi selection follows the exclusive rule and submits sorted',
      () async {
    await startWith([_multi()]);
    final question = _multi();

    cubit.toggleOption(21, question, 0);
    cubit.toggleOption(21, question, 2);
    expect(_ready(cubit).selections[21], {0, 2});

    cubit.toggleOption(21, question, 3);
    expect(_ready(cubit).selections[21], {3});

    cubit.toggleOption(21, question, 1);
    expect(_ready(cubit).selections[21], {1});

    cubit.toggleOption(21, question, 0);
    cubit.toggleOption(21, question, 1);
    expect(_ready(cubit).selections[21], {0});
    cubit.toggleOption(21, question, 1);

    await cubit.submitSelection(21, question);

    expect(repository.sentReplies.single.replyId, 'hc:q2:0,1');
    expect(repository.sentReplies.single.label, 'Headache, Nausea');
    expect(_ready(cubit).resolved[21], 'submitted');
  });

  test('submitSelection with nothing ticked sends nothing', () async {
    await startWith([_multi()]);

    await cubit.submitSelection(21, _multi());

    expect(repository.sentReplies, isEmpty);
  });

  test('sendText trims and ignores blank text', () async {
    await startWith([_grid()]);

    await cubit.sendText('   ');
    expect(repository.sentTexts, isEmpty);

    await cubit.sendText('  I feel dizzy ');
    expect(repository.sentTexts.single.text, 'I feel dizzy');
    expect(_ready(cubit).blocks.last, isA<UserTextBlock>());
  });

  test('answerSummary sends the confirm and edit reply ids', () async {
    await startWith([_summary()]);

    await cubit.answerSummary(30, _summary(), confirm: true);

    expect(repository.sentReplies.single.replyId, 'summary:ok');
    expect(repository.sentReplies.single.label, 'Looks good');
    expect(_ready(cubit).resolved[30], 'summary:ok');
  });

  test('answerConfirmRequest sends the decline id with the given label',
      () async {
    await startWith([_confirm()]);

    await cubit.answerConfirmRequest(
      14,
      _confirm(),
      confirm: false,
      label: 'Cancel',
    );

    expect(repository.sentReplies.single.replyId, 'decline:abc');
    expect(repository.sentReplies.single.label, 'Cancel');
  });

  test('a failed send sets actionError, clears waiting, and un-resolves',
      () async {
    await startWith([_grid()]);
    repository.failNextSend = true;

    await cubit.selectTopic(1, _grid().topics.first);

    final state = _ready(cubit);
    expect(state.actionError, AssistantError.send);
    expect(state.awaitingReply, isFalse);
    expect(state.resolved.containsKey(1), isFalse);
    expect(state.blocks.last, isA<UserTextBlock>());

    cubit.errorShown();
    expect(_ready(cubit).actionError, isNull);
  });

  test('sends are ignored while awaiting a reply', () async {
    await startWith([_grid()]);

    await cubit.sendText('first');
    await cubit.sendText('second');

    expect(repository.sentTexts.map((s) => s.text), ['first']);
  });

  test('sends and taps are ignored in a read-only view', () async {
    repository.historyBlocks = [_grid()];
    await cubit.view('old-session');

    await cubit.sendText('hello');
    await cubit.selectTopic(1, _grid().topics.first);

    expect(_ready(cubit).readOnly, isTrue);
    expect(repository.sentTexts, isEmpty);
    expect(repository.sentReplies, isEmpty);
    expect(repository.streamCursors, isEmpty);
    expect(repository.historyRequests, ['old-session']);
  });

  test('a resolved block cannot be answered twice', () async {
    await startWith([_single()]);

    await cubit.chooseOption(20, _single(), 0);
    repository.push(assistantBlockFromJson(assistantTextJson));
    await pumpEventQueue();
    await cubit.chooseOption(20, _single(), 1);

    expect(repository.sentReplies.length, 1);
  });

  test('openSuggestion emits OpenGuidedBooking with the prefill', () async {
    await startWith([_guidance()]);

    cubit.openSuggestion(_guidance().suggestions.single);

    final navigation = _ready(cubit).navigation as OpenGuidedBooking;
    expect(navigation.booking.category, 'pharmacy');
    expect(navigation.booking.issueCodes, ['med_side_effects']);
    expect(repository.sentReplies, isEmpty);

    cubit.navigationConsumed();
    expect(_ready(cubit).navigation, isNull);
  });

  test('act: explore services navigates, reply sends, new conversation waits',
      () async {
    await startWith([_nextStep()]);
    final actions = _nextStep().actions;

    await cubit.act(actions[0]);
    expect(_ready(cubit).navigation, const OpenAllServices());
    cubit.navigationConsumed();

    await cubit.act(actions[2]);
    expect(repository.sentReplies, isEmpty);
    expect(_ready(cubit).navigation, isNull);

    await cubit.act(actions[1]);
    expect(repository.sentReplies.single.replyId, 'next:save');
    expect(repository.sentReplies.single.label, 'Save My Summary');
    expect(_ready(cubit).resolved, isEmpty);
  });

  test('stream completion marks the conversation disconnected', () async {
    await startWith([_grid()]);

    await repository.closeStream();
    await pumpEventQueue();

    expect(_ready(cubit).connected, isFalse);
  });

  test('start(fresh: true) asks the repository for a fresh session', () async {
    await startWith([_grid()]);

    await cubit.start(fresh: true);

    expect(repository.startFresh, [false, true]);
  });

  test('isInteractive allows only the last unresolved interactive block',
      () async {
    await startWith([_grid(), _single()]);
    final state = _ready(cubit);

    expect(AssistantCubit.isInteractive(state, _grid()), isFalse);
    expect(AssistantCubit.isInteractive(state, _single()), isTrue);

    await cubit.chooseOption(20, _single(), 0);
    expect(AssistantCubit.isInteractive(_ready(cubit), _single()), isFalse);
  });

  test('after a reload, a card followed by a stored reply is not interactive',
      () async {
    await startWith([
      _grid(),
      _summary(),
      const UserTextBlock(id: 40, text: 'Looks good'),
      _guidance(),
      _nextStep(),
    ]);
    final state = _ready(cubit);

    expect(AssistantCubit.isInteractive(state, _summary()), isFalse);
    expect(AssistantCubit.isInteractive(state, _grid()), isFalse);
  });

  test('an optimistic bubble after a failed tap keeps the card answerable',
      () async {
    await startWith([_grid(), _single()]);
    repository.failNextSend = true;

    await cubit.chooseOption(20, _single(), 0);

    expect(AssistantCubit.isInteractive(_ready(cubit), _single()), isTrue);
  });
}
