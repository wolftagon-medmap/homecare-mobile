import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/i18n/translations.g.dart';

class AddressPickerSheet extends StatelessWidget {
  const AddressPickerSheet({
    super.key,
    required this.addresses,
    required this.selectedId,
  });

  final List<Address> addresses;
  final int? selectedId;

  static Future<int?> show(
    BuildContext context, {
    required List<Address> addresses,
    required int? selectedId,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddressPickerSheet(
        addresses: addresses,
        selectedId: selectedId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.professional;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
            const SizedBox(height: 16),
            Text(
              t.picker_title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (addresses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  t.location_empty,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final selected = address.id == selectedId;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selected ? Const.tosca : Colors.grey,
                    ),
                    title: Text(
                      address.label ?? address.name ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      address.formattedAddress ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () => Navigator.of(context).pop(address.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
