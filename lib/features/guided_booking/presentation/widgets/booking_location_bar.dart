import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/location/visit_location.dart';
import 'package:m2health/i18n/translations.g.dart';

class BookingLocationBar extends StatelessWidget {
  const BookingLocationBar({
    super.key,
    required this.location,
    required this.isLoading,
    required this.onTap,
  });

  final VisitLocation? location;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t.sharedBooking.location;
    final subtitle = isLoading
        ? t.loading
        : location?.formattedAddress ?? location?.label ?? t.empty;

    return Material(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: InkWell(
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
                const Icon(Icons.location_on, color: Const.tosca, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.bar_title,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Const.contentTextColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ProText.captionStrong,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Const.tosca,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
