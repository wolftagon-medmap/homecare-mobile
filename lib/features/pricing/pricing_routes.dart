import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';

/// Routes for pricing and estimates. Owned by A3.
///
/// Registered once in `app_router.dart` — do not open that file. Add internal
/// paths as constants here; `AppRoutes` carries only the entry point.
class PricingRoutes {
  static const String entry = AppRoutes.providerServiceRates;

  static List<RouteBase> routes = [];
}
