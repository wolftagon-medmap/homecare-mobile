import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';
import 'package:m2health/features/profiles/domain/entities/place_suggestion.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';

abstract class AddressRepository {
  Future<Either<Failure, Address>> saveAddress(SaveAddressParams params);
  Future<Either<Failure, List<PlaceSuggestion>>> searchPlaces(String query, String sessionToken);
  Future<Either<Failure, PlaceDetail>> getPlaceDetails(String placeId, String sessionToken);
}