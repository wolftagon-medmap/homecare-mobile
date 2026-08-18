import 'package:go_router/go_router.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/features/medical_store/medical_store_routes.dart';
import 'package:m2health/main.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/appointment_routes.dart';
import 'package:m2health/route/dashboard_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/core/presentation/views/favourites.dart';
import 'package:m2health/core/presentation/views/unified_home_page.dart';
import 'package:m2health/features/schedule/presentation/pages/working_schedule_page.dart';
import 'package:m2health/features/medical_store/presentation/pages/medical_store_page.dart';
import 'package:m2health/core/presentation/views/unified_profile_page.dart';

class CoreRoutes {
  static List<RouteBase> routes = [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              routes: DashboardRoutes.routes,
              builder: (context, state) => const UnifiedHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.appointment,
              routes: AppointmentRoutes.routes,
              builder: (context, state) => const UnifiedAppointmentPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.medicalStore,
              routes: MedicalStoreDetailRoutes.routes,
              builder: (context, state) => const MedicalStorePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favourite,
              builder: (context, state) => const FavouritesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const UnifiedProfilePage(),
            ),
          ],
        ),
        // Professional-only. Patients never navigate here, so this branch stays
        // idle for them rather than being hidden.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.availability,
              builder: (context, state) => const WorkingSchedulePage(),
            ),
          ],
        ),
      ],
    ),
  ];
}
