import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';

class GetPlaceDetails {
  final AddressRepository repository;

  GetPlaceDetails(this.repository);

  Future<Either<Failure, PlaceDetail>> call(String placeId, String sessionToken) async {
    return await repository.getPlaceDetails(placeId, sessionToken);
  }
}