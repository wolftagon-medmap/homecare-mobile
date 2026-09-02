import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/dashboard/domain/home_service_catalogue.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_layout.dart';

void main() {
  group('DashboardLayout.columnsFor', () {
    const nine = 9;

    test('uses three columns on phone widths', () {
      expect(DashboardLayout.columnsFor(320, nine), 3);
      expect(DashboardLayout.columnsFor(360, nine), 3);
      expect(DashboardLayout.columnsFor(412, nine), 3);
    });

    test('stays at three on tablet portrait rather than stranding a card', () {
      expect(DashboardLayout.columnsFor(768, nine), 3);
      expect(DashboardLayout.columnsFor(834, nine), 3);
    });

    test('widens to five on tablet landscape', () {
      expect(DashboardLayout.columnsFor(900, nine), 5);
      expect(DashboardLayout.columnsFor(1280, nine), 5);
    });

    test('never widens into a layout that strands a single card', () {
      bool strands(int count, int columns) =>
          count > columns && count % columns == 1;

      for (var count = 2; count <= 24; count++) {
        for (final width in [320.0, 600.0, 768.0, 900.0, 1280.0]) {
          final widest = width >= 900 ? 5 : (width >= 600 ? 4 : 3);
          final columns = DashboardLayout.columnsFor(width, count);

          expect(columns, inInclusiveRange(3, widest));

          final avoidable = [
            for (var candidate = 3; candidate <= widest; candidate++) candidate
          ].any((candidate) => !strands(count, candidate));

          if (avoidable) {
            expect(
              strands(count, columns),
              isFalse,
              reason: '$count services at ${width}dp chose $columns columns '
                  'when a count in 3..$widest avoids stranding one',
            );
          }
        }
      }
    });

    test('the live catalogue fills whole rows on phone', () {
      final onHome = homeGridServices.length;
      expect(DashboardLayout.columnsFor(360, onHome), 3);
      expect(onHome % 3, 0);
    });
  });
}
