import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';
import 'package:m2health/features/guided_booking/domain/repositories/guided_booking_repository.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

class GetIssueCatalogue {
  final IssueCatalogueRepository repository;

  GetIssueCatalogue(this.repository);

  Future<Either<Failure, IssueCatalogue>> call(String category) =>
      repository.getCatalogue(category);
}

class GetBookingProfessionals {
  final BookingProfessionalRepository repository;

  GetBookingProfessionals(this.repository);

  Future<Either<Failure, List<BookingProfessional>>> call({
    required String category,
    double? latitude,
    double? longitude,
    String? name,
  }) =>
      repository.getProfessionals(
        category: category,
        latitude: latitude,
        longitude: longitude,
        name: name,
      );
}

class GetBookingAvailability {
  final BookingProfessionalRepository repository;

  GetBookingAvailability(this.repository);

  Future<Either<Failure, List<BookingDay>>> call(
    int professionalId, {
    required String category,
  }) =>
      repository.getAvailability(professionalId, category: category);
}

class GetVisitAddresses {
  final BookingAddressRepository repository;

  GetVisitAddresses(this.repository);

  Future<Either<Failure, List<Address>>> call() =>
      repository.getVisitAddresses();
}

class SubmitBookingRequest {
  final BookingSubmissionRepository repository;

  SubmitBookingRequest(this.repository);

  Future<Either<Failure, SubmittedRequest>> call(GuidedBookingDraft draft) =>
      repository.submit(draft);
}

class LoadBookingDraft {
  final BookingDraftRepository repository;

  LoadBookingDraft(this.repository);

  Future<Either<Failure, GuidedBookingDraft?>> call(String category) =>
      repository.load(category);
}

class SaveBookingDraft {
  final BookingDraftRepository repository;

  SaveBookingDraft(this.repository);

  Future<Either<Failure, Unit>> call(GuidedBookingDraft draft) =>
      repository.save(draft);
}

class ClearBookingDraft {
  final BookingDraftRepository repository;

  ClearBookingDraft(this.repository);

  Future<Either<Failure, Unit>> call(String category) =>
      repository.clear(category);
}
