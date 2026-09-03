import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/health_profile/data/fixtures/health_profile_fixture.dart';
import 'package:m2health/features/health_profile/data/models/health_profile_models.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

void main() {
  Map<String, dynamic> fixture(String code) =>
      kHealthProfileSectionsFixture.firstWhere((s) => s['code'] == code);

  test('every fixture section parses through fromJson', () {
    for (final json in kHealthProfileSectionsFixture) {
      final section = HealthSectionModel.fromJson(json);
      expect(section.code, json['code']);
      expect(section.questions.length, (json['questions'] as List).length);
    }
  });

  test('the four sections are the ones the client named, in order', () {
    final codes = kHealthProfileSectionsFixture.map((s) => s['code']).toList();
    expect(codes, [
      'my_health',
      'my_lifestyle',
      'family_history',
      'mental_wellbeing',
    ]);
  });

  test('my health carries the PDF wording and its exclusive options', () {
    final section = HealthSectionModel.fromJson(fixture('my_health'));
    final conditions = section.questions.first;

    expect(conditions.text, 'Do you have any of the following conditions?');
    expect(conditions.type, HealthQuestionType.multiChoice);
    expect(conditions.allowsCustom, isTrue);
    expect(conditions.customLabel, 'Add another condition');
    expect(
      conditions.options.map((o) => o.label).take(5),
      [
        'High Blood Pressure',
        'High Cholesterol',
        'Diabetes',
        'Kidney Disease',
        'Heart Disease',
      ],
    );
    expect(conditions.isExclusive('no_known_conditions'), isTrue);
    expect(conditions.isExclusive('not_sure'), isTrue);
    expect(conditions.isExclusive('diabetes'), isFalse);

    final notes = section.questions.last;
    expect(notes.type, HealthQuestionType.longText);
    expect(notes.allowsAttachments, isTrue);
    expect(notes.attachmentsKey, 'notes_attachments');
  });

  test('family history exclusive options are the two the PDF lists', () {
    final section = HealthSectionModel.fromJson(fixture('family_history'));
    final question = section.questions.first;

    expect(question.text, 'Does anyone in your immediate family have:');
    expect(
      question.options.where((o) => o.exclusive).map((o) => o.label),
      ["I'm not sure", 'None that I know of'],
    );
  });

  test('cigarettes per day is hidden until smoking is answered', () {
    final section = HealthSectionModel.fromJson(fixture('my_lifestyle'));

    expect(section.visibleFor(const {}).map((q) => q.code),
        isNot(contains('cigarettes_per_day')));
    expect(section.visibleFor(const {'smoke_or_vape': 'no'}).map((q) => q.code),
        isNot(contains('cigarettes_per_day')));
    expect(
        section
            .visibleFor(const {'smoke_or_vape': 'prefer_not_to_say'})
            .map((q) => q.code),
        isNot(contains('cigarettes_per_day')));
    expect(
        section.visibleFor(const {'smoke_or_vape': 'daily'}).map((q) => q.code),
        contains('cigarettes_per_day'));
  });

  test('the lifestyle layouts survive the wire', () {
    final section = HealthSectionModel.fromJson(fixture('my_lifestyle'));
    final byCode = {for (final q in section.questions) q.code: q};

    expect(byCode['smoke_or_vape']!.type, HealthQuestionType.singleChoice);
    expect(byCode['activities']!.type, HealthQuestionType.chipMultiChoice);
    expect(byCode['activity_level']!.group, 'Exercise');
    expect(byCode['diet']!.customLabel, 'Others');
  });

  test('mental wellbeing carries no questions and opens a shipped screen', () {
    final summary =
        HealthSectionSummaryModel.fromJson(fixture('mental_wellbeing'));

    expect(summary.questionCount, 0);
    expect(summary.opensRoute, HealthSectionRoute.mentalState);
  });

  test('a custom value is anything the option list does not carry', () {
    final section = HealthSectionModel.fromJson(fixture('my_health'));
    final conditions = section.questions.first;

    expect(conditions.isCustomValue('Gout'), isTrue);
    expect(conditions.isCustomValue('diabetes'), isFalse);
  });
}
