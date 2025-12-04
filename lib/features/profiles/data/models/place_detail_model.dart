import 'package:m2health/features/profiles/domain/entities/place_detail.dart';

class PlaceDetailModel extends PlaceDetail {
  const PlaceDetailModel({
    required super.placeId,
    required super.latitude,
    required super.longitude,
    required super.formattedAddress,
    required super.shortFormattedAddress,
    super.name,
  });

  factory PlaceDetailModel.fromJson(Map<String, dynamic> json, String placeId) {
    final location = json['location'] ?? json['geometry']?['location'];

    return PlaceDetailModel(
      placeId: placeId,
      latitude: (location?['latitude'] ?? location?['lat'] ?? 0.0).toDouble(),
      longitude: (location?['longitude'] ?? location?['lng'] ?? 0.0).toDouble(),
      formattedAddress: json['formattedAddress'] ?? '',
      shortFormattedAddress: json['shortFormattedAddress'],
      name: json['name'], // Might be null if you only requested Essentials
    );
  }
}
