import 'package:equatable/equatable.dart';
import 'package:m2health/features/pricing/domain/entities/estimate.dart';
import 'package:m2health/features/pricing/domain/entities/professional_rate.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';
import 'package:m2health/features/pricing/domain/usecases/calculate_estimate.dart';

/// Every price in the app, in one place: the admin floors, the add-on
/// catalogue, and what each professional charges.
///
/// This is the surface other features call. Do not read the fixture map
/// directly and do not sum prices by hand — [estimateFor] is the only
/// calculation.
class PriceTable extends Equatable {
  final List<ServicePrice> services;
  final List<ServicePrice> addOns;
  final List<ProfessionalRate> rates;
  final List<PricedProfessional> professionals;

  const PriceTable({
    this.services = const [],
    this.addOns = const [],
    this.rates = const [],
    this.professionals = const [],
  });

  static const PriceTable empty = PriceTable();

  // --- lookups ---------------------------------------------------------

  ServicePrice? serviceByCode(String code) =>
      _firstOrNull(services.where((s) => s.code == code)) ??
      _firstOrNull(addOns.where((s) => s.code == code));

  ServicePrice? serviceById(int id) =>
      _firstOrNull(services.where((s) => s.id == id)) ??
      _firstOrNull(addOns.where((s) => s.id == id));

  List<ServicePrice> servicesFor(String category) =>
      services.where((s) => s.category == category).toList();

  List<ServicePrice> addOnsFor(String category) =>
      addOns.where((s) => s.category == category).toList();

  /// `Starting from $X` — the cheapest floor in the category. Null when the
  /// category has no priced service.
  double? startingFromFor(String category) {
    final prices = servicesFor(category).map((s) => s.floorPrice);
    return prices.isEmpty ? null : prices.reduce(_min);
  }

  /// `from $Y` on a professional card — the cheapest price *that* professional
  /// charges in the category. Falls back to the category floor for services
  /// they have not priced, and to [startingFromFor] when they have priced
  /// nothing at all.
  double? professionalFrom(int professionalId, String category) {
    final catalogue = servicesFor(category);
    if (catalogue.isEmpty) return null;

    final rates = ratesFor(professionalId);
    final prices = catalogue.map(
      (s) => EstimateCalculator.unitPriceFor(s, rates[s.id]),
    );
    return prices.reduce(_min);
  }

  /// serviceId -> what this professional charges. Missing means the floor.
  Map<int, double> ratesFor(int professionalId) => {
        for (final rate in rates)
          if (rate.professionalId == professionalId)
            rate.serviceId: rate.basePrice,
      };

  double? rateFor(int professionalId, int serviceId) => _firstOrNull(
        rates.where(
          (r) => r.professionalId == professionalId && r.serviceId == serviceId,
        ),
      )?.basePrice;

  List<PricedProfessional> professionalsFor(String category) =>
      professionals.where((p) => p.category == category).toList();

  // --- the calculation -------------------------------------------------

  /// The full breakdown for one request. Unknown codes are skipped rather than
  /// thrown, so a stale code in a draft never blanks the review screen.
  Estimate estimateFor({
    required List<String> serviceCodes,
    List<String> addOnCodes = const [],
    int? professionalId,
    double? hours,
  }) {
    return EstimateCalculator.calculate(
      services: _resolve(serviceCodes),
      addOns: _resolve(addOnCodes),
      professionalRates:
          professionalId == null ? const {} : ratesFor(professionalId),
      hours: hours,
    );
  }

  List<ServicePrice> _resolve(List<String> codes) => [
        for (final code in codes)
          if (serviceByCode(code) case final ServicePrice service) service,
      ];

  @override
  List<Object?> get props => [services, addOns, rates, professionals];
}

double _min(double a, double b) => a < b ? a : b;

T? _firstOrNull<T>(Iterable<T> items) {
  final iterator = items.iterator;
  return iterator.moveNext() ? iterator.current : null;
}
