import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/presentation/home_service_view.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_grid.dart';
import 'package:m2health/features/dashboard/presentation/widgets/service_grid_card.dart';
import 'package:m2health/route/app_routes.dart';

List<HomeServiceView> _views(int count) {
  return List.generate(
    count,
    (i) => HomeServiceView(
      service: HomeService(
        id: HomeServiceId.values[i % HomeServiceId.values.length],
        route: AppRoutes.allServices,
      ),
      title: 'Service $i',
      description: 'Description $i',
      visuals:
          visualsFor(HomeServiceId.values[i % HomeServiceId.values.length]),
    ),
  );
}

Future<void> _pump(WidgetTester tester, Widget child, double width) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body:
            SizedBox(width: width, child: SingleChildScrollView(child: child)),
      ),
    ),
  );
}

Set<Size> _cardSizes(WidgetTester tester) => tester
    .widgetList<ServiceGridCard>(find.byType(ServiceGridCard))
    .map((card) => tester.getSize(find.byWidget(card)))
    .toSet();

int _rowCount(WidgetTester tester) => tester
    .widgetList<ServiceGridCard>(find.byType(ServiceGridCard))
    .map((card) => tester.getTopLeft(find.byWidget(card)).dy)
    .toSet()
    .length;

void main() {
  testWidgets('renders every service as a card', (tester) async {
    await _pump(tester, ServiceGrid(services: _views(9), columns: 3), 360);

    expect(find.byType(ServiceGridCard), findsNWidgets(9));
  });

  testWidgets('lays nine services into three rows of three', (tester) async {
    await _pump(tester, ServiceGrid(services: _views(9), columns: 3), 360);

    expect(_rowCount(tester), 3);
  });

  testWidgets('lays nine services into two rows at five columns',
      (tester) async {
    await _pump(tester, ServiceGrid(services: _views(9), columns: 5), 1024);

    expect(_rowCount(tester), 2);
    expect(find.byType(ServiceGridCard), findsNWidgets(9));
  });

  testWidgets('every card shares one size, even on a short last row',
      (tester) async {
    await _pump(tester, ServiceGrid(services: _views(8), columns: 3), 360);

    expect(_cardSizes(tester).length, 1);
  });

  testWidgets('does not overflow at a narrow phone width', (tester) async {
    await _pump(tester, ServiceGrid(services: _views(9), columns: 3), 288);

    expect(tester.takeException(), isNull);
  });
}
