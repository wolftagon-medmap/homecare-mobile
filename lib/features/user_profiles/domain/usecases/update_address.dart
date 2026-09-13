import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/user_profiles/domain/entities/address.dart';
import 'package:m2health/features/user_profiles/domain/repositories/address_repository.dart';

class UpdateAddress {
  final AddressRepository repository;

  UpdateAddress(this.repository);

  Future<Either<Failure, Address>> call(UpdateAddressParams params) async {
    return await repository.updateAddress(params);
  }
}

class UpdateAddressParams {
  final int id;
  final String? label;
  final double? latitude;
  final double? longitude;
  final String? googlePlaceId;
  final String? name;
  final String? formattedAddress;
  final String? shortFormattedAddress;
  final bool? isDefault;

  UpdateAddressParams({
    required this.id,
    this.label,
    this.latitude,
    this.longitude,
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
