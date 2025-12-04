import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/data/datasources/address_remote_datasource.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';
import 'package:m2health/features/profiles/domain/entities/place_suggestion.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDatasource remoteDatasource;

  AddressRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, Address>> saveAddress(SaveAddressParams params) async {
    try {
      final address = await remoteDatasource.saveAddress(params.toJson());
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaceSuggestion>>> searchPlaces(
      String query, String sessionToken) async {
    try {
      final result = await remoteDatasource.searchPlaces(query, sessionToken);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlaceDetail>> getPlaceDetails(
      String placeId, String sessionToken) async {
    try {
      final result =
          await remoteDatasource.getPlaceDetails(placeId, sessionToken);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
