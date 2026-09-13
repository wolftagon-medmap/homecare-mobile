import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/domain/entities/block.dart';

/// The patient's map-picked visit location, shown as a mini-map bubble in the
/// transcript instead of the plain "I've set the visit location to …" text.
class LocationSetBubble extends StatelessWidget {
  final LocationSetBlock block;
  const LocationSetBubble({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final lat = block.lat;
    final lng = block.lng;
    final hasCoords = lat != null && lng != null;
    final position = hasCoords ? LatLng(lat, lng) : null;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: Const.aqua,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (position != null)
              SizedBox(
                height: 130,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: position, zoom: 15),
                  markers: {
                    Marker(
                        markerId: const MarkerId('visit_location'),
                        position: position),
                  },
                  liteModeEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  mapType: MapType.normal,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      block.address ?? 'Visit location set',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
