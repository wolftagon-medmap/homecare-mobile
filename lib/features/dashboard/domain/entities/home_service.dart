import 'package:equatable/equatable.dart';

/// An enum rather than a string so the i18n and icon tables are checked
/// exhaustively.
enum HomeServiceId {
  pharmacist,
  physiotherapy,
  psychologist,
  dietitian,
  optometrist,
  nursing,
  diabeticCare,
  homeScreening,
  homecareElderly,
  secondOpinion,
}

enum HomeServicesLayout { grid, list }

class HomeService extends Equatable {
  final HomeServiceId id;
  final String route;

  /// The guided booking category this tile maps onto, when the guided flow
  /// covers it. Null keeps the tile on its legacy per-service page.
  final String? guidedCategory;

  /// Services that are not on the home grid are reachable from All Services.
  final bool onHome;

  final bool isNew;

  const HomeService({
    required this.id,
    required this.route,
    this.guidedCategory,
    this.onHome = true,
    this.isNew = false,
  });

  @override
  List<Object?> get props => [id, route, guidedCategory, onHome, isNew];
}
