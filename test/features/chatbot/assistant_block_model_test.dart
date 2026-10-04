import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/chatbot/data/models/assistant_block_model.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';

import 'fixtures/contract_blocks.dart';

void main() {
  test('user_text parses to a UserTextBlock', () {
    final block = assistantBlockFromJson(userTextJson);

    expect(block, const UserTextBlock(id: 11, text: "I've been feeling dizzy"));
  });

  test('assistant_text is not from the team, staff_text is', () {
    final assistant = assistantBlockFromJson(assistantTextJson);
    final staff = assistantBlockFromJson(staffTextJson);

    expect((assistant as AssistantTextBlock).fromTeam, isFalse);
    expect((staff as AssistantTextBlock).fromTeam, isTrue);
    expect(staff.text, 'A nurse will call you shortly.');
  });

  test('location kinds render as plain assistant text', () {
    final block = assistantBlockFromJson(const {
      'id': 5,
      'kind': 'location_request',
      'text': 'Where are you?',
    });

    expect(block, const AssistantTextBlock(id: 5, text: 'Where are you?'));
  });

  test('confirm_request carries both reply ids', () {
    final block = assistantBlockFromJson(confirmRequestJson);

    expect(
      block,
      const ConfirmRequestBlock(
        id: 14,
        text: 'Cancel your appointment on Monday?',
        confirmId: 'confirm:abc',
        cancelId: 'decline:abc',
      ),
    );
  });

  test('topic_grid keeps all eight topics in order', () {
    final block = assistantBlockFromJson(topicGridJson) as TopicGridBlock;

    expect(block.title, 'What can I help you with today?');
    expect(block.topics.length, 8);
    expect(block.topics.first.replyId, 'topic:symptom');
    expect(block.topics.first.tone, 'teal');
    expect(block.topics.last.replyId, 'topic:other');
  });

  test('single question maps every field', () {
    final block = assistantBlockFromJson(singleQuestionJson) as QuestionBlock;

    expect(block.questionId, 'q1');
    expect(block.mode, QuestionMode.single);
    expect(block.hint, 'Please choose one.');
    expect(block.options.map((o) => o.index), [0, 1, 2]);
    expect(block.options.last.label, "I'm not sure");
    expect(block.continueLabel, isNull);
    expect(block.exclusiveIndex, isNull);
  });

  test('multi question keeps the continue label and exclusive index', () {
    final block = assistantBlockFromJson(multiQuestionJson) as QuestionBlock;

    expect(block.mode, QuestionMode.multi);
    expect(block.continueLabel, 'Continue');
    expect(block.exclusiveIndex, 3);
  });

  test('summary maps rows and reply ids', () {
    final block = assistantBlockFromJson(summaryJson) as SummaryBlock;

    expect(block.rows.length, 2);
    expect(block.rows.first.icon, 'issue');
    expect(block.rows.last.value, 'When standing up');
    expect(block.footnote, startsWith('Please review'));
    expect(block.editReplyId, 'summary:edit');
    expect(block.confirmReplyId, 'summary:ok');
    expect(block.confirmLabel, 'Looks good');
  });

  test('guidance maps the disclaimer and the booking prefill', () {
    final block = assistantBlockFromJson(guidanceJson) as GuidanceBlock;

    expect(block.disclaimer, startsWith('This is general information'));
    expect(block.suggestionsTitle, 'You may also consider:');
    final booking = block.suggestions.single.booking!;
    expect(booking.category, 'pharmacy');
    expect(booking.subCategory, 'medication_support');
    expect(booking.issueCodes, ['med_side_effects']);
    expect(booking.remarks, 'Dizziness for about 3 days. When standing up.');
  });

  test('a suggestion without booking has booking null', () {
    final block = assistantBlockFromJson({
      'id': 40,
      'kind': 'guidance',
      'title': 'General guidance',
      'body': 'Rest.',
      'disclaimer': null,
      'suggestionsTitle': null,
      'suggestions': [
        {
          'replyId': 'svc:0',
          'title': 'Nursing',
          'subtitle': 'Home visit',
          'icon': 'nursing',
          'tone': 'teal',
        },
      ],
    }) as GuidanceBlock;

    expect(block.suggestions.single.booking, isNull);
    expect(block.disclaimer, isNull);
  });

  test('next_step maps each action kind', () {
    final block = assistantBlockFromJson(nextStepJson) as NextStepBlock;

    expect(block.actions.map((a) => a.kind), [
      NextStepKind.exploreServices,
      NextStepKind.reply,
      NextStepKind.newConversation,
    ]);
    expect(block.actions[1].replyId, 'next:save');
  });

  test('an unknown action becomes NextStepKind.unknown', () {
    final block = assistantBlockFromJson({
      'id': 50,
      'kind': 'next_step',
      'actions': [
        {
          'replyId': 'next:x',
          'action': 'teleport',
          'title': 'X',
          'subtitle': 'Y',
          'icon': 'ask',
          'tone': 'blue',
        },
      ],
    }) as NextStepBlock;

    expect(block.actions.single.kind, NextStepKind.unknown);
  });

  test('an unknown kind becomes UnknownAssistantBlock', () {
    final block = assistantBlockFromJson(const {
      'id': 60,
      'kind': 'professional_shortlist',
    });

    expect(
      block,
      const UnknownAssistantBlock(id: 60, kind: 'professional_shortlist'),
    );
  });

  test('a wrong field type degrades to UnknownAssistantBlock', () {
    final block = assistantBlockFromJson({
      ...singleQuestionJson,
      'options': 'x',
    });

    expect(block, const UnknownAssistantBlock(id: 20, kind: 'question'));
  });

  test('a block with no id or kind still parses', () {
    final block = assistantBlockFromJson(const {'text': 'hi'});

    expect(block, const UnknownAssistantBlock(id: 0, kind: 'unknown'));
  });
}
