import 'package:go_router/go_router.dart';
import 'package:m2health/features/pricing/presentation/pages/admin_floor_price_page.dart';
import 'package:m2health/features/pricing/presentation/pages/provider_service_rates_page.dart';
import 'package:m2health/route/app_routes.dart';

/// Routes for pricing and estimates. Owned by A3.
///
/// Registered once in `app_router.dart` — do not open that file. Add internal
/// paths as constants here; `AppRoutes` carries only the entry point.
class PricingRoutes {
  static const String entry = AppRoutes.providerServiceRates;

  /// The admin's floor prices. Nested under the entry so no second constant is
  /// needed in `AppRoutes`.
  static const String floorPrices = '$entry/floor-prices';

  static List<RouteBase> routes = [
    GoRoute(
      path: entry,
      builder: (context, state) => const ProviderServiceRatesPage(),
    ),
    GoRoute(
      path: floorPrices,
      builder: (context, state) => const AdminFloorPricePage(),
    ),
  ];
}
