import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/health_profile/data/models/health_profile_models.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/entities/health_section.dart';

import 'fakes.dart';

void main() {
  group('HealthSectionModel.fromJson (contract C3)', () {
    test('reads layouts, icons, follow-ups, and answers', () {
      final section = HealthSectionModel.fromJson(
        myLifestyleJson(answers: {
          'smoke_or_vape': 'daily',
          'activities': ['walking', 'Yoga'],
        }),
      );
      final byCode = {for (final q in section.questions) q.code: q};

      expect(byCode['smoke_or_vape']!.layout, HealthQuestionLayout.rows);
      expect(byCode['cigarettes_per_day']!.layout, HealthQuestionLayout.chips);
      expect(byCode['cigarettes_per_day']!.enableWhen!.notIn, ['no']);
      expect(byCode['activities']!.type, HealthQuestionType.multiChoice);
      expect(byCode['activities']!.layout, HealthQuestionLayout.grid);
      expect(byCode['activities']!.group, 'Exercise');
      expect(byCode['activities']!.options.map((o) => o.icon),
          [HealthOptionIcon.walk, HealthOptionIcon.gym]);
      expect(section.answers['activities'], ['walking', 'Yoga']);
    });

    test('unknown layout, icon, and type fall back as the contract says', () {
      final question = HealthQuestionModel.fromJson(const {
        'code': 'q',
        'text': 'Q',
        'type': 'slider',
        'layout': 'carousel',
        'options': [
          {'code': 'a', 'label': 'A', 'icon': 'rocket'},
        ],
      });

      expect(question.type, HealthQuestionType.unknown);
      expect(question.layout, HealthQuestionLayout.rows);
      expect(question.options.single.icon, isNull);
    });

    test('chip_multi_choice from an older API reads as multi choice chips', () {
      final question = HealthQuestionModel.fromJson(const {
        'code': 'q',
        'text': 'Q',
        'type': 'chip_multi_choice',
      });

      expect(question.type, HealthQuestionType.multiChoice);
      expect(question.layout, HealthQuestionLayout.chips);
    });

    test('updated_at is read, and null when never saved', () {
      expect(HealthSectionModel.fromJson(myHealthJson()).updatedAt, isNull);
      expect(
        HealthSectionModel.fromJson(myHealthJson(answers: {'notes': 'x'}))
            .updatedAt,
        DateTime.utc(2026, 9, 28, 3).toLocal(),
      );
    });
  });

  test('summary routes: none, mental state, and unknown', () {
    HealthSectionRoute? route(String? wire) =>
        HealthSectionSummaryModel.fromJson(
            {'code': 'c', 'title': 'T', 'opens_route': wire}).opensRoute;

    expect(route(null), isNull);
    expect(route('mental_state'), HealthSectionRoute.mentalState);
    expect(route('sleep_diary'), HealthSectionRoute.unknown);
  });
}
