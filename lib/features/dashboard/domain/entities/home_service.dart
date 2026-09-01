import 'package:equatable/equatable.dart';

/// Stable identity for a catalogue entry. An enum rather than a string so the
/// i18n lookup and the icon/colour table are both exhaustively checked.
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

/// How the services block is arranged. The client is comparing both before
/// choosing one, so the choice is persisted per device.
enum HomeServicesLayout { grid, list }

class HomeService extends Equatable {
  final HomeServiceId id;

  /// Destination path, an `AppRoutes` constant.
  final String route;

  /// Whether the service appears on the home page. The rest are reachable
  /// through All Services only.
  final bool onHome;

  final bool isNew;

  const HomeService({
    required this.id,
    required this.route,
    this.onHome = true,
    this.isNew = false,
  });

  @override
  List<Object?> get props => [id, route, onHome, isNew];
}
