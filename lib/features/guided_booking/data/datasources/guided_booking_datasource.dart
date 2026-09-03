import 'package:m2health/features/guided_booking/data/models/booking_models.dart';
import 'package:m2health/features/guided_booking/data/models/issue_catalogue_model.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';

abstract class IssueCatalogueDataSource {
  Future<IssueCatalogueModel> fetchCatalogue(String category);
}

abstract class BookingProfessionalDataSource {
  Future<List<BookingProfessionalModel>> fetchProfessionals({
    required String category,
    int? addressId,
  });

  Future<List<BookingDayModel>> fetchAvailability(
    int professionalId, {
    required String category,
  });
}

abstract class BookingSubmissionDataSource {
  Future<SubmittedRequestModel> submit(GuidedBookingDraft draft);
  Future<SubmittedRequestModel> fetchRequest(int id);
}

abstract class BookingAddressDataSource {
  Future<List<AddressModel>> fetchVisitAddresses();
}

abstract class BookingDraftDataSource {
  Future<GuidedBookingDraft?> load(String category);
  Future<void> save(GuidedBookingDraft draft);
  Future<void> clear(String category);
}
