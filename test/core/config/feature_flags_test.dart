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

  test('every data source bootstraps local, every navigation flag on', () {
    for (final feature in Feature.values) {
      expect(AppFlags.sourceOf(feature), FlagSource.bootstrap);
      expect(
        AppFlags.remote(feature),
        feature.isNavigation,
        reason: feature.key,
      );
    }
  });

  test('a debug override beats the bootstrap', () async {
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

  test('clearing an override falls back to the bootstrap', () async {
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

  test('a debug override outranks the server', () async {
    await AppFlags.applyServerFlags({Feature.issueCatalogue: true});
    await AppFlags.setOverride(Feature.issueCatalogue, false);

    expect(AppFlags.remote(Feature.issueCatalogue), isFalse);
    expect(AppFlags.sourceOf(Feature.issueCatalogue), FlagSource.debugOverride);
  });

  test('the server answer survives a restart', () async {
    await AppFlags.applyServerFlags({Feature.issueCatalogue: true});

    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());

    expect(AppFlags.remote(Feature.issueCatalogue), isTrue);
    expect(AppFlags.sourceOf(Feature.issueCatalogue), FlagSource.server);
  });

  test('a persisted server value beats the bootstrap', () async {
    await AppFlags.applyServerFlags({Feature.guidedBookingFlow: false});

    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());

    expect(AppFlags.sourceOf(Feature.guidedBookingFlow), FlagSource.server);
    expect(AppFlags.remote(Feature.guidedBookingFlow), isFalse);
  });

  test('a debug override beats a persisted server value', () async {
    await AppFlags.applyServerFlags({Feature.guidedBookingFlow: false});

    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());
    await AppFlags.setOverride(Feature.guidedBookingFlow, true);

    expect(
      AppFlags.sourceOf(Feature.guidedBookingFlow),
      FlagSource.debugOverride,
    );
    expect(AppFlags.remote(Feature.guidedBookingFlow), isTrue);
  });

  test('an unknown key from the server leaves the bootstrap standing',
      () async {
    await AppFlags.applyServerFlags({Feature.issueCatalogue: true});

    expect(AppFlags.sourceOf(Feature.healthProfileFlow), FlagSource.bootstrap);
    expect(AppFlags.remote(Feature.healthProfileFlow), isTrue);
  });
}
