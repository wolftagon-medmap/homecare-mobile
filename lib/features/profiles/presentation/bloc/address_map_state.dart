import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

enum AddressMapStatus {
  initial,
  loadingAddress,
  loaded,
  saving,
  success,
  failure
}

class AddressMapState extends Equatable {
  final AddressMapStatus status;
  final LatLng center; // The visual center of the map
  final String? errorMessage;
  final Address? savedAddress;

  // Google Places Data (Nullable - only present if selected from search)
  final String? googlePlaceId;
  final String? placeName;
  final String? formattedAddress;
  final String? shortFormattedAddress;

  final bool moveCamera;

  const AddressMapState({
    this.status = AddressMapStatus.initial,
    this.center = const LatLng(1.2974346, 103.8496195), // Default Singapore
    this.errorMessage,
    this.savedAddress,
    this.googlePlaceId,
    this.placeName,
    this.formattedAddress,
    this.shortFormattedAddress,
    this.moveCamera = false,
  });

  AddressMapState copyWith({
    AddressMapStatus? status,
    LatLng? center,
    String? errorMessage,
    Address? savedAddress,
    String? googlePlaceId,
    String? placeName,
    String? formattedAddress,
    String? shortFormattedAddress,
    bool? moveCamera,
  }) {
    return AddressMapState(
      status: status ?? this.status,
      center: center ?? this.center,
      errorMessage: errorMessage ?? this.errorMessage,
      savedAddress: savedAddress ?? this.savedAddress,
      moveCamera: moveCamera ?? false, // Reset trigger by default
      googlePlaceId: googlePlaceId ?? this.googlePlaceId,
      placeName: placeName ?? this.placeName,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      shortFormattedAddress:
          shortFormattedAddress ?? this.shortFormattedAddress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        center,
        errorMessage,
        savedAddress,
        googlePlaceId,
        placeName,
        formattedAddress,
        shortFormattedAddress,
        moveCamera,
      ];
}
