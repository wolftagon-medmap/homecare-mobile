import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';

/// Adds a new saved address for the account (home, parent's house, etc.).
class CreateAddress {
  final AddressRepository repository;

  CreateAddress(this.repository);

  Future<Either<Failure, Address>> call(CreateAddressParams params) async {
    return await repository.createAddress(params);
  }
}

class CreateAddressParams {
  final String label;
  final double latitude;
  final double longitude;
  final String? googlePlaceId;
  final String? name;
  final String? formattedAddress;
  final String? shortFormattedAddress;
  final bool? isDefault;

  CreateAddressParams({
    required this.label,
    required this.latitude,
    required this.longitude,
    this.googlePlaceId,
    this.name,
    this.formattedAddress,
    this.shortFormattedAddress,
    this.isDefault,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'latitude': latitude,
        'longitude': longitude,
        'google_place_id': googlePlaceId,
        'name': name,
        'formatted_address': formattedAddress,
        'short_formatted_address': shortFormattedAddress,
        'is_default': isDefault,
      };
}
