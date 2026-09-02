import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/core/config/feature_flags_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());
    await AppFlags.clearOverrides();
  });

  // Tall enough that the whole list lays out at once — the assertions are
  // about what the page contains, not about scrolling.
  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: FeatureFlagsPage()));
  }

  testWidgets('lists every feature, grouped by owner', (tester) async {
    await pumpPage(tester);

    for (final owner in FeatureOwner.values) {
      expect(find.text(owner.label.toUpperCase()), findsOneWidget,
          reason: owner.name);
    }

    for (final feature in Feature.values) {
      expect(find.text(feature.label), findsOneWidget, reason: feature.key);
    }

    expect(find.byType(SwitchListTile), findsNWidgets(Feature.values.length));
  });

  testWidgets('toggling a flag writes an override', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();

    expect(AppFlags.remote(Feature.issueCatalogue), isTrue);
    expect(AppFlags.sourceOf(Feature.issueCatalogue), FlagSource.debugOverride);
  });
}
