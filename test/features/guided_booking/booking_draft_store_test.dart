import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_local_datasource.dart';
import 'package:m2health/features/guided_booking/data/models/booking_models.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  GuidedBookingDraft sample() => const GuidedBookingDraft(
        category: 'nursing',
        subCategory: 'primary_nurse',
        issueCodes: ['nurse_wound_care', 'nurse_injection'],
        remarks: 'Dressing change',
        addOnCodes: ['addon_a'],
        addressId: 10,
        professionalId: 2,
      ).withPreferredAt(DateTime(2026, 9, 8, 10));

  group('GuidedBookingDraftModel', () {
    test('round-trips every field through JSON', () {
      final restored = GuidedBookingDraftModel.fromJson(sample().toJson());

      expect(restored, sample());
    });

    test('tolerates a payload with every optional field absent', () {
      final restored =
          GuidedBookingDraftModel.fromJson({'category': 'nursing'});

      expect(restored.category, 'nursing');
      expect(restored.subCategory, isNull);
      expect(restored.issueCodes, isEmpty);
      expect(restored.remarks, '');
      expect(restored.preferredAt, isNull);
    });
  });

  group('BookingDraftLocalDataSource', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('a saved draft survives a restart', () async {
      await BookingDraftLocalDataSource(prefs).save(sample());

      final afterRestart =
          await BookingDraftLocalDataSource(prefs).load('nursing');

      expect(afterRestart, sample());
    });

    test('returns null for a category that was never saved', () async {
      expect(await BookingDraftLocalDataSource(prefs).load('pharmacy'), isNull);
    });

    test('drafts of different categories do not overwrite each other',
        () async {
      final store = BookingDraftLocalDataSource(prefs);
      await store.save(sample());
      await store.save(const GuidedBookingDraft(category: 'pharmacy'));

      expect(await store.load('nursing'), sample());
      expect((await store.load('pharmacy'))?.category, 'pharmacy');
    });

    test('clear removes only the named category', () async {
      final store = BookingDraftLocalDataSource(prefs);
      await store.save(sample());
      await store.save(const GuidedBookingDraft(category: 'pharmacy'));

      await store.clear('nursing');

      expect(await store.load('nursing'), isNull);
      expect(await store.load('pharmacy'), isNotNull);
    });

    test('a corrupt stored value is discarded rather than thrown', () async {
      await prefs.setString('guided_booking_draft.nursing', 'not json');

      expect(await BookingDraftLocalDataSource(prefs).load('nursing'), isNull);
    });
  });
}
