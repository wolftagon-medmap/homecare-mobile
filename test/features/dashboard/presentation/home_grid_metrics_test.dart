import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/dashboard/presentation/home_grid_metrics.dart';

void main() {
  const normal = TextScaler.noScaling;

  test('grows with the card and holds past the anchors', () {
    final narrow = HomeGridMetrics.of(90, normal);
    final wide = HomeGridMetrics.of(190, normal);
    final wider = HomeGridMetrics.of(400, normal);

    expect(wide.titleSize, greaterThan(narrow.titleSize));
    expect(wide.iconSize, greaterThan(narrow.iconSize));
    expect(wider.titleSize, wide.titleSize);
    expect(HomeGridMetrics.of(40, normal).titleSize, narrow.titleSize);
  });

  test('reserves taller boxes as the text scale grows', () {
    final base = HomeGridMetrics.of(110, normal);
    final large = HomeGridMetrics.of(110, const TextScaler.linear(1.3));

    expect(large.titleBoxHeight, greaterThan(base.titleBoxHeight));
    expect(large.cardHeight, greaterThan(base.cardHeight));
  });

  test('keeps title sizes on the half-point grid AutoSizeText steps in', () {
    for (var width = 80.0; width <= 200; width += 7) {
      final metrics = HomeGridMetrics.of(width, normal);
      expect((metrics.titleSize * 2) % 1, 0);
      expect((metrics.minTitleSize * 2) % 1, 0);
      expect(metrics.minTitleSize, lessThan(metrics.titleSize));
    }
  });
}
