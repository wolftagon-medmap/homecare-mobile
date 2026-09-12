import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/patient_health_profile/etc/domain/entities/mental_health_state.dart';
import 'package:m2health/features/user_profiles/domain/entities/profile.dart';
import 'package:m2health/features/user_profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/features/user_profiles/domain/usecases/index.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_state.dart';

const _primary = Profile(
  id: 1,
  userId: 1,
  name: 'Ahmad Hamdi',
  isPrimary: true,
  avatar: 'https://example.test/hamdi.png',
);

const _child = Profile(id: 2, userId: 1, name: 'Nadia Hamdi');

class _FakeProfileRepository implements ProfileRepository {
  Either<Failure, List<Profile>> profilesResult =
      const Right([_primary, _child]);
  Either<Failure, Unit> updateResult = const Right(unit);

  @override
  Future<Either<Failure, List<Profile>>> getProfiles() async => profilesResult;

  @override
  Future<Either<Failure, Unit>> update(UpdateProfileParams profile) async =>
      updateResult;

  @override
  Future<Either<Failure, Profile>> create(CreateProfileParams profile) async =>
      const Right(_child);

  @override
  Future<Either<Failure, Unit>> delete(int profileId) async =>
      const Right(unit);

  @override
  Future<Either<Failure, MentalHealthState>> getMentalHealthState() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> updateMentalHealthState(
          MentalHealthState state) =>
      throw UnimplementedError();
}

PatientProfileCubit _cubitFor(_FakeProfileRepository repository) {
  return PatientProfileCubit(
    getProfilesUseCase: GetProfiles(repository),
    createProfileUseCase: CreateProfile(repository),
    updateProfileUseCase: UpdateProfile(repository),
    deleteProfileUseCase: DeleteProfile(repository),
  );
}

void main() {
  late _FakeProfileRepository repository;
  late PatientProfileCubit cubit;

  setUp(() {
    repository = _FakeProfileRepository();
    cubit = _cubitFor(repository);
  });

  tearDown(() async => cubit.close());

  test('loading resolves the primary profile as active', () async {
    await cubit.loadProfiles();

    expect(cubit.state, isA<PatientProfileLoaded>());
    expect(cubit.activeProfile?.name, 'Ahmad Hamdi');
    expect(cubit.state.lastActiveProfile?.avatar,
        'https://example.test/hamdi.png');
  });

  test('every state during a reload still carries the active profile',
      () async {
    await cubit.loadProfiles();

    final seen = <PatientProfileState>[];
    final subscription = cubit.stream.listen(seen.add);
    await cubit.loadProfiles();
    await subscription.cancel();

    expect(seen, isNotEmpty);
    expect(seen.whereType<PatientProfileLoading>(), isNotEmpty);
    for (final state in seen) {
      expect(state.lastActiveProfile?.name, 'Ahmad Hamdi',
          reason: '${state.runtimeType} dropped the active profile');
    }
  });

  test('a failed reload keeps the profile already on screen', () async {
    await cubit.loadProfiles();
    repository.profilesResult = const Left(ServerFailure('network down'));

    await cubit.loadProfiles();

    expect(cubit.state, isA<PatientProfileError>());
    expect(cubit.state.lastActiveProfile?.name, 'Ahmad Hamdi');
    expect(cubit.activeProfile, isNotNull);
  });

  test('a failed save keeps the profile through saving and error', () async {
    await cubit.loadProfiles();
    repository.updateResult = const Left(ServerFailure('rejected'));

    final seen = <PatientProfileState>[];
    final subscription = cubit.stream.listen(seen.add);
    await cubit.updateProfile(UpdateProfileParams(profileId: 1, name: 'X'));
    await subscription.cancel();

    expect(seen.whereType<PatientProfileSaving>(), isNotEmpty);
    for (final state in seen) {
      expect(state.lastActiveProfile?.name, 'Ahmad Hamdi',
          reason: '${state.runtimeType} dropped the active profile');
    }
  });

  test('switching profile moves the active profile', () async {
    await cubit.loadProfiles();

    cubit.setActiveProfile(2);

    expect(cubit.activeProfile?.name, 'Nadia Hamdi');
  });

  test('an empty account reports an error rather than a blank profile',
      () async {
    repository.profilesResult = const Right([]);

    await cubit.loadProfiles();

    expect(cubit.state, isA<PatientProfileError>());
    expect(cubit.activeProfile, isNull);
  });
}
