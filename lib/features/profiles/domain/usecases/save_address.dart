import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';

class SaveAddress {
  final AddressRepository repository;

  SaveAddress(this.repository);

  Future<Either<Failure, Address>> call(SaveAddressParams params) async {
    return await repository.saveAddress(params);
  }
}

class SaveAddressParams {
  final double latitude;
  final double longitude;
  final String? googlePlaceId;
  final String? name;
  final String? formattedAddress;
  final String? shortFormattedAddress;

  SaveAddressParams({
    required this.latitude,
    required this.longitude,
    this.googlePlaceId,
    this.name,
    this.formattedAddress,
    this.shortFormattedAddress,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'google_place_id': googlePlaceId,
    'name': name,
    'formatted_address': formattedAddress,
    'short_formatted_address': shortFormattedAddress,
  };
}