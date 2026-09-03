import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/route/app_routes.dart';

/// Nine services sit on the home grid so it fills three rows evenly; 2nd
/// Opinion Imaging is reachable from All Services.
///
/// `guidedCategory` is the guided booking flow's category. A tile without one
/// stays on its legacy page: Elderly Care and 2nd Opinion have no issue list,
/// and Dietitian is held back by the standing decision to leave the
/// precision-nutrition timeline alone in this build.
const List<HomeService> homeServiceCatalogue = [
  HomeService(
    id: HomeServiceId.pharmacist,
    route: AppRoutes.pharmaServices,
    guidedCategory: 'pharmacy',
    isNew: true,
  ),
  HomeService(
    id: HomeServiceId.physiotherapy,
    route: AppRoutes.physiotherapy,
    guidedCategory: 'physiotherapy',
  ),
  HomeService(
    id: HomeServiceId.psychologist,
    route: AppRoutes.psychologist,
    guidedCategory: 'psychology',
  ),
  HomeService(
    id: HomeServiceId.dietitian,
    route: AppRoutes.precisionNutrition,
  ),
  HomeService(
    id: HomeServiceId.optometrist,
    route: AppRoutes.optometrist,
    guidedCategory: 'optometry',
  ),
  HomeService(
    id: HomeServiceId.nursing,
    route: AppRoutes.nursingServices,
    guidedCategory: 'nursing',
  ),
  HomeService(
    id: HomeServiceId.diabeticCare,
    route: AppRoutes.diabeticCare,
    guidedCategory: 'diabetes_screening',
  ),
  HomeService(
    id: HomeServiceId.homeScreening,
    route: AppRoutes.homeHealthScreening,
    guidedCategory: 'screening',
  ),
  HomeService(
    id: HomeServiceId.homecareElderly,
    route: AppRoutes.homecareForElderly,
  ),
  HomeService(
    id: HomeServiceId.secondOpinion,
    route: AppRoutes.secondOpinionMedical,
    onHome: false,
  ),
];

extension HomeServiceDestination on HomeService {
  String get destination {
    final category = guidedCategory;
    if (category == null || !AppFlags.remote(Feature.guidedBookingFlow)) {
      return route;
    }
    return GuidedBookingRoutes.entryFor(category);
  }
}

List<HomeService> get homeGridServices =>
    homeServiceCatalogue.where((service) => service.onHome).toList();
