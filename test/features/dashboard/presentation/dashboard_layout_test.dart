import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/dashboard/domain/home_service_catalogue.dart';
import 'package:m2health/features/dashboard/presentation/dashboard_layout.dart';

void main() {
  group('DashboardLayout.columnsFor', () {
    const nine = 9;

    test('keeps three columns across phone widths', () {
      for (final width in [288.0, 343.0, 361.0, 398.0]) {
        expect(DashboardLayout.columnsFor(width, nine), 3, reason: '$width');
      }
    });

    test('widens to five on tablet portrait and landscape', () {
      for (final width in [712.0, 802.0, 992.0, 1100.0]) {
        expect(DashboardLayout.columnsFor(width, nine), 5, reason: '$width');
      }
    });

    test('never widens into a layout that strands a single card', () {
      bool strands(int count, int columns) =>
          count > columns && count % columns == 1;

      for (var count = 2; count <= 24; count++) {
        for (final width in [288.0, 600.0, 712.0, 900.0, 1100.0]) {
          final columns = DashboardLayout.columnsFor(width, count);
          expect(
            columns,
            inInclusiveRange(
                DashboardLayout.minColumns, DashboardLayout.maxColumns),
          );
          if (columns > DashboardLayout.minColumns) {
            expect(strands(count, columns), isFalse,
                reason: '$count services at ${width}dp');
          }
        }
      }
    });

    test('never shrinks a card below a readable width past three columns', () {
      for (final width in [400.0, 500.0, 600.0, 700.0]) {
        final columns = DashboardLayout.columnsFor(width, nine);
        if (columns > DashboardLayout.minColumns) {
          expect(DashboardLayout.cardWidthFor(width, columns),
              greaterThanOrEqualTo(120));
        }
      }
    });

    test('the live catalogue fills whole rows on phone', () {
      final onHome = homeGridServices.length;
      expect(DashboardLayout.columnsFor(361, onHome), 3);
      expect(onHome % 3, 0);
    });
  });
}
