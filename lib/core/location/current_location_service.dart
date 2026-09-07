import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m2health/core/location/visit_location.dart';

/// Reads the device's position for the visit location.
///
/// [resolveIfGranted] never prompts: it is for the automatic path, where an
/// unexplained permission dialog on opening a screen would be worse than an
/// empty picker. [resolveWithPrompt] is the explicit tap.
class CurrentLocationService {
  Future<VisitLocation?> resolveIfGranted() async {
    final permission = await Geolocator.checkPermission();
    final granted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
    if (!granted) return null;
    return _resolve();
  }

  Future<VisitLocation?> resolveWithPrompt() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return _resolve();
  }

  Future<VisitLocation?> _resolve() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      final position = await Geolocator.getCurrentPosition();
      return VisitLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        label: 'Current location',
        source: VisitLocationSource.current,
        formattedAddress:
            await _describe(position.latitude, position.longitude),
      );
    } catch (error, stackTrace) {
      log(
        'Could not read the device location',
        name: 'location.current',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<String?> _describe(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;
      final place = placemarks.first;
      return [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
      ].where((part) => part != null && part.isNotEmpty).join(', ');
    } catch (_) {
      return null;
    }
  }
}
