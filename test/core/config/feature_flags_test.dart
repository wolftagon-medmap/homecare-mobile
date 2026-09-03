import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());
    await AppFlags.clearOverrides();
  });

  /// Navigation flags pick a screen rather than a data source, so "local"
  /// carries no meaning for them and they may ship on.
  const navigationFlags = {
    Feature.guidedBookingFlow,
    Feature.healthProfileFlow,
  };

  test('every data source ships local', () {
    for (final feature in Feature.values) {
      expect(AppFlags.sourceOf(feature), FlagSource.compileTimeDefault);
      if (navigationFlags.contains(feature)) continue;
      expect(AppFlags.remote(feature), isFalse, reason: feature.key);
    }
  });

  test('a debug override beats the compile-time default', () async {
    await AppFlags.setOverride(Feature.issueCatalogue, true);

    expect(AppFlags.remote(Feature.issueCatalogue), isTrue);
    expect(AppFlags.sourceOf(Feature.issueCatalogue), FlagSource.debugOverride);
    expect(AppFlags.remote(Feature.bookingSubmit), isFalse);
  });

  test('overrides survive a restart', () async {
    await AppFlags.setOverride(Feature.messageThreads, true);
    await AppFlags.init(await SharedPreferences.getInstance());

    expect(AppFlags.remote(Feature.messageThreads), isTrue);
  });

  test('clearing an override falls back to the default', () async {
    await AppFlags.setOverride(Feature.servicePricing, true);
    await AppFlags.setOverride(Feature.servicePricing, null);

    expect(AppFlags.remote(Feature.servicePricing), isFalse);
    expect(AppFlags.overrideOf(Feature.servicePricing), isNull);
  });

  test('every feature is owned and labelled', () {
    for (final feature in Feature.values) {
      expect(feature.label, isNotEmpty, reason: feature.key);
      expect(feature.owner.label, isNotEmpty, reason: feature.key);
    }
  });
}
