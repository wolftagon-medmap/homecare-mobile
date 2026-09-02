import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';

/// Routes for patient / professional messaging. Owned by A2.
///
/// Registered once in `app_router.dart` — do not open that file. Add internal
/// paths as constants here; `AppRoutes` carries only the entry point.
class MessagingRoutes {
  static const String entry = AppRoutes.messages;

  static List<RouteBase> routes = [];
}
