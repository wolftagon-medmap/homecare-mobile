import 'package:equatable/equatable.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';

/// One row of a professional's rate card. A null [basePrice] means they charge
/// the standard price — the row simply has not been set.
class ProviderServiceRate extends Equatable {
  final ServicePrice service;
  final double? basePrice;

  const ProviderServiceRate({required this.service, this.basePrice});

  double get effectivePrice => basePrice ?? service.floorPrice;

  bool get usesFloor => basePrice == null;

  /// Only ever false on stale data — the server refuses a below-floor price and
  /// the calculator clamps one. Shown as an error so it cannot be saved back.
  bool get isValid => basePrice == null || basePrice! >= service.floorPrice;

  ProviderServiceRate copyWith(
          {double? basePrice, bool clearBasePrice = false}) =>
      ProviderServiceRate(
        service: service,
        basePrice: clearBasePrice ? null : (basePrice ?? this.basePrice),
      );

  @override
  List<Object?> get props => [service, basePrice];
}
