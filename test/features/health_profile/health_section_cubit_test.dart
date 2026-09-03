import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_local_datasource.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/entities/health_question.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';

void main() {
  late HealthProfileRepositoryImpl repository;

  HealthSectionCubit cubitFor(String code) => HealthSectionCubit(
        code: code,
        patientProfileId: 7,
        getSection: GetHealthSection(repository),
        saveSection: SaveHealthSection(repository),
        uploadAttachment: UploadHealthAttachment(repository),
      );

  setUp(() {
    repository = HealthProfileRepositoryImpl(
      HealthProfileLocalDataSource(),
      HealthAttachmentLocalDataSource(),
    );
  });

  HealthQuestion questionOf(HealthSectionCubit cubit, String code) =>
      cubit.state.section!.questions.firstWhere((q) => q.code == code);

  test('an exclusive option clears the named conditions, and vice versa',
      () async {
    final cubit = cubitFor('my_health');
    await cubit.load();
    final conditions = questionOf(cubit, 'conditions');

    cubit.toggleMany(conditions, 'diabetes');
    cubit.toggleMany(conditions, 'heart_disease');
    expect(cubit.state.selection('conditions'), ['diabetes', 'heart_disease']);

    cubit.toggleMany(conditions, 'not_sure');
    expect(cubit.state.selection('conditions'), ['not_sure']);

    cubit.toggleMany(conditions, 'diabetes');
    expect(cubit.state.selection('conditions'), ['diabetes']);
  });

  test('a custom condition sits alongside the coded ones', () async {
    final cubit = cubitFor('my_health');
    await cubit.load();
    final conditions = questionOf(cubit, 'conditions');

    cubit.toggleMany(conditions, 'not_sure');
    cubit.addCustomValue(conditions, '  Gout  ');

    expect(cubit.state.selection('conditions'), ['Gout']);

    cubit.removeValue(conditions, 'Gout');
    expect(cubit.state.selection('conditions'), isEmpty);
  });

  test('answering the smoking question reveals cigarettes per day', () async {
    final cubit = cubitFor('my_lifestyle');
    await cubit.load();
    final smoking = questionOf(cubit, 'smoke_or_vape');

    expect(cubit.state.visibleQuestions.map((q) => q.code),
        isNot(contains('cigarettes_per_day')));

    cubit.selectOne(smoking, 'daily');
    expect(cubit.state.visibleQuestions.map((q) => q.code),
        contains('cigarettes_per_day'));

    cubit.selectOne(smoking, 'daily');
    expect(cubit.state.selection('smoke_or_vape'), isEmpty);
    expect(cubit.state.visibleQuestions.map((q) => q.code),
        isNot(contains('cigarettes_per_day')));
  });

  test('save is blocked until something changes, and clears after', () async {
    final cubit = cubitFor('family_history');
    await cubit.load();
    expect(cubit.state.canSave, isFalse);

    cubit.toggleMany(questionOf(cubit, 'family_conditions'), 'stroke');
    expect(cubit.state.canSave, isTrue);

    final saved = await cubit.save();
    expect(saved, isNotNull);
    expect(cubit.state.isDirty, isFalse);
    expect(cubit.state.canSave, isFalse);
  });

  test('answers are kept per family profile', () async {
    final cubit = cubitFor('family_history');
    await cubit.load();
    cubit.toggleMany(questionOf(cubit, 'family_conditions'), 'cancer');
    await cubit.save();

    final other = HealthSectionCubit(
      code: 'family_history',
      patientProfileId: 8,
      getSection: GetHealthSection(repository),
      saveSection: SaveHealthSection(repository),
      uploadAttachment: UploadHealthAttachment(repository),
    );
    await other.load();

    expect(other.state.selection('family_conditions'), isEmpty);
  });

  test('an attachment id lands under the question it belongs to', () async {
    final cubit = cubitFor('my_health');
    await cubit.load();
    final notes = questionOf(cubit, 'notes');

    await cubit.attach(notes, '/tmp/report.pdf');
    expect(cubit.state.attachments('notes'), hasLength(1));
    expect(cubit.state.answers.containsKey('notes_attachments'), isTrue);

    cubit.removeAttachment(notes, cubit.state.attachments('notes').first);
    expect(cubit.state.attachments('notes'), isEmpty);
  });
}
