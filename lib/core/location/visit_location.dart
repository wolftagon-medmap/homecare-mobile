import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

enum VisitLocationSource { saved, current, picked }

/// Where the visit happens. A saved address is only one of the ways to say it —
/// the device's position and a spot on the map are equally valid, and neither
/// has an id until the booking is actually sent.
class VisitLocation extends Equatable {
  const VisitLocation({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.source,
    this.addressId,
    this.formattedAddress,
    this.googlePlaceId,
    this.name,
  });

  factory VisitLocation.fromAddress(Address address) {
    return VisitLocation(
      latitude: address.latitude,
      longitude: address.longitude,
      label: address.label ?? address.name ?? '',
      source: VisitLocationSource.saved,
      addressId: address.id,
      formattedAddress: address.formattedAddress,
      googlePlaceId: address.googlePlaceId,
      name: address.name,
    );
  }

  final double latitude;
  final double longitude;
  final String label;
  final VisitLocationSource source;

  /// Set only when this is already a row in the address book.
  final int? addressId;

  final String? formattedAddress;
  final String? googlePlaceId;
  final String? name;

  bool get isSaved => addressId != null;

  /// The payload `POST /v1/addresses` expects, for persisting a one-off pick
  /// at submit time.
  Map<String, dynamic> toCreatePayload() => {
        'label': label.isEmpty ? 'Visit address' : label,
        'latitude': latitude,
        'longitude': longitude,
        if (googlePlaceId != null) 'google_place_id': googlePlaceId,
        if (name != null) 'name': name,
        if (formattedAddress != null) 'formatted_address': formattedAddress,
      };

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        label,
        source,
        addressId,
        formattedAddress,
      ];
}
