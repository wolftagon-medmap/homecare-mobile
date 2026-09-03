import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_datasource.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';
import 'package:m2health/features/guided_booking/domain/repositories/guided_booking_repository.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
  try {
    return Right(await run());
  } on Failure catch (failure) {
    return Left(failure);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

class IssueCatalogueRepositoryImpl implements IssueCatalogueRepository {
  final IssueCatalogueDataSource dataSource;

  IssueCatalogueRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, IssueCatalogue>> getCatalogue(String category) =>
      _guard(() => dataSource.fetchCatalogue(category));
}

class BookingProfessionalRepositoryImpl
    implements BookingProfessionalRepository {
  final BookingProfessionalDataSource dataSource;

  BookingProfessionalRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<BookingProfessional>>> getProfessionals({
    required String category,
    int? addressId,
  }) =>
      _guard(() => dataSource.fetchProfessionals(
            category: category,
            addressId: addressId,
          ));

  @override
  Future<Either<Failure, List<BookingDay>>> getAvailability(
    int professionalId, {
    required String category,
  }) =>
      _guard(
        () => dataSource.fetchAvailability(professionalId, category: category),
      );
}

class BookingAddressRepositoryImpl implements BookingAddressRepository {
  final BookingAddressDataSource dataSource;

  BookingAddressRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Address>>> getVisitAddresses() =>
      _guard(() => dataSource.fetchVisitAddresses());
}

class BookingSubmissionRepositoryImpl implements BookingSubmissionRepository {
  final BookingSubmissionDataSource dataSource;

  BookingSubmissionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, SubmittedRequest>> submit(GuidedBookingDraft draft) =>
      _guard(() => dataSource.submit(draft));

  @override
  Future<Either<Failure, SubmittedRequest>> getRequest(int id) =>
      _guard(() => dataSource.fetchRequest(id));
}

class BookingDraftRepositoryImpl implements BookingDraftRepository {
  final BookingDraftDataSource dataSource;

  BookingDraftRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, GuidedBookingDraft?>> load(String category) =>
      _guard(() => dataSource.load(category));

  @override
  Future<Either<Failure, Unit>> save(GuidedBookingDraft draft) =>
      _guard(() async {
        await dataSource.save(draft);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> clear(String category) => _guard(() async {
        await dataSource.clear(category);
        return unit;
      });
}
