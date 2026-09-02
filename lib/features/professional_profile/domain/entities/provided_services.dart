import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';

class ProvidedServices extends Equatable {
  const ProvidedServices(
      {this.services = const [], this.proficiency = const {}});

  final List<ServiceEntity> services;

  /// Keyed by service id. An unrated service is absent, never zero: the server
  /// validates levels as 1-5.
  final Map<int, int> proficiency;

  @override
  List<Object?> get props => [services, proficiency];
}
