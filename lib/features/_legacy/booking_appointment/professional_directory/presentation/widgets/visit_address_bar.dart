import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/user_profiles/domain/entities/address.dart';
import 'package:m2health/i18n/translations.g.dart';

class VisitAddressBar extends StatelessWidget {
  final Address? selectedAddress;
  final bool isLoading;
  final VoidCallback onTap;

  const VisitAddressBar({
    super.key,
    required this.selectedAddress,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = isLoading
        ? context.t.booking.professional_search.visit_address.loading
        : selectedAddress?.formattedAddress ??
            selectedAddress?.label ??
            context.t.booking.professional_search.visit_address.empty;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Const.aqua.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Const.aqua, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t.booking.professional_search.visit_address.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLoading)
              const Icon(Icons.keyboard_arrow_down, color: Const.aqua),
          ],
        ),
      ),
    );
  }
}
