import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';
import 'package:m2health/features/health_profile/presentation/pages/health_section_page.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/l10n/app_localizations.dart';

import 'fakes.dart';

void main() {
  late FakeHealthProfileDataSource source;

  Future<void> pumpSection(WidgetTester tester, String code) async {
    final repository = HealthProfileRepositoryImpl(source);
    final router = GoRouter(
      initialLocation: '/section',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('list')),
          routes: [
            GoRoute(
              path: 'section',
              builder: (_, __) => BlocProvider(
                create: (_) => HealthSectionCubit(
                  code: code,
                  patientProfileId: null,
                  getSection: GetHealthSection(repository),
                  saveSection: SaveHealthSection(repository),
                ),
                child: const HealthSectionPage(),
              ),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    source = FakeHealthProfileDataSource(sectionJson: {
      'my_health': myHealthJson(),
      'my_lifestyle': myLifestyleJson(),
    });
  });

  testWidgets('rows: exclusive options sit after a divider', (tester) async {
    await pumpSection(tester, 'my_health');

    expect(find.byType(Divider), findsOneWidget);
    final dividerY = tester.getTopLeft(find.byType(Divider)).dy;
    expect(tester.getTopLeft(find.text('Diabetes')).dy, lessThan(dividerY));
    expect(
        tester.getTopLeft(find.text("I'm not sure")).dy, greaterThan(dividerY));
  });

  testWidgets('picking an exclusive option clears a named one', (tester) async {
    await pumpSection(tester, 'my_health');

    await tester.tap(find.text('Diabetes'));
    await tester.pump();
    expect(tester.getSemantics(find.bySemanticsLabel('Diabetes')),
        containsSemantics(isSelected: true, isButton: true));

    await tester.tap(find.text("I'm not sure"));
    await tester.pump();
    expect(tester.getSemantics(find.bySemanticsLabel('Diabetes')),
        containsSemantics(isSelected: false));
  });

  testWidgets('an own answer becomes a selected option that can be removed',
      (tester) async {
    await pumpSection(tester, 'my_health');

    await tester.tap(find.text('Add another condition'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).first, 'Gout');
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Gout'), findsOneWidget);

    await tester.tap(find.text('Gout'));
    await tester.pump();
    expect(find.text('Gout'), findsNothing);
  });

  testWidgets('chips and grid render, with grid icons', (tester) async {
    await pumpSection(tester, 'my_lifestyle');

    await tester.tap(find.text('Daily'));
    await tester.pumpAndSettle();

    expect(find.text('6–10 sticks'), findsOneWidget);
    expect(find.byIcon(Icons.directions_walk), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    expect(find.text('Exercise'), findsOneWidget);
  });

  testWidgets('the follow-up appears only while it applies', (tester) async {
    await pumpSection(tester, 'my_lifestyle');
    expect(find.text('6–10 sticks'), findsNothing);

    await tester.tap(find.text('Daily'));
    await tester.pumpAndSettle();
    expect(find.text('6–10 sticks'), findsOneWidget);

    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.text('6–10 sticks'), findsNothing);
  });

  testWidgets('last updated shows once saved, and saving returns to the list',
      (tester) async {
    await pumpSection(tester, 'my_health');
    expect(find.textContaining('Last updated'), findsNothing);

    await tester.tap(find.text('Diabetes'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(source.lastSaved, {
      'conditions': ['diabetes'],
    });
    expect(find.text('list'), findsOneWidget);
  });

  testWidgets('going back with unsaved changes asks first', (tester) async {
    await pumpSection(tester, 'my_health');
    await tester.tap(find.text('Diabetes'));
    await tester.pump();

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Discard your changes?'), findsOneWidget);

    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.text('Diabetes'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('list'), findsOneWidget);
  });

  testWidgets('a section saved before shows its last updated date',
      (tester) async {
    source = FakeHealthProfileDataSource(sectionJson: {
      'my_health': myHealthJson(answers: {'notes': 'x'}),
    });
    await pumpSection(tester, 'my_health');

    expect(find.textContaining('Last updated'), findsOneWidget);
  });

  testWidgets('narrow screen with large text does not overflow',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const SizedBox());
    await pumpSection(tester, 'my_lifestyle');
    await tester.tap(find.text('Daily'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
