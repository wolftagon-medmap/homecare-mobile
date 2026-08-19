import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final double latitude;
  final double longitude;
  final String? googlePlaceId;
  final String? name;
  final String? formattedAddress;
  final String? shortFormattedAddress;

  /// How the patient identifies this address, e.g. 'Home', "Parent's House".
  final String? label;

  /// At most one true per account — the visit location used unless another is picked.
  final bool isDefault;

  const Address({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.googlePlaceId,
    this.name,
    this.formattedAddress,
    this.shortFormattedAddress,
    this.label,
    this.isDefault = false,
  });

  Address copyWith({
    int? id,
    double? latitude,
    double? longitude,
    String? googlePlaceId,
    String? name,
    String? formattedAddress,
    String? shortFormattedAddress,
    String? label,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      googlePlaceId: googlePlaceId ?? this.googlePlaceId,
      name: name ?? this.name,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      shortFormattedAddress: shortFormattedAddress ?? this.shortFormattedAddress,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        googlePlaceId,
        name,
        formattedAddress,
        shortFormattedAddress,
        label,
        isDefault,
      ];
}
