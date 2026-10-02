// Runs the real health profile pages against a running API with seed data.
// Skipped unless E2E_API_URL is given, for example:
//   fvm flutter test test/e2e --dart-define=E2E_API_URL=http://127.0.0.1:3333
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_remote_datasource.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/health_profile_routes.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_profile_page.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_section_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/l10n/app_localizations.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

const apiUrl = String.fromEnvironment('E2E_API_URL');
const email =
    String.fromEnvironment('E2E_EMAIL', defaultValue: 'patient@mail.com');
const password =
    String.fromEnvironment('E2E_PASSWORD', defaultValue: 'patient');

void main() {
  // Real time and real network; the default fake-async binding never lets
  // HTTP started by a page complete.
  LiveTestWidgetsFlutterBinding.ensureInitialized();

  if (apiUrl.isEmpty) {
    test('health profile end to end', () {},
        skip: 'needs --dart-define=E2E_API_URL');
    return;
  }

  late Dio api;
  late String token;
  late HealthProfileRepositoryImpl repository;

  Future<dynamic> call(String method, String path, [Object? body]) async {
    final response = await api.request(
      path,
      data: body,
      options: Options(
        method: method,
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (_) => true,
      ),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> storedAnswers(String code,
      [int? profileId]) async {
    final query = profileId == null ? '' : '?patient_profile_id=$profileId';
    final body = await call('GET', '/v2/health-profile/sections/$code$query');
    return Map<String, dynamic>.from(body['data']['answers'] as Map);
  }

  Future<void> reset(String code, [int? profileId]) => call(
        'PUT',
        '/v2/health-profile/sections/$code',
        {if (profileId != null) 'patient_profile_id': profileId, 'answers': {}},
      );

  setUpAll(() async {
    // flutter_test answers every HTTP call with 400 unless this is cleared.
    HttpOverrides.global = null;
    api = Dio(
        BaseOptions(baseUrl: apiUrl, headers: {'Accept': 'application/json'}));
    final login = await api
        .post('/v1/auth/login', data: {'email': email, 'password': password});
    final raw = (login.data['data'] ?? login.data)['token'];
    token = raw is Map ? raw['token'] as String : raw as String;
    repository = HealthProfileRepositoryImpl(
      HealthProfileRemoteDataSource(Dio(), baseUrl: '$apiUrl/v2'),
    );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({'token': token});
    LocaleSettings.setLocale(AppLocale.en);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    int? profileId,
    bool accountHolder = true,
    String initial = AppRoutes.healthProfile,
  }) async {
    // A phone-width surface tall enough that taps land where things are drawn.
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(initialLocation: initial, routes: [
      GoRoute(
        path: AppRoutes.healthProfile,
        builder: (_, __) => BlocProvider(
          create: (_) => HealthProfileCubit(
            getSections: GetHealthSections(repository),
            patientProfileId: profileId,
            isAccountHolder: accountHolder,
          ),
          child: const HealthProfilePage(),
        ),
      ),
      GoRoute(
        path: HealthProfileRoutes.section,
        builder: (_, state) => BlocProvider(
          create: (_) => HealthSectionCubit(
            code: state.pathParameters['code']!,
            patientProfileId: profileId,
            getSection: GetHealthSection(repository),
            saveSection: SaveHealthSection(repository),
          ),
          child: const HealthSectionPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profileMentalState,
        builder: (_, __) => const Scaffold(body: Text('mental state page')),
      ),
    ]);
    await tester.pumpWidget(TranslationProvider(
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router,
      ),
    ));
    await settle(tester);
  }

  testWidgets('account holder: answer, save, and see it again', (tester) async {
    await tester.runAsync(() => reset('my_lifestyle'));
    await pumpApp(tester);

    for (final title in [
      'My Health',
      'My Lifestyle',
      'Family Health History',
      'Mental Wellbeing',
    ]) {
      expect(find.text(title), findsOneWidget);
    }

    await tester.tap(find.text('My Lifestyle'));
    await settle(tester);
    expect(find.text('6–10 sticks'), findsNothing);

    await tapText(tester, 'Daily');
    await tester.pumpAndSettle();
    await tapText(tester, '6–10 sticks');
    await tapText(tester, 'Swimming');
    await tapText(tester, 'Other');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Yoga');
    await tapText(tester, 'Add');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await settle(tester);

    expect(find.text('My Health'), findsOneWidget, reason: 'back on the list');
    expect(await tester.runAsync(() => storedAnswers('my_lifestyle')), {
      'smoke_or_vape': 'daily',
      'cigarettes_per_day': '6_10',
      'activities': ['swimming', 'Yoga'],
    });

    await tester.tap(find.text('My Lifestyle'));
    await settle(tester);
    expect(find.textContaining('Last updated'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Yoga'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Yoga'), findsOneWidget);

    await tapText(tester, 'No');
    await tester.pumpAndSettle();
    expect(find.text('6–10 sticks'), findsNothing);
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(await tester.runAsync(() => storedAnswers('my_lifestyle')), {
      'smoke_or_vape': 'no',
      'activities': ['swimming', 'Yoga'],
    });
  });

  testWidgets('exclusive answers and Mental Wellbeing', (tester) async {
    await tester.runAsync(() => reset('my_health'));
    await pumpApp(tester);

    await tester.tap(find.text('My Health'));
    await settle(tester);
    await tapText(tester, 'Diabetes');
    await tapText(tester, "I'm not sure");
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(await tester.runAsync(() => storedAnswers('my_health')), {
      'conditions': ['not_sure'],
    });

    await tester.tap(find.text('Mental Wellbeing'));
    await tester.pumpAndSettle();
    expect(find.text('mental state page'), findsOneWidget);
  });

  testWidgets('family member: own answers, no Mental Wellbeing',
      (tester) async {
    final familyId = await tester.runAsync(() async {
      final profiles = (await call('GET', '/v1/profiles'))['data'] as List;
      final family = profiles.cast<Map>().where((p) => p['is_primary'] != true);
      if (family.isNotEmpty) return family.first['id'] as int;
      final created = await call('POST', '/v1/profiles', {
        'name': 'E2E family member',
        'relation': 'child',
        'date_of_birth': '2016-01-01',
        'gender': 'Male',
      });
      return created['data']['id'] as int;
    });
    await tester.runAsync(() async {
      await reset('family_history');
      await reset('family_history', familyId);
    });
    await pumpApp(tester, profileId: familyId, accountHolder: false);

    expect(find.text('Mental Wellbeing'), findsNothing);
    await tester.tap(find.text('Family Health History'));
    await settle(tester);
    await tapText(tester, 'Stroke');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await settle(tester);

    expect(
        await tester.runAsync(() => storedAnswers('family_history', familyId)),
        {
          'family_conditions': ['stroke']
        });
    expect(
        await tester.runAsync(() => storedAnswers('family_history')), isEmpty);
  });

  testWidgets('a profile that is not yours shows a translated error',
      (tester) async {
    await pumpApp(tester,
        profileId: 999999999,
        accountHolder: false,
        initial: HealthProfileRoutes.sectionFor('my_health'));

    expect(find.text('This section could not load.'), findsOneWidget);
    expect(find.text('This profile or section is no longer available.'),
        findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('Indonesian', (tester) async {
    LocaleSettings.setLocale(AppLocale.id);
    await pumpApp(tester, initial: HealthProfileRoutes.sectionFor('my_health'));

    expect(find.text('Simpan'), findsOneWidget);
    expect(find.text('Diabetes'), findsOneWidget,
        reason: 'question text is English');
  });
}

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(find.text(text), 200,
      scrollable: find.byType(Scrollable).first);
  await tester.tap(find.text(text));
  await tester.pump();
}

/// Waits for the page's network calls to finish.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 50; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) break;
  }
  await tester.pumpAndSettle();
}
