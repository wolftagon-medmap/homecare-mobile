import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';
import 'package:m2health/features/profiles/domain/entities/place_suggestion.dart';

class SearchPlaces {
  final AddressRepository repository;

  SearchPlaces(this.repository);

  Future<Either<Failure, List<PlaceSuggestion>>> call(
      String query, String sessionToken) async {
    // Avoid unnecessary API calls for short queries
    if (query.length < 3) {
      return const Right([]);
    }
    return await repository.searchPlaces(query, sessionToken);
  }
}
