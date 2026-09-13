import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/etc/pricing/domain/entities/service_price.dart';
import 'package:m2health/i18n/translations.g.dart';

Future<void> showAddOnDetailSheet(
  BuildContext context, {
  required ServicePrice addOn,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _AddOnDetailSheet(addOn: addOn),
  );
}

class _AddOnDetailSheet extends StatelessWidget {
  const _AddOnDetailSheet({required this.addOn});

  final ServicePrice addOn;

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking.add_ons;
    final description = addOn.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              addOn.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${addOn.floorPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Const.aqua,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasDescription ? description : t.no_description,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: hasDescription
                    ? Const.primaryTextColor
                    : Const.contentTextColor,
                fontStyle: hasDescription ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
