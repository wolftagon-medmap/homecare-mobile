import 'package:flutter/widgets.dart';
import 'package:m2health/core/presentation/responsive/responsive.dart';

class HomeGridMetrics {
  static const _range = FluidRange(90, 190);

  static const titleLines = 2;
  static const descriptionLines = 2;
  static const titleLineHeight = 1.2;
  static const descriptionLineHeight = 1.3;
  static const badgeLineHeight = 1.2;
  static const minTitleScale = 0.7;

  final TextScaler scaler;
  final double titleSize;
  final double descriptionSize;
  final double badgeSize;
  final double iconSize;
  final double arrowSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double gap;

  const HomeGridMetrics._({
    required this.scaler,
    required this.titleSize,
    required this.descriptionSize,
    required this.badgeSize,
    required this.iconSize,
    required this.arrowSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.gap,
  });

  factory HomeGridMetrics.of(double cardWidth, TextScaler scaler) {
    double size(double min, double max) => _range.lerp(cardWidth, min, max);

    return HomeGridMetrics._(
      scaler: scaler,
      titleSize: _half(size(12, 18)),
      descriptionSize: size(10, 14),
      badgeSize: size(8, 10),
      iconSize: size(32, 60),
      arrowSize: size(26, 40),
      horizontalPadding: size(6, 12),
      verticalPadding: size(10, 16),
      gap: size(6, 10),
    );
  }

  static double _half(double value) => (value * 2).floorToDouble() / 2;

  double get minTitleSize => _half(titleSize * minTitleScale);

  double get badgeHeight => scaler.scale(badgeSize) * badgeLineHeight + 4;

  double get titleBoxHeight =>
      scaler.scale(titleSize) * titleLineHeight * titleLines;

  double get descriptionBoxHeight =>
      scaler.scale(descriptionSize) * descriptionLineHeight * descriptionLines;

  double get cardHeight =>
      verticalPadding * 2 +
      badgeHeight +
      iconSize +
      gap +
      titleBoxHeight +
      gap / 2 +
      descriptionBoxHeight +
      gap +
      arrowSize;
}
