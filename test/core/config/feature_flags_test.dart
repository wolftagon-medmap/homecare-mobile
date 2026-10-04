import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());
  });

  test('every flag is on before the server answers', () {
    for (final feature in Feature.values) {
      expect(AppFlags.isOn(feature), isTrue, reason: feature.key);
    }
  });

  test('the server can turn a flag off', () async {
    await AppFlags.applyServerFlags({Feature.guidedBookingFlow: false});

    expect(AppFlags.isOn(Feature.guidedBookingFlow), isFalse);
  });

  test('the server answer survives a restart', () async {
    await AppFlags.applyServerFlags({Feature.guidedBookingFlow: false});

    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());

    expect(AppFlags.isOn(Feature.guidedBookingFlow), isFalse);
  });

  test('a flag the server omits falls back to on', () async {
    await AppFlags.applyServerFlags({Feature.guidedBookingFlow: false});
    await AppFlags.applyServerFlags({});

    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());

    expect(AppFlags.isOn(Feature.guidedBookingFlow), isTrue);
  });
}
