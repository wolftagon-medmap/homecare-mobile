import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/dashboard/domain/service_pricing_category.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/etc/pricing/presentation/widgets/starting_from_price.dart';
import 'package:m2health/i18n/translations.g.dart';

class ServiceListCard extends StatelessWidget {
  final HomeServiceView service;

  const ServiceListCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final visuals = service.visuals;

    return Semantics(
      button: true,
      label: service.title,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: DashboardPalette.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(service.route),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: visuals.tint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: SvgPicture.asset(visuals.iconPath,
                        width: 30, height: 30),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              service.title,
                              style: const TextStyle(
                                color: DashboardPalette.navy,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (service.isNew) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: visuals.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                context.t.dashboard.home.badge_new,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: const TextStyle(
                          color: DashboardPalette.muted,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                      StartingFromPrice(
                        category: pricingCategoryFor(service.service.id),
                        dense: true,
                        padding: const EdgeInsets.only(top: 6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: visuals.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward,
                      size: 15, color: visuals.accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
