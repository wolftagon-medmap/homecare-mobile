import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_state.dart';

import 'fakes.dart';

void main() {
  late FakeHealthProfileDataSource source;

  HealthSectionCubit cubitFor(String code, {int? profileId}) {
    final repository = HealthProfileRepositoryImpl(source);
    return HealthSectionCubit(
      code: code,
      patientProfileId: profileId,
      getSection: GetHealthSection(repository),
      saveSection: SaveHealthSection(repository),
    );
  }

  HealthQuestion questionOf(HealthSectionCubit cubit, String code) =>
      cubit.state.section!.questions.firstWhere((q) => q.code == code);

  setUp(() {
    source = FakeHealthProfileDataSource(sectionJson: {
      'my_health': myHealthJson(),
      'my_lifestyle': myLifestyleJson(),
    });
  });

  test('load reads the section for the given profile', () async {
    final cubit = cubitFor('my_health', profileId: 12);

    await cubit.load();

    expect(cubit.state.status, HealthSectionStatus.ready);
    expect(cubit.state.section!.title, 'My Health');
    expect(source.lastProfileId, 12);
  });

  test('a failed load keeps the failure for the page to explain', () async {
    source.failNext = const NetworkFailure('network');
    final cubit = cubitFor('my_health');

    await cubit.load();

    expect(cubit.state.status, HealthSectionStatus.loadFailed);
    expect(cubit.state.failure, isA<NetworkFailure>());
  });

  test('an exclusive option clears the others, and is cleared by them',
      () async {
    final cubit = cubitFor('my_health');
    await cubit.load();
    final conditions = questionOf(cubit, 'conditions');

    cubit.toggleMany(conditions, 'diabetes');
    cubit.toggleMany(conditions, 'high_blood_pressure');
    cubit.toggleMany(conditions, 'not_sure');
    expect(cubit.state.selection('conditions'), ['not_sure']);

    cubit.toggleMany(conditions, 'diabetes');
    expect(cubit.state.selection('conditions'), ['diabetes']);
  });

  test('own answers are trimmed, clear exclusives, and stop at five', () async {
    final cubit = cubitFor('my_health');
    await cubit.load();
    final conditions = questionOf(cubit, 'conditions');

    cubit.toggleMany(conditions, 'not_sure');
    cubit.addCustomValue(conditions, '  Gout  ');
    expect(cubit.state.selection('conditions'), ['Gout']);

    for (final value in ['A', 'B', 'C', 'D', 'E']) {
      cubit.addCustomValue(conditions, value);
    }
    expect(cubit.state.selection('conditions'), ['Gout', 'A', 'B', 'C', 'D']);
    expect(cubit.canAddCustomValue(conditions), isFalse);

    cubit.addCustomValue(conditions, 'x' * (maxOwnTextLength + 1));
    cubit.removeValue(conditions, 'Gout');
    expect(cubit.state.selection('conditions'), ['A', 'B', 'C', 'D']);
  });

  test(
      'a follow-up appears with its answer and is left out when it stops '
      'applying', () async {
    final cubit = cubitFor('my_lifestyle');
    await cubit.load();
    final smoke = questionOf(cubit, 'smoke_or_vape');
    final cigarettes = questionOf(cubit, 'cigarettes_per_day');

    expect(cubit.state.visibleQuestions, isNot(contains(cigarettes)));

    cubit.selectOne(smoke, 'daily');
    cubit.selectOne(cigarettes, '6_10');
    expect(cubit.state.visibleQuestions, contains(cigarettes));
    expect(cubit.state.payload,
        {'smoke_or_vape': 'daily', 'cigarettes_per_day': '6_10'});

    cubit.selectOne(smoke, 'no');
    expect(cubit.state.visibleQuestions, isNot(contains(cigarettes)));
    expect(cubit.state.payload, {'smoke_or_vape': 'no'});
  });

  test('save is possible only after a change, and sends the payload', () async {
    final cubit = cubitFor('my_health');
    await cubit.load();
    expect(cubit.state.canSave, isFalse);

    cubit.toggleMany(questionOf(cubit, 'conditions'), 'diabetes');
    expect(cubit.state.canSave, isTrue);

    expect(await cubit.save(), isTrue);
    expect(source.lastSaved, {
      'conditions': ['diabetes'],
    });
    expect(cubit.state.isDirty, isFalse);
    expect(cubit.state.section!.updatedAt, isNotNull);
  });

  test('a failed save keeps the answers and the failure', () async {
    final cubit = cubitFor('my_health');
    await cubit.load();
    cubit.setText(questionOf(cubit, 'notes'), 'Recent blood test');
    source.failNext = const BadRequestFailure('invalid');

    expect(await cubit.save(), isFalse);
    expect(cubit.state.status, HealthSectionStatus.ready);
    expect(cubit.state.failure, isA<BadRequestFailure>());
    expect(cubit.state.text('notes'), 'Recent blood test');
    expect(cubit.state.canSave, isTrue);
  });

  test('an answer to a question this app cannot show is sent back unchanged',
      () async {
    final json = myHealthJson(answers: {
      'conditions': ['diabetes'],
      'body_map': {'left_knee': 3},
    });
    (json['questions'] as List).add({
      'code': 'body_map',
      'text': 'Where does it hurt?',
      'type': 'body_map',
    });
    source = FakeHealthProfileDataSource(sectionJson: {'my_health': json});
    final cubit = cubitFor('my_health');
    await cubit.load();

    cubit.toggleMany(questionOf(cubit, 'conditions'), 'not_sure');
    await cubit.save();

    expect(cubit.state.visibleQuestions.map((q) => q.code),
        isNot(contains('body_map')));
    expect(source.lastSaved!['body_map'], {'left_knee': 3});
  });
}
