import 'package:m2health/features/profiles/domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.latitude,
    required super.longitude,
    super.googlePlaceId,
    super.name,
    super.formattedAddress,
    super.shortFormattedAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      googlePlaceId: json['google_place_id'],
      name: json['name'],
      formattedAddress: json['formatted_address'],
      shortFormattedAddress: json['short_formatted_address'],
    );
  }

  // Maps to the backend JSON structure (backend still uses 'location' table/fields if you kept it)
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'google_place_id': googlePlaceId,
      'name': name,
      'formatted_address': formattedAddress,
      'short_formatted_address': shortFormattedAddress,
    };
  }
}