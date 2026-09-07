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
    super.label,
    super.isDefault,
  });

  /// The API serialises model columns in camelCase and hand-assembled keys in
  /// snake_case, so both spellings have to be accepted.
  static dynamic _pick(Map<String, dynamic> json, String snake, String camel) =>
      json[snake] ?? json[camel];

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      latitude: double.tryParse('${json['latitude']}') ?? 0,
      longitude: double.tryParse('${json['longitude']}') ?? 0,
      googlePlaceId: _pick(json, 'google_place_id', 'googlePlaceId') as String?,
      name: json['name'],
      formattedAddress:
          _pick(json, 'formatted_address', 'formattedAddress') as String?,
      shortFormattedAddress:
          _pick(json, 'short_formatted_address', 'shortFormattedAddress')
              as String?,
      label: json['label'],
      isDefault: _pick(json, 'is_default', 'isDefault') == true,
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
      'label': label,
      'is_default': isDefault,
    };
  }
}
