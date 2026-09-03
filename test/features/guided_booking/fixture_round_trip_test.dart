import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/guided_booking/data/fixtures/booking_fixtures.dart';
import 'package:m2health/features/guided_booking/data/fixtures/issue_catalogue_fixture.dart';
import 'package:m2health/features/guided_booking/data/models/booking_models.dart';
import 'package:m2health/features/guided_booking/data/models/issue_catalogue_model.dart';
import 'package:m2health/features/pricing/data/fixtures/price_table_fixture.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';

void main() {
  group('issue catalogue fixtures', () {
    test('every category parses and re-serialises', () {
      for (final entry in kIssueCatalogueFixtures.entries) {
        final parsed = IssueCatalogueModel.fromJson(entry.value);

        expect(parsed.category, entry.key);
        expect(parsed.title, isNotEmpty);

        final again = IssueCatalogueModel.fromJson(parsed.toJson());
        expect(again, parsed);
      }
    });

    test('every catalogue offers at least one issue on every path', () {
      for (final catalogue in kIssueCatalogueFixtures.values) {
        final parsed = IssueCatalogueModel.fromJson(catalogue);

        if (parsed.subCategories.isEmpty) {
          expect(parsed.issuesFor(null), isNotEmpty);
          continue;
        }
        for (final sub in parsed.subCategories) {
          if (sub.legacyFlow != null) continue;
          expect(
            parsed.issuesFor(sub.code),
            isNotEmpty,
            reason: '${parsed.category}/${sub.code} has no issues',
          );
        }
      }
    });

    test('every resolvable service code exists in the price table', () {
      final priced = {
        for (final service in [
          ...(kPriceTableFixture['services'] as List),
          ...(kPriceTableFixture['add_ons'] as List),
        ])
          (service as Map<String, dynamic>)['code'] as String,
      };

      for (final catalogue in kIssueCatalogueFixtures.values) {
        final parsed = IssueCatalogueModel.fromJson(catalogue);
        final paths = parsed.subCategories.isEmpty
            ? <String?>[null]
            : parsed.subCategories.map((sub) => sub.code).toList();

        for (final path in paths) {
          final codes = parsed.serviceCodesFor(path);
          expect(codes, isNotEmpty, reason: '${parsed.category}/$path');
          for (final code in codes) {
            expect(
              priced,
              contains(code),
              reason: '${parsed.category}/$path points at an unpriced service',
            );
          }
        }
      }
    });
  });

  group('booking fixtures', () {
    test('professionals round-trip and keep the @pricing ids', () {
      final parsed =
          kProfessionalsFixture.map(BookingProfessionalModel.fromJson).toList();

      expect(parsed.map((p) => p.id), [101, 102, 103, 104, 105, 106]);
      for (final professional in parsed) {
        expect(
          BookingProfessionalModel.fromJson(professional.toJson()),
          professional,
        );
      }
    });

    test('availability round-trips and keeps one empty day', () {
      final parsed =
          kAvailabilityFixture.map(BookingDayModel.fromJson).toList();

      expect(parsed, hasLength(5));
      expect(parsed.where((day) => !day.hasAvailability), hasLength(1));
      for (final day in parsed) {
        expect(BookingDayModel.fromJson(day.toJson()).slots, day.slots);
      }
    });

    test('visit addresses parse with exactly one default', () {
      final parsed = kVisitAddressesFixture.map(AddressModel.fromJson).toList();

      expect(parsed, hasLength(3));
      expect(parsed.where((address) => address.isDefault), hasLength(1));
    });

    test('every request status fixture round-trips', () {
      for (final json in kRequestStatusFixtures) {
        final parsed = SubmittedRequestModel.fromJson(json);
        expect(SubmittedRequestModel.fromJson(parsed.toJson()), parsed);
      }
      expect(
        kRequestStatusFixtures.map((r) => r['status']).toSet(),
        {'pending', 'accepted', 'time_proposed', 'cancelled'},
      );
    });
  });
}
