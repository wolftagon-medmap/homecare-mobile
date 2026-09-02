import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';

import 'feature_flags_page.dart';

/// The debug flag screen's route. Registered in `app_router.dart`.
///
/// The route exists in every build; only the entry tile is debug-gated, so a
/// release build simply has no way to reach it.
class FeatureFlagsRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.debugFeatureFlags,
      name: AppRoutes.debugFeatureFlags,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const FeatureFlagsPage(),
    ),
  ];
}
