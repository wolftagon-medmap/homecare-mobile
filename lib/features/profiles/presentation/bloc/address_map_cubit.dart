import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';
import 'package:m2health/features/profiles/domain/usecases/save_address.dart';
import 'package:m2health/features/profiles/presentation/bloc/address_map_state.dart';

class AddressMapCubit extends Cubit<AddressMapState> {
  final SaveAddress _saveAddressUseCase;
  Timer? _debounceTimer;

  // Flag to prevent Native Reverse Geocoder from overwriting precise Google Search results
  bool _useNativeReverseGeocoder = true;

  AddressMapCubit({
    required SaveAddress saveAddressUseCase,
  })  : _saveAddressUseCase = saveAddressUseCase,
        super(const AddressMapState());

  Future<void> initialize(Address? address) async {
    if (address != null) {
      emit(state.copyWith(
        center: LatLng(address.latitude, address.longitude),
        googlePlaceId: address.googlePlaceId,
        placeName: address.name,
        formattedAddress: address.formattedAddress,
        shortFormattedAddress: address.shortFormattedAddress,
        status: AddressMapStatus.loaded,
        moveCamera: true,
      ));
      _useNativeReverseGeocoder = false;
      return;
    }

    await loadCurrentLocation();
  }

  Future<void> loadCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _useDefaultLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _useDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _useDefaultLocation();
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      emit(state.copyWith(
        center: latLng,
        moveCamera: true,
        status: AddressMapStatus.loadingAddress,
      ));

      _nativeReverseGeocode(latLng);
    } catch (e) {
      _useDefaultLocation();
    }
  }

  void _useDefaultLocation() {
    emit(state.copyWith(
      moveCamera: true,
      status: AddressMapStatus.loadingAddress,
    ));
    _nativeReverseGeocode(state.center);
  }

  // Camera Idle (Stop Dragging)
  void onCameraIdle(LatLng target) {
    if (!_useNativeReverseGeocoder) {
      _useNativeReverseGeocoder = true; // Use native geocoder next time
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _nativeReverseGeocode(target);
    });
  }

  Future<void> _nativeReverseGeocode(LatLng target) async {
    emit(state.copyWith(status: AddressMapStatus.loadingAddress));

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        target.latitude,
        target.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        log('Placemark selected from map: ${place.toJson()}',
            name: 'AddressMapCubit');
        String address = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        emit(AddressMapState(
          center: target,
          formattedAddress: address,
          status: AddressMapStatus.loaded,
        ));
      }
    } catch (e) {
      log('Reverse geocoding failed: $e', name: 'AddressMapCubit', error: e);
      emit(state.copyWith(
        formattedAddress: "Unknown location",
        status: AddressMapStatus.loaded,
        center: target,
      ));
    }
  }

  void onPlaceSelected(PlaceDetail result) {
    _useNativeReverseGeocoder = false;

    emit(state.copyWith(
      center: LatLng(result.latitude, result.longitude),
      moveCamera: true,
      placeName: result.name,
      formattedAddress: result.formattedAddress,
      shortFormattedAddress: result.shortFormattedAddress,
      googlePlaceId: result.placeId,
      status: AddressMapStatus.loaded,
    ));
  }

  Future<void> saveAddress() async {
    emit(state.copyWith(status: AddressMapStatus.saving));

    final params = SaveAddressParams(
      latitude: state.center.latitude,
      longitude: state.center.longitude,
      formattedAddress: state.formattedAddress,
      googlePlaceId: state.googlePlaceId,
      name: state.placeName,
      shortFormattedAddress: state.shortFormattedAddress,
    );

    final result = await _saveAddressUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AddressMapStatus.failure,
        errorMessage: failure.message,
      )),
      (address) => emit(state.copyWith(
        status: AddressMapStatus.success,
        savedAddress: address,
      )),
    );
  }
}
