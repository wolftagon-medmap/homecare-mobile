import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final double latitude;
  final double longitude;
  final String? googlePlaceId;
  final String? name;
  final String? formattedAddress;
  final String? shortFormattedAddress;

  const Address({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.googlePlaceId,
    this.name,
    this.formattedAddress,
    this.shortFormattedAddress,
  });

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        googlePlaceId,
        name,
        formattedAddress,
        shortFormattedAddress,
      ];
}