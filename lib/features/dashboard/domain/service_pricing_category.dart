import 'package:m2health/features/dashboard/domain/entities/home_service.dart';

/// The home tiles are a product grouping; prices live under the backend's
/// service categories. A switch rather than a map so a new [HomeServiceId]
/// fails analysis here.
///
/// Diabetic care and home screening share `screening` — the catalogue has one
/// screening category and diabetes sits inside it.
String pricingCategoryFor(HomeServiceId id) => switch (id) {
      HomeServiceId.pharmacist => 'pharmacy',
      HomeServiceId.physiotherapy => 'physiotherapy',
      HomeServiceId.psychologist => 'psychology',
      HomeServiceId.dietitian => 'nutrition',
      HomeServiceId.optometrist => 'optometry',
      HomeServiceId.nursing => 'nursing',
      HomeServiceId.diabeticCare => 'screening',
      HomeServiceId.homeScreening => 'screening',
      HomeServiceId.homecareElderly => 'homecare_elderly',
      HomeServiceId.secondOpinion => 'second_opinion_imaging',
    };
