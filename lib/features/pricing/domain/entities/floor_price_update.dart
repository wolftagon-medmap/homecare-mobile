import 'package:equatable/equatable.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';

/// What changed when an admin moved a floor. [liftedRates] is how many
/// professionals were charging below the new price and were lifted onto it.
class FloorPriceUpdate extends Equatable {
  final List<ServicePrice> services;
  final int liftedRates;

  const FloorPriceUpdate({required this.services, this.liftedRates = 0});

  @override
  List<Object?> get props => [services, liftedRates];
}
