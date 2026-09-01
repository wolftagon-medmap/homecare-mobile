import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/i18n/translations.g.dart';

class ServiceGridCard extends StatelessWidget {
  final HomeServiceView service;

  const ServiceGridCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final visuals = service.visuals;

    return GestureDetector(
      onTap: () => context.push(service.route),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
        decoration: BoxDecoration(
          color: visuals.tint,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 18,
              child: service.isNew
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
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
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            SvgPicture.asset(visuals.iconPath, width: 34, height: 34),
            const SizedBox(height: 10),
            // 11.5px with tightened tracking so "Physiotherapy" stays on one
            // line at 360dp. Loosening the size, tracking or card padding
            // breaks it mid-word.
            Text(
              service.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: DashboardPalette.navy,
                fontSize: 11.5,
                height: 1.2,
                letterSpacing: -0.1,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              service.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DashboardPalette.muted,
                fontSize: 9.8,
                height: 1.32,
              ),
            ),
            const Spacer(),
            const SizedBox(height: 8),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: visuals.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward, size: 14, color: visuals.accent),
            ),
          ],
        ),
      ),
    );
  }
}
