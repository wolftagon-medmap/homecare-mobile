import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_datasource.dart';
import 'package:m2health/features/guided_booking/data/fixtures/booking_fixtures.dart';
import 'package:m2health/features/guided_booking/data/fixtures/issue_catalogue_fixture.dart';
import 'package:m2health/features/guided_booking/data/models/booking_models.dart';
import 'package:m2health/features/guided_booking/data/models/issue_catalogue_model.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';

const Duration _fixtureLatency = Duration(milliseconds: 250);

class IssueCatalogueLocalDataSource implements IssueCatalogueDataSource {
  @override
  Future<IssueCatalogueModel> fetchCatalogue(String category) async {
    await Future.delayed(_fixtureLatency);
    final json = kIssueCatalogueFixtures[category];
    if (json == null) {
      throw NotFoundFailure('No issue catalogue for "$category"');
    }
    return IssueCatalogueModel.fromJson(json);
  }
}

class BookingProfessionalLocalDataSource
    implements BookingProfessionalDataSource {
  @override
  Future<List<BookingProfessionalModel>> fetchProfessionals({
    required String category,
    int? addressId,
  }) async {
    await Future.delayed(_fixtureLatency);
    return kProfessionalsFixture
        .map(BookingProfessionalModel.fromJson)
        .where((professional) =>
            professional.coversCategory(category) &&
            professional.servesAddress(addressId))
        .toList();
  }

  @override
  Future<List<BookingDayModel>> fetchAvailability(
    int professionalId, {
    required String category,
  }) async {
    await Future.delayed(_fixtureLatency);
    return kAvailabilityFixture.map(BookingDayModel.fromJson).toList();
  }
}

class BookingSubmissionLocalDataSource implements BookingSubmissionDataSource {
  @override
  Future<SubmittedRequestModel> submit(GuidedBookingDraft draft) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return SubmittedRequestModel.fromJson(kSubmittedRequestFixture);
  }

  @override
  Future<SubmittedRequestModel> fetchRequest(int id) async {
    await Future.delayed(_fixtureLatency);
    final json = kRequestStatusFixtures.firstWhere(
      (request) => request['id'] == id,
      orElse: () => kSubmittedRequestFixture,
    );
    return SubmittedRequestModel.fromJson(json);
  }
}

class BookingAddressLocalDataSource implements BookingAddressDataSource {
  @override
  Future<List<AddressModel>> fetchVisitAddresses() async {
    await Future.delayed(_fixtureLatency);
    return kVisitAddressesFixture.map(AddressModel.fromJson).toList();
  }
}

class BookingDraftLocalDataSource implements BookingDraftDataSource {
  static const String _prefix = 'guided_booking_draft.';

  final SharedPreferences prefs;

  BookingDraftLocalDataSource(this.prefs);

  @override
  Future<GuidedBookingDraft?> load(String category) async {
    final raw = prefs.getString('$_prefix$category');
    if (raw == null) return null;
    try {
      return GuidedBookingDraftModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on FormatException {
      await clear(category);
      return null;
    }
  }

  @override
  Future<void> save(GuidedBookingDraft draft) async {
    await prefs.setString(
      '$_prefix${draft.category}',
      jsonEncode(draft.toJson()),
    );
  }

  @override
  Future<void> clear(String category) async {
    await prefs.remove('$_prefix$category');
  }
}
