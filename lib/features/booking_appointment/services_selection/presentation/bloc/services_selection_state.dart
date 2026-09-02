import 'package:m2health/core/domain/entities/service_entity.dart';

enum ServicesSelectionStateStatus {
  initial,
  loading,
  loaded,
  error,
}

final class ServicesSelectionState {
  final ServicesSelectionStateStatus status;
  final List<ServiceEntity> services;
  final List<ServiceEntity> selectedServices;
  final String? errorMessage;

  double get estimatedBudget =>
      selectedServices.fold(0.0, (sum, service) => sum + service.price);

  const ServicesSelectionState._({
    required this.status,
    this.services = const [],
    this.selectedServices = const [],
    this.errorMessage,
  });

  factory ServicesSelectionState.initial(
      {List<ServiceEntity> selectedServices = const []}) {
    return ServicesSelectionState._(
      status: ServicesSelectionStateStatus.initial,
      selectedServices: selectedServices,
    );
  }

  factory ServicesSelectionState.loading() {
    return const ServicesSelectionState._(status: ServicesSelectionStateStatus.loading);
  }

  factory ServicesSelectionState.loaded(List<ServiceEntity> services) {
    return ServicesSelectionState._(
      status: ServicesSelectionStateStatus.loaded,
      services: services,
    );
  }

  factory ServicesSelectionState.error(String message) {
    return ServicesSelectionState._(
      status: ServicesSelectionStateStatus.error,
      errorMessage: message,
    );
  }

  ServicesSelectionState copyWith({
    ServicesSelectionStateStatus? status,
    List<ServiceEntity>? services,
    List<ServiceEntity>? selectedServices,
    String? errorMessage,
  }) {
    return ServicesSelectionState._(
      status: status ?? this.status,
      services: services ?? this.services,
      selectedServices:
          selectedServices ?? this.selectedServices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
