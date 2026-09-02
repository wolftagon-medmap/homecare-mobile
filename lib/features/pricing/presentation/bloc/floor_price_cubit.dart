import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';
import 'package:m2health/features/pricing/domain/repositories/pricing_repository.dart';

enum FloorPriceStatus { initial, loading, loaded, saving, failure }

class FloorPriceState extends Equatable {
  final FloorPriceStatus status;
  final List<ServicePrice> services;
  final String? error;

  /// Set once after a successful save, so the screen can say how many
  /// professionals were lifted onto the new price.
  final int? lastLiftedRates;

  const FloorPriceState({
    this.status = FloorPriceStatus.initial,
    this.services = const [],
    this.error,
    this.lastLiftedRates,
  });

  Map<String, List<ServicePrice>> get byCategory {
    final grouped = <String, List<ServicePrice>>{};
    for (final service in services) {
      grouped.putIfAbsent(service.category, () => []).add(service);
    }
    return grouped;
  }

  @override
  List<Object?> get props => [status, services, error, lastLiftedRates];
}

class FloorPriceCubit extends Cubit<FloorPriceState> {
  final PricingRepository repository;

  FloorPriceCubit(this.repository) : super(const FloorPriceState());

  Future<void> load() async {
    emit(const FloorPriceState(status: FloorPriceStatus.loading));

    final result = await repository.floorPrices();
    emit(result.fold(
      (failure) => FloorPriceState(
        status: FloorPriceStatus.failure,
        error: failure.message,
      ),
      (services) => FloorPriceState(
        status: FloorPriceStatus.loaded,
        services: services,
      ),
    ));
  }

  Future<void> setFloor(int serviceId, double price) async {
    emit(FloorPriceState(
      status: FloorPriceStatus.saving,
      services: state.services,
    ));

    final result = await repository.setFloorPrice(serviceId, price);
    emit(result.fold(
      (failure) => FloorPriceState(
        status: FloorPriceStatus.loaded,
        services: state.services,
        error: failure.message,
      ),
      (update) => FloorPriceState(
        status: FloorPriceStatus.loaded,
        services: update.services,
        lastLiftedRates: update.liftedRates,
      ),
    ));
  }
}
