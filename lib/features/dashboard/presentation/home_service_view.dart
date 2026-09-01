import 'package:flutter/material.dart';
import 'package:m2health/features/dashboard/domain/entities/home_service.dart';
import 'package:m2health/features/dashboard/domain/home_service_catalogue.dart';
import 'package:m2health/i18n/translations.g.dart';

/// Icon and palette for one catalogue entry. Sampled from the client's mock
/// rather than chosen, so treat the values as data, not as theme colours.
class HomeServiceVisuals {
  final String iconPath;
  final Color accent;
  final Color tint;

  const HomeServiceVisuals({
    required this.iconPath,
    required this.accent,
    required this.tint,
  });
}

/// A catalogue entry with its display text and palette resolved.
class HomeServiceView {
  final HomeService service;
  final String title;
  final String description;
  final HomeServiceVisuals visuals;

  const HomeServiceView({
    required this.service,
    required this.title,
    required this.description,
    required this.visuals,
  });

  String get route => service.route;
  bool get isNew => service.isNew;
}

/// The catalogue resolved for display. [all] includes the services that sit
/// behind All Services rather than on the home grid.
List<HomeServiceView> homeServiceViews(BuildContext context,
    {bool all = false}) {
  final services = all ? homeServiceCatalogue : homeGridServices;
  return [
    for (final service in services)
      HomeServiceView(
        service: service,
        title: _titleFor(context, service.id),
        description: _descriptionFor(context, service.id),
        visuals: visualsFor(service.id),
      ),
  ];
}

// Switches rather than a map so a new HomeServiceId fails analysis here
// instead of throwing at runtime.

HomeServiceVisuals visualsFor(HomeServiceId id) => switch (id) {
      HomeServiceId.pharmacist => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_pharmacist.svg',
          accent: Color(0xFF128D8B),
          tint: Color(0xFFF2F8F4),
        ),
      HomeServiceId.physiotherapy => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_physiotherapy.svg',
          accent: Color(0xFF0A45BB),
          tint: Color(0xFFF4F8FD),
        ),
      HomeServiceId.psychologist => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_psychologist.svg',
          accent: Color(0xFF40108A),
          tint: Color(0xFFF7F5FC),
        ),
      HomeServiceId.dietitian => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_dietitian.svg',
          accent: Color(0xFFEA430E),
          tint: Color(0xFFFEF7F1),
        ),
      HomeServiceId.optometrist => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_optometrist.svg',
          accent: Color(0xFF0E748A),
          tint: Color(0xFFF4FAFA),
        ),
      HomeServiceId.nursing => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_nursing.svg',
          accent: Color(0xFFC73161),
          tint: Color(0xFFFDF3F4),
        ),
      HomeServiceId.diabeticCare => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_diabetic_care.svg',
          accent: Color(0xFF0833B6),
          tint: Color(0xFFF4F8FC),
        ),
      HomeServiceId.homeScreening => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_home_screening.svg',
          accent: Color(0xFF328E81),
          tint: Color(0xFFF5FAF5),
        ),
      HomeServiceId.homecareElderly => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_homecare_elderly.svg',
          accent: Color(0xFFD97706),
          tint: Color(0xFFFDF7EC),
        ),
      HomeServiceId.secondOpinion => const HomeServiceVisuals(
          iconPath: 'assets/icons/ic_svc_second_opinion.svg',
          accent: Color(0xFF4338CA),
          tint: Color(0xFFF3F3FD),
        ),
    };

String _titleFor(BuildContext context, HomeServiceId id) {
  final t = context.t.dashboard.home;
  return switch (id) {
    HomeServiceId.pharmacist => t.name_pharmacist,
    HomeServiceId.physiotherapy => t.name_physiotherapy,
    HomeServiceId.psychologist => t.name_psychologist,
    HomeServiceId.dietitian => t.name_dietitian,
    HomeServiceId.optometrist => t.name_optometrist,
    HomeServiceId.nursing => t.name_nursing,
    HomeServiceId.diabeticCare => t.name_diabetic_care,
    HomeServiceId.homeScreening => t.name_home_screening,
    HomeServiceId.homecareElderly => t.name_homecare_elderly,
    HomeServiceId.secondOpinion => t.name_second_opinion,
  };
}

String _descriptionFor(BuildContext context, HomeServiceId id) {
  final t = context.t.dashboard.home;
  return switch (id) {
    HomeServiceId.pharmacist => t.desc_pharmacist,
    HomeServiceId.physiotherapy => t.desc_physiotherapy,
    HomeServiceId.psychologist => t.desc_psychologist,
    HomeServiceId.dietitian => t.desc_dietitian,
    HomeServiceId.optometrist => t.desc_optometrist,
    HomeServiceId.nursing => t.desc_nursing,
    HomeServiceId.diabeticCare => t.desc_diabetic_care,
    HomeServiceId.homeScreening => t.desc_home_screening,
    HomeServiceId.homecareElderly => t.desc_homecare_elderly,
    HomeServiceId.secondOpinion => t.desc_second_opinion,
  };
}
