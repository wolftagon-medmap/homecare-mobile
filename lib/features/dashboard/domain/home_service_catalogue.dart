import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/route/app_routes.dart';

/// The services the home page offers, in display order.
///
/// Nine sit on the home grid so it fills three rows evenly; 2nd Opinion
/// Imaging is reachable through All Services. Names, descriptions and icons
/// are resolved in the presentation layer.
const List<HomeService> homeServiceCatalogue = [
  HomeService(
    id: HomeServiceId.pharmacist,
    route: AppRoutes.pharmaServices,
    isNew: true,
  ),
  HomeService(
    id: HomeServiceId.physiotherapy,
    route: AppRoutes.physiotherapy,
  ),
  HomeService(
    id: HomeServiceId.psychologist,
    route: AppRoutes.psychologist,
  ),
  HomeService(
    id: HomeServiceId.dietitian,
    route: AppRoutes.precisionNutrition,
  ),
  HomeService(
    id: HomeServiceId.optometrist,
    route: AppRoutes.optometrist,
  ),
  HomeService(
    id: HomeServiceId.nursing,
    route: AppRoutes.nursingServices,
  ),
  HomeService(
    id: HomeServiceId.diabeticCare,
    route: AppRoutes.diabeticCare,
  ),
  HomeService(
    id: HomeServiceId.homeScreening,
    route: AppRoutes.homeHealthScreening,
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

/// The subset shown on the home page.
List<HomeService> get homeGridServices =>
    homeServiceCatalogue.where((service) => service.onHome).toList();
