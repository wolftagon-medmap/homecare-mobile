import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';
import 'package:m2health/features/profiles/presentation/bloc/address_map_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/address_map_state.dart';
import 'package:m2health/features/profiles/presentation/pages/address_search_page.dart';
import 'package:m2health/service_locator.dart';

class AddressMapPage extends StatelessWidget {
  final Address? initialAddress;

  const AddressMapPage({super.key, this.initialAddress});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressMapCubit(
        saveAddressUseCase: sl(),
      )..initialize(initialAddress),
      child: const _AddressMapView(),
    );
  }
}

class _AddressMapView extends StatefulWidget {
  const _AddressMapView();

  @override
  State<_AddressMapView> createState() => _AddressMapViewState();
}

class _AddressMapViewState extends State<_AddressMapView> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AddressMapCubit, AddressMapState>(
        listener: (context, state) async {
          if (state.status == AddressMapStatus.success) {
            Navigator.pop<Address>(context, state.savedAddress);
          } else if (state.status == AddressMapStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? "Error"),
                  backgroundColor: Colors.red),
            );
          }

          if (state.moveCamera) {
            // Move camera to new position
            final controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newLatLng(state.center));
          }
        },
        builder: (context, state) {
          if (state.status == AddressMapStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Google Map
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: state.center,
                          zoom: 16,
                        ),
                        onMapCreated: (controller) =>
                            _controller.complete(controller),
                        onCameraIdle: () async {
                          final controller = await _controller.future;
                          final region = await controller.getVisibleRegion();
                          final center = LatLng(
                            (region.northeast.latitude +
                                    region.southwest.latitude) /
                                2,
                            (region.northeast.longitude +
                                    region.southwest.longitude) /
                                2,
                          );
                          if (context.mounted) {
                            context
                                .read<AddressMapCubit>()
                                .onCameraIdle(center);
                          }
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        // markers: {
                        //   Marker(
                        //     markerId: const MarkerId('selected-location'),
                        //     position: state.center,
                        //     infoWindow: InfoWindow(
                        //       title: state.placeName ?? "Selected Location",
                        //       snippet: state.formattedAddress,
                        //     ),
                        //   ),
                        // },
                      ),

                      // Center Pin
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 50), // equal to size of icon
                          child: Icon(
                            Icons.location_on_sharp,
                            size: 50,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      // Top Bar (Back Button & Search)
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: _buildTopBar(context, state),
                      ),

// My Location Button
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () async {
                            context
                                .read<AddressMapCubit>()
                                .loadCurrentLocation();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 8)
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.black,
                              size: 28,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Bottom Sheet
                _AddressBottomSheet(state: state),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: _SaveButton(
          isLoading: context.watch<AddressMapCubit>().state.status ==
              AddressMapStatus.saving,
          onPressed: () {
            context.read<AddressMapCubit>().saveAddress();
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AddressMapState state) {
    return Row(
      spacing: 16,
      children: [
        // Back Button
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        // Search Bar
        Expanded(
          child: GestureDetector(
            onTap: () async {
              // Open Address Search Page and await for result
              final result = await Navigator.push<PlaceDetail>(
                context,
                MaterialPageRoute(builder: (_) => const AddressSearchPage()),
              );
              if (result != null && context.mounted) {
                context.read<AddressMapCubit>().onPlaceSelected(result);
              }
            },
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8)
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Search location",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressBottomSheet extends StatelessWidget {
  final AddressMapState state;

  const _AddressBottomSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Location",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Const.aqua, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: state.status == AddressMapStatus.loadingAddress
                    ? const LinearProgressIndicator(color: Const.aqua)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.placeName != null)
                            Text(
                              state.placeName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (state.placeName != null)
                            const SizedBox(height: 4),
                          Text(
                            state.formattedAddress ?? "Unknown location",
                            style: TextStyle(
                                fontSize: state.placeName != null ? 12 : 14,
                                color: state.placeName != null
                                    ? Colors.grey[600]
                                    : Colors.black87,
                                height: 1.3),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SaveButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Const.aqua,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Text(
                "Confirm Location",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
