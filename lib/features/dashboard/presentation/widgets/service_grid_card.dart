import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_palette.dart';
import 'package:m2health/features/dashboard/presentation/home_grid_metrics.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/i18n/translations.g.dart';

class ServiceGridCard extends StatelessWidget {
  final HomeServiceView service;
  final HomeGridMetrics metrics;

  const ServiceGridCard({
    super.key,
    required this.service,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = service.visuals;

    return Semantics(
      button: true,
      label: service.title,
      child: Material(
        color: visuals.tint,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(service.route),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.horizontalPadding,
              vertical: metrics.verticalPadding,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: metrics.badgeHeight,
                  child: service.isNew
                      ? Align(
                          alignment: Alignment.topRight,
                          child: _NewBadge(
                            color: visuals.accent,
                            fontSize: metrics.badgeSize,
                          ),
                        )
                      : null,
                ),
                SvgPicture.asset(
                  visuals.iconPath,
                  width: metrics.iconSize,
                  height: metrics.iconSize,
                ),
                SizedBox(height: metrics.gap),
                SizedBox(
                  height: metrics.titleBoxHeight,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AutoSizeText(
                      service.title,
                      textAlign: TextAlign.center,
                      maxLines: HomeGridMetrics.titleLines,
                      wrapWords: false,
                      minFontSize: metrics.minTitleSize,
                      stepGranularity: 0.5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: DashboardPalette.navy,
                        fontSize: metrics.titleSize,
                        height: HomeGridMetrics.titleLineHeight,
                        letterSpacing: -0.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: metrics.gap / 2),
                SizedBox(
                  height: metrics.descriptionBoxHeight,
                  child: Text(
                    service.description,
                    textAlign: TextAlign.center,
                    maxLines: HomeGridMetrics.descriptionLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: DashboardPalette.muted,
                      fontSize: metrics.descriptionSize,
                      height: HomeGridMetrics.descriptionLineHeight,
                    ),
                  ),
                ),
                SizedBox(height: metrics.gap),
                Container(
                  width: metrics.arrowSize,
                  height: metrics.arrowSize,
                  decoration: BoxDecoration(
                    color: visuals.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: metrics.arrowSize * 0.55,
                    color: visuals.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  final Color color;
  final double fontSize;

  const _NewBadge({required this.color, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        context.t.dashboard.home.badge_new,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          height: HomeGridMetrics.badgeLineHeight,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
