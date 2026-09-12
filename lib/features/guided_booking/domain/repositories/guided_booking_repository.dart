import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';
import 'package:m2health/features/user_profiles/domain/entities/address.dart';

abstract class IssueCatalogueRepository {
  Future<Either<Failure, IssueCatalogue>> getCatalogue(String category);
}

abstract class BookingProfessionalRepository {
  Future<Either<Failure, List<BookingProfessional>>> getProfessionals({
    required String category,
    double? latitude,
    double? longitude,
    String? name,
  });

  Future<Either<Failure, List<BookingDay>>> getAvailability(
    int professionalId, {
    required String category,
  });
}

abstract class BookingAddressRepository {
  Future<Either<Failure, List<Address>>> getVisitAddresses();
}

abstract class BookingSubmissionRepository {
  Future<Either<Failure, SubmittedRequest>> submit(GuidedBookingDraft draft);
}

abstract class BookingDraftRepository {
  Future<Either<Failure, GuidedBookingDraft?>> load(String category);
  Future<Either<Failure, Unit>> save(GuidedBookingDraft draft);
  Future<Either<Failure, Unit>> clear(String category);
}
