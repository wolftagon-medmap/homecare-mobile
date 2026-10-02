import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/patient_health_profile/etc/domain/entities/mental_health_state.dart';
import 'package:m2health/features/user_profiles/domain/entities/profile.dart';
import 'package:m2health/features/user_profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/features/user_profiles/domain/usecases/index.dart';
import 'package:m2health/features/user_profiles/presentation/bloc/patient_profile_cubit.dart';
import 'package:m2health/features/user_profiles/presentation/pages/patient_profile_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/l10n/app_localizations.dart';
import 'package:m2health/route/app_routes.dart';

const _primary =
    Profile(id: 1, userId: 1, name: 'Account holder', isPrimary: true);
const _family = Profile(id: 2, userId: 1, name: 'Family member');

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<Either<Failure, List<Profile>>> getProfiles() async =>
      const Right([_primary, _family]);

  @override
  Future<Either<Failure, Unit>> update(UpdateProfileParams profile) async =>
      const Right(unit);

  @override
  Future<Either<Failure, Profile>> create(CreateProfileParams profile) async =>
      const Right(_family);

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

void main() {
  Future<PatientProfileCubit> pumpProfilePage(
    WidgetTester tester, {
    required bool familyMember,
  }) async {
    final repository = _FakeProfileRepository();
    final cubit = PatientProfileCubit(
      getProfilesUseCase: GetProfiles(repository),
      createProfileUseCase: CreateProfile(repository),
      updateProfileUseCase: UpdateProfile(repository),
      deleteProfileUseCase: DeleteProfile(repository),
    );
    addTearDown(cubit.close);
    await cubit.loadProfiles();
    if (familyMember) cubit.setActiveProfile(_family.id);

    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const PatientProfilePage()),
      GoRoute(
        path: AppRoutes.healthProfile,
        builder: (_, __) => const Scaffold(body: Text('health profile page')),
      ),
    ]);
    await tester.pumpWidget(
      TranslationProvider(
        child: BlocProvider.value(
          value: cubit,
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  for (final familyMember in [false, true]) {
    testWidgets(
        'Health profile replaces the older health entries '
        '(${familyMember ? 'family member' : 'account holder'})',
        (tester) async {
      await pumpProfilePage(tester, familyMember: familyMember);

      expect(find.text(familyMember ? 'Family member' : 'Account holder'),
          findsWidgets);
      expect(find.text('Health Profile'), findsOneWidget);
      expect(find.text('Medical History & Risk Factors'), findsNothing);
      expect(find.text('Lifestyle & Self Care'), findsNothing);
      expect(find.text('Physical Sign'), findsNothing);

      await tester.tap(find.text('Health Profile'));
      await tester.pumpAndSettle();
      expect(find.text('health profile page'), findsOneWidget);
    });
  }
}
