import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';

/// Routes for the health profile sections. Owned by A5.
///
/// Registered once in `app_router.dart` — do not open that file. Add internal
/// paths as constants here; `AppRoutes` carries only the entry point.
class HealthProfileRoutes {
  static const String entry = AppRoutes.healthProfile;

  static List<RouteBase> routes = [];
}
