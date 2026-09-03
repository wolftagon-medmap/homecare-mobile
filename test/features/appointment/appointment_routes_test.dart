import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/appointment_routes.dart';
import 'package:m2health/route/navigator_keys.dart';

/// The appointment detail routes used to read their id from `state.extra` and
/// cast it, so any navigation that did not carry the exact type threw — a push
/// notification deep link among them. The id now travels in the path.
void main() {
  test('the builders produce the paths the routes declare', () {
    expect(
        AppointmentRoutes.detailPath(42), '${AppRoutes.appointmentDetail}/42');
    expect(AppointmentRoutes.careTaskDetailPath(7),
        '${AppRoutes.careTaskDetail}/7');
    expect(AppointmentRoutes.providerDetailPath(9),
        '${AppRoutes.providerAppointmentDetail}/9');
  });

  group('a route that cannot resolve its id falls back instead of throwing', () {
    Future<void> pump(WidgetTester tester, String location) async {
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: location,
        routes: [
          GoRoute(
            path: AppRoutes.appointment,
            routes: AppointmentRoutes.routes,
            builder: (context, state) => const Scaffold(body: Text('shell')),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
    }

    testWidgets('a non-numeric appointment id renders the fallback',
        (tester) async {
      await pump(tester, '${AppRoutes.appointmentDetail}/not-a-number');

      expect(tester.takeException(), isNull);
      expect(find.text('That booking is no longer available.'), findsOneWidget);
    });

    testWidgets('a non-numeric care task id renders the fallback',
        (tester) async {
      await pump(tester, '${AppRoutes.careTaskDetail}/');

      expect(tester.takeException(), isNull);
      expect(find.text('shell'), findsNothing);
    });

    testWidgets('schedule-appointment without its extra renders the fallback',
        (tester) async {
      await pump(tester, '${AppRoutes.appointment}/schedule-appointment');

      expect(tester.takeException(), isNull);
      expect(find.text('That booking is no longer available.'), findsOneWidget);
    });
  });
}
