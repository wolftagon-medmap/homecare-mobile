import 'package:m2health/features/etc/pricing/domain/entities/estimate.dart';
import 'package:m2health/features/etc/pricing/domain/entities/service_price.dart';

/// The one estimate calculation. Mirrored byte-for-byte in
/// `app/modules/pricing/domain/estimate_calculator.ts` on the backend — change
/// one and you change both, or the two drift.
///
/// ```
/// base  = (professional rate ?? floor) x (hourly ? hours : 1)   per service
/// total = base lines + flat add-on lines
/// ```
class EstimateCalculator {
  /// Homecare elderly is booked by the hour and the flow does not ask for a
  /// duration up front, so two hours is the assumed visit.
  static const double defaultHours = 2;

  const EstimateCalculator._();

  static Estimate calculate({
    required List<ServicePrice> services,
    List<ServicePrice> addOns = const [],
    Map<int, double> professionalRates = const {},
    double? hours,
  }) {
    final lines = <EstimateLine>[
      for (final service in services)
        EstimateLine(
          code: service.code,
          label: service.name,
          unitPrice: unitPriceFor(service, professionalRates[service.id]),
          quantity: service.isHourly ? (hours ?? defaultHours) : 1,
          kind: EstimateLineKind.base,
        ),

      // Add-ons are admin-defined and flat: the professional's rate never
      // touches them, only the base is flexible in this release.
      for (final addOn in addOns)
        EstimateLine(
          code: addOn.code,
          label: addOn.name,
          unitPrice: addOn.floorPrice,
          kind: EstimateLineKind.addOn,
        ),
    ];

    return Estimate(lines: lines);
  }

  /// A rate below the floor is lifted to it, so a stale or bad row can never
  /// produce a below-floor estimate. There is no upper cap, deliberately.
  static double unitPriceFor(ServicePrice service, double? professionalRate) {
    if (professionalRate == null) return service.floorPrice;
    return professionalRate < service.floorPrice
        ? service.floorPrice
        : professionalRate;
  }
}
