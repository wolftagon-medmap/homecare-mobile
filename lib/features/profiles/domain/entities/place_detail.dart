import 'package:equatable/equatable.dart';

class PlaceDetail extends Equatable {
  final String placeId;
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String? shortFormattedAddress;
  final String? name;

  const PlaceDetail({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.shortFormattedAddress,
    this.name,
  });

  @override
  List<Object?> get props => [placeId, latitude, longitude, formattedAddress, shortFormattedAddress, name];

  PlaceDetail copyWith({
    String? placeId,
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? shortFormattedAddress,
    String? name,
  }) {
    return PlaceDetail(
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      shortFormattedAddress: shortFormattedAddress ?? this.shortFormattedAddress,
      name: name ?? this.name,
    );
  }
}