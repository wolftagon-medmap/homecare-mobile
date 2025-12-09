import 'package:go_router/go_router.dart';
import 'package:m2health/features/medical_store/presentation/pages/medical_store_detail_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';

class MedicalStoreDetailRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: 'detail',
      name: AppRoutes.medicalStoreDetail,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final params = state.extra as MedicalStoreDetailPageParams;
        return MedicalStoreDetailPage(params: params);
      },
    ),
  ];
}
