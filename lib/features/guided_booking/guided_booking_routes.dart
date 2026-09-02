import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';

/// Routes for the guided booking flow. Owned by A1.
///
/// Registered once in `app_router.dart` — do not open that file. Add internal
/// paths as constants here; `AppRoutes` carries only the entry point.
class GuidedBookingRoutes {
  static const String entry = AppRoutes.guidedBooking;

  static List<RouteBase> routes = [];
}
