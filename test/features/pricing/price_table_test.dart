import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/pricing/data/fixtures/price_table_fixture.dart';
import 'package:m2health/features/pricing/data/models/price_table_model.dart';
import 'package:m2health/features/pricing/domain/entities/estimate.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';
import 'package:m2health/features/pricing/domain/usecases/calculate_estimate.dart';

const _nursingFloor = 20.0; // nursing.specialized.pain_care_management
const _homecareFloor = 25.0; // homecare_elderly.hourly_rate, per hour

ServicePrice _service({
  int id = 1,
  String code = 'test.service',
  double floor = 40,
  String pricingModel = 'per_item',
}) =>
    ServicePrice(
      id: id,
      code: code,
      name: 'Test service',
      category: 'nursing',
      pricingModel: pricingModel,
      floorPrice: floor,
    );

void main() {
  final table = PriceTableModel.fromJson(kPriceTableFixture);

  group('the fixture round-trips through fromJson', () {
    test('every list parses and nothing is empty', () {
      expect(table.services, isNotEmpty);
      expect(table.addOns, isNotEmpty);
      expect(table.rates, isNotEmpty);
      expect(table.professionals, hasLength(6));
    });

    test('service ids are unique across services and add-ons', () {
      final ids = [
        ...table.services.map((s) => s.id),
        ...table.addOns.map((s) => s.id),
      ];
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('every rate points at a real service and professional', () {
      for (final rate in table.rates) {
        expect(table.serviceById(rate.serviceId), isNotNull,
            reason: 'rate for unknown service ${rate.serviceId}');
        expect(
          table.professionals.any((p) => p.id == rate.professionalId),
          isTrue,
          reason: 'rate for unknown professional ${rate.professionalId}',
        );
      }
    });

    test('no professional is priced below the floor', () {
      for (final rate in table.rates) {
        final service = table.serviceById(rate.serviceId)!;
        expect(rate.basePrice, greaterThanOrEqualTo(service.floorPrice));
      }
    });

    test('add-ons are never also offered as a primary service', () {
      final primaryCodes = table.services.map((s) => s.code).toSet();
      for (final addOn in table.addOns) {
        expect(primaryCodes.contains(addOn.code), isFalse);
      }
    });
  });

  group('starting from', () {
    test('is the cheapest floor in the category', () {
      expect(table.startingFromFor('nursing'), _nursingFloor);
      expect(table.startingFromFor('homecare_elderly'), _homecareFloor);
    });

    test('is null for a category nobody prices', () {
      expect(table.startingFromFor('astrology'), isNull);
    });
  });

  group('a professional from-price', () {
    test('is at or above the category floor', () {
      final from = table.professionalFrom(101, 'nursing')!;
      expect(from, greaterThanOrEqualTo(_nursingFloor));
    });

    test('falls back to the floor for a professional with no rates', () {
      expect(table.professionalFrom(999, 'nursing'), _nursingFloor);
    });
  });

  group('the estimate calculation', () {
    test('a flat service with no professional charges the floor', () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(floor: 40)],
      );

      expect(estimate.total, 40);
      expect(estimate.lines.single.quantity, 1);
      expect(estimate.lines.single.kind, EstimateLineKind.base);
    });

    test("uses the professional's base price when they have one", () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(id: 7, floor: 40)],
        professionalRates: const {7: 55},
      );

      expect(estimate.total, 55);
    });

    test('clamps a below-floor rate up to the floor', () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(id: 7, floor: 40)],
        professionalRates: const {7: 5},
      );

      expect(estimate.total, 40);
    });

    test('has no upper cap', () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(id: 7, floor: 40)],
        professionalRates: const {7: 4000},
      );

      expect(estimate.total, 4000);
    });

    test('an hourly service defaults to two hours', () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(floor: 25, pricingModel: 'hourly_rate')],
      );

      expect(estimate.lines.single.quantity, EstimateCalculator.defaultHours);
      expect(estimate.total, 50);
    });

    test('an hourly service honours the hours it is given', () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(floor: 25, pricingModel: 'hourly_rate')],
        hours: 5,
      );

      expect(estimate.total, 125);
    });

    test('hours do not multiply a flat service', () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(floor: 40)],
        hours: 5,
      );

      expect(estimate.total, 40);
    });

    test("add-ons stay flat and ignore the professional's rate", () {
      final estimate = EstimateCalculator.calculate(
        services: [_service(id: 1, floor: 40)],
        addOns: [_service(id: 2, code: 'addon', floor: 15)],
        professionalRates: const {1: 60, 2: 99},
      );

      expect(estimate.total, 75);
      expect(estimate.addOnLines.single.unitPrice, 15);
    });

    test('sums every line of a multi-select request', () {
      final estimate = EstimateCalculator.calculate(
        services: [
          _service(id: 1, code: 'a', floor: 10),
          _service(id: 2, code: 'b', floor: 20),
          _service(id: 3, code: 'c', floor: 30),
        ],
        professionalRates: const {2: 25},
      );

      expect(estimate.total, 65);
      expect(estimate.baseLines, hasLength(3));
    });

    test('an empty request estimates nothing', () {
      expect(EstimateCalculator.calculate(services: const []).total, 0);
    });
  });

  group('estimateFor, the call other features make', () {
    test('prices real codes from the fixture', () {
      final estimate = table.estimateFor(
        serviceCodes: const ['nursing.specialized.pressure_ulcer_care'],
        addOnCodes: const ['nursing.basic.blood_glucose_check'],
        professionalId: 101,
      );

      expect(estimate.lines, hasLength(2));
      expect(estimate.total, greaterThan(0));
    });

    test('skips an unknown code rather than throwing', () {
      final estimate = table.estimateFor(
        serviceCodes: const [
          'nursing.specialized.pain_care_management',
          'nope'
        ],
      );

      expect(estimate.lines, hasLength(1));
      expect(estimate.total, _nursingFloor);
    });

    test('the homecare hourly service defaults to two hours', () {
      final estimate = table.estimateFor(
        serviceCodes: const ['homecare_elderly.hourly_rate'],
      );

      expect(estimate.total, _homecareFloor * EstimateCalculator.defaultHours);
    });
  });
}
