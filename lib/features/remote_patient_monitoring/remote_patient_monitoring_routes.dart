import 'package:go_router/go_router.dart';
import 'package:m2health/features/remote_patient_monitoring/pages/scan_device_page.dart';
import 'package:m2health/route/app_routes.dart';

class RemotePatientMonitoringRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.monitoringScanDevice,
      name: AppRoutes.monitoringScanDevice,
      builder: (context, state) {
        return const ScanDevicePage();
      },
    ),
    // GoRoute(
    //   path: AppRoutes.monitoringAddDevice,
    //   name: AppRoutes.monitoringAddDevice,
    //   builder: (context, state) {
    //     return const ScanDevicePage();
    //   },
    // ),
  ];
}
