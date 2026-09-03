import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/location/current_location_service.dart';
import 'package:m2health/core/location/visit_location.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';
import 'package:m2health/features/profiles/presentation/pages/address_map_page.dart';
import 'package:m2health/features/profiles/presentation/pages/address_search_page.dart';
import 'package:m2health/i18n/translations.g.dart';

/// Picks where the visit happens, from any of the three sources a patient
/// actually has: an address they saved, where they are now, or a spot they
/// point at. Shared by both booking flows.
Future<VisitLocation?> showVisitLocationPicker(
  BuildContext context, {
  required List<Address> addresses,
  required VisitLocation? selected,
}) {
  return showModalBottomSheet<VisitLocation>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _VisitLocationPicker(
      addresses: addresses,
      selected: selected,
    ),
  );
}

class _VisitLocationPicker extends StatefulWidget {
  const _VisitLocationPicker({required this.addresses, required this.selected});

  final List<Address> addresses;
  final VisitLocation? selected;

  @override
  State<_VisitLocationPicker> createState() => _VisitLocationPickerState();
}

class _VisitLocationPickerState extends State<_VisitLocationPicker> {
  bool _locating = false;

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    final resolved = await CurrentLocationService().resolveWithPrompt();
    if (!mounted) return;
    setState(() => _locating = false);

    if (resolved == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.sharedBooking.location.denied)),
      );
      return;
    }
    Navigator.of(context).pop(resolved);
  }

  Future<void> _pickOnMap() async {
    final picked = await Navigator.of(context).push<Address>(
      MaterialPageRoute(builder: (_) => const AddressMapPage(pickOnly: true)),
    );
    if (picked == null || !mounted) return;
    Navigator.of(context).pop(
      VisitLocation(
        latitude: picked.latitude,
        longitude: picked.longitude,
        label: picked.label ?? picked.name ?? _fallbackLabel(context),
        source: VisitLocationSource.picked,
        formattedAddress: picked.formattedAddress,
        googlePlaceId: picked.googlePlaceId,
        name: picked.name,
      ),
    );
  }

  Future<void> _search() async {
    final place = await Navigator.of(context).push<PlaceDetail>(
      MaterialPageRoute(builder: (_) => const AddressSearchPage()),
    );
    if (place == null || !mounted) return;
    Navigator.of(context).pop(
      VisitLocation(
        latitude: place.latitude,
        longitude: place.longitude,
        label: place.name ?? _fallbackLabel(context),
        source: VisitLocationSource.picked,
        formattedAddress: place.formattedAddress,
        googlePlaceId: place.placeId,
        name: place.name,
      ),
    );
  }

  String _fallbackLabel(BuildContext context) =>
      context.t.sharedBooking.location.picked_label;

  @override
  Widget build(BuildContext context) {
    final t = context.t.sharedBooking.location;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              t.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            _SearchBar(hint: t.search_hint, onTap: _search),
            const SizedBox(height: 6),
            _ActionRow(
              icon: Icons.map_outlined,
              label: t.pick_on_map,
              onTap: _pickOnMap,
            ),
            _ActionRow(
              icon: Icons.my_location,
              label: t.use_current,
              subtitle: widget.selected?.source == VisitLocationSource.current
                  ? widget.selected?.formattedAddress
                  : null,
              busy: _locating,
              onTap: _locating ? null : _useCurrentLocation,
            ),
            if (widget.addresses.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                t.saved_heading,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Const.contentTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.addresses.length,
                  itemBuilder: (context, index) {
                    final address = widget.addresses[index];
                    return _SavedAddressRow(
                      address: address,
                      selected: address.id == widget.selected?.addressId,
                      onTap: () => Navigator.of(context).pop(
                        VisitLocation.fromAddress(address),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Const.borderSubtle),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  fontSize: 14,
                  color: Const.placeholderTextColor,
                ),
              ),
            ),
            const Icon(Icons.search, size: 20, color: Const.contentTextColor),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: busy
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, color: Const.tosca, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: Const.tosca,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Const.contentTextColor,
              ),
            ),
      onTap: onTap,
    );
  }
}

class _SavedAddressRow extends StatelessWidget {
  const _SavedAddressRow({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final Address address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? Const.tosca : Colors.grey,
        size: 22,
      ),
      title: Text(
        address.label ?? address.name ?? '',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: address.formattedAddress == null
          ? null
          : Text(
              address.formattedAddress!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
      onTap: onTap,
    );
  }
}
