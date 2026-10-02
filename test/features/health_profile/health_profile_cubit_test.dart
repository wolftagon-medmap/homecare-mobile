import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/entities/health_profile_subject.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_state.dart';

import 'fakes.dart';

void main() {
  final sections = [
    {'code': 'my_health', 'title': 'My Health', 'opens_route': null},
    {'code': 'family_history', 'title': 'Family Health History'},
    {
      'code': 'mental_wellbeing',
      'title': 'Mental Wellbeing',
      'opens_route': 'mental_state',
    },
    {'code': 'sleep', 'title': 'Sleep', 'opens_route': 'sleep_diary'},
  ];

  late FakeHealthProfileDataSource source;

  HealthProfileCubit cubitFor(HealthProfileSubject subject) =>
      HealthProfileCubit(
        getSections: GetHealthSections(HealthProfileRepositoryImpl(source)),
        subject: subject,
      );

  setUp(() => source = FakeHealthProfileDataSource(sections: sections));

  test('the account holder sees Mental Wellbeing; unknown routes are hidden',
      () async {
    final cubit = cubitFor(const HealthProfileSubject(
        patientProfileId: null, isAccountHolder: true));

    await cubit.load();

    expect(cubit.state.sections.map((s) => s.code),
        ['my_health', 'family_history', 'mental_wellbeing']);
    expect(source.lastProfileId, isNull);
  });

  test('a family member does not see Mental Wellbeing', () async {
    final cubit = cubitFor(const HealthProfileSubject(
        patientProfileId: 9, isAccountHolder: false));

    await cubit.load();

    expect(cubit.state.sections.map((s) => s.code),
        ['my_health', 'family_history']);
    expect(source.lastProfileId, 9);
  });

  test('a failed load becomes the error state', () async {
    source.failNext = const ServerFailure('server');
    final cubit = cubitFor(const HealthProfileSubject(
        patientProfileId: null, isAccountHolder: true));

    await cubit.load();

    expect(cubit.state.status, HealthProfileStatus.error);
    expect(cubit.state.failure, isA<ServerFailure>());
  });
}
