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
    int? addressId,
  }) =>
      repository.getProfessionals(category: category, addressId: addressId);
}

class GetBookingAvailability {
  final BookingProfessionalRepository repository;

  GetBookingAvailability(this.repository);

  Future<Either<Failure, List<BookingDay>>> call(int professionalId) =>
      repository.getAvailability(professionalId);
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

class GetBookingRequest {
  final BookingSubmissionRepository repository;

  GetBookingRequest(this.repository);

  Future<Either<Failure, SubmittedRequest>> call(int id) =>
      repository.getRequest(id);
}
