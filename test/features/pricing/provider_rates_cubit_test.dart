import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/pricing/data/datasources/floor_price_datasource.dart';
import 'package:m2health/features/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/pricing/data/datasources/provider_rate_datasource.dart';
import 'package:m2health/features/pricing/data/models/price_table_model.dart';
import 'package:m2health/features/pricing/data/repositories/pricing_repository_impl.dart';
import 'package:m2health/features/pricing/data/datasources/estimate_revision_datasource.dart';
import 'package:m2health/features/pricing/domain/entities/estimate_revision.dart';
import 'package:m2health/features/pricing/domain/entities/floor_price_update.dart';
import 'package:m2health/features/pricing/domain/entities/price_table.dart';
import 'package:m2health/features/pricing/domain/entities/provider_service_rate.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';
import 'package:m2health/features/pricing/domain/repositories/pricing_repository.dart';
import 'package:m2health/features/pricing/presentation/bloc/floor_price_cubit.dart';
import 'package:m2health/features/pricing/presentation/bloc/provider_rates_cubit.dart';

const _woundCare = ServicePrice(
  id: 1,
  code: 'nursing.specialized.stomy_wound_care',
  name: 'Stomy/wound care',
  category: 'nursing',
  pricingModel: 'per_item',
  floorPrice: 20,
);

class _FakeRepository implements PricingRepository {
  Map<int, double?>? savedRates;
  Failure? failWith;

  @override
  Future<Either<Failure, PriceTable>> priceTable(
          {bool refresh = false}) async =>
      const Right(PriceTable.empty);

  @override
  Future<Either<Failure, List<ProviderServiceRate>>> myRates() async =>
      failWith != null
          ? Left(failWith!)
          : const Right([ProviderServiceRate(service: _woundCare)]);

  @override
  Future<Either<Failure, List<ProviderServiceRate>>> saveMyRates(
    Map<int, double?> basePrices,
  ) async {
    savedRates = basePrices;
    return Right([
      ProviderServiceRate(
        service: _woundCare,
        basePrice: basePrices[_woundCare.id],
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<ServicePrice>>> floorPrices() async =>
      const Right([_woundCare]);

  @override
  Future<Either<Failure, FloorPriceUpdate>> setFloorPrice(
    int serviceId,
    double price,
  ) async =>
      const Right(FloorPriceUpdate(services: [_woundCare], liftedRates: 3));

  @override
  Future<Either<Failure, List<EstimateRevision>>> estimateRevisions(
    int careTaskId,
  ) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, EstimateRevision>> respondToRevision(
    int revisionId, {
    required bool approve,
  }) =>
      throw UnimplementedError();
}

void main() {
  group('ProviderRatesCubit', () {
    test('loads the rate card', () async {
      final cubit = ProviderRatesCubit(_FakeRepository());
      await cubit.load();

      expect(cubit.state.status, ProviderRatesStatus.loaded);
      expect(cubit.state.rates.single.usesFloor, isTrue);
    });

    test('surfaces a load failure', () async {
      final repository = _FakeRepository()
        ..failWith = const NetworkFailure('offline');
      final cubit = ProviderRatesCubit(repository);
      await cubit.load();

      expect(cubit.state.status, ProviderRatesStatus.failure);
      expect(cubit.state.error, 'offline');
    });

    test('a price below the floor is invalid and blocks saving', () async {
      final cubit = ProviderRatesCubit(_FakeRepository());
      await cubit.load();
      cubit.edit(_woundCare.id, '5');

      expect(cubit.state.isValid(_woundCare.id), isFalse);
      expect(cubit.state.canSave, isFalse);
    });

    test('a price at the floor is valid', () async {
      final cubit = ProviderRatesCubit(_FakeRepository());
      await cubit.load();
      cubit.edit(_woundCare.id, '20');

      expect(cubit.state.canSave, isTrue);
    });

    test('there is no upper cap', () async {
      final cubit = ProviderRatesCubit(_FakeRepository());
      await cubit.load();
      cubit.edit(_woundCare.id, '9999');

      expect(cubit.state.canSave, isTrue);
    });

    test('a blank price means charging the standard price', () async {
      final repository = _FakeRepository();
      final cubit = ProviderRatesCubit(repository);
      await cubit.load();
      cubit.edit(_woundCare.id, '');
      await cubit.save();

      expect(repository.savedRates, {_woundCare.id: null});
      expect(cubit.state.rates.single.usesFloor, isTrue);
    });

    test('text that is not a number is invalid', () async {
      final cubit = ProviderRatesCubit(_FakeRepository());
      await cubit.load();
      cubit.edit(_woundCare.id, '..');

      expect(cubit.state.isValid(_woundCare.id), isFalse);
    });

    test('saving reports success once', () async {
      final cubit = ProviderRatesCubit(_FakeRepository());
      await cubit.load();
      cubit.edit(_woundCare.id, '30');
      await cubit.save();

      expect(cubit.state.justSaved, isTrue);
      expect(cubit.state.rates.single.basePrice, 30);
    });
  });

  group('FloorPriceCubit', () {
    test('groups services by category', () async {
      final cubit = FloorPriceCubit(_FakeRepository());
      await cubit.load();

      expect(cubit.state.byCategory.keys, ['nursing']);
    });

    test('reports how many rates a raise lifted', () async {
      final cubit = FloorPriceCubit(_FakeRepository());
      await cubit.load();
      await cubit.setFloor(_woundCare.id, 40);

      expect(cubit.state.lastLiftedRates, 3);
    });
  });

  group('the local data sources', () {
    test('a provider rate card covers the professional\'s whole category',
        () async {
      final source = ProviderRateLocalDataSource(
        const PriceTableLocalDataSource(),
      );
      final rates = await source.myRates();

      expect(rates, isNotEmpty);
      expect(rates.every((r) => r.service.category == 'nursing'), isTrue);
      expect(rates.every((r) => r.isValid), isTrue);
    });

    test('a saved rate survives a reload within the session', () async {
      final source = ProviderRateLocalDataSource(
        const PriceTableLocalDataSource(),
      );
      final first = (await source.myRates()).first;
      await source.save({first.service.id: first.service.floorPrice + 100});

      final reloaded = (await source.myRates())
          .firstWhere((r) => r.service.id == first.service.id);
      expect(reloaded.basePrice, first.service.floorPrice + 100);
    });

    test('raising a floor counts the rates that sat below it', () async {
      const priceTable = PriceTableLocalDataSource();
      final table = await priceTable.fetch();
      final source = FloorPriceLocalDataSource(priceTable);

      final rate = table.rates.first;
      final update = await source.setFloor(rate.serviceId, rate.basePrice + 50);

      expect(update.liftedRates, greaterThanOrEqualTo(1));
      final moved = update.services.firstWhere((s) => s.id == rate.serviceId);
      expect(moved.floorPrice, rate.basePrice + 50);
    });
  });

  group('PricingRepositoryImpl', () {
    test('caches the price table until a floor moves', () async {
      final priceTable = _CountingPriceTable();
      final repository = PricingRepositoryImpl(
        priceTableSource: priceTable,
        providerRates: ProviderRateLocalDataSource(priceTable),
        floorPriceSource: FloorPriceLocalDataSource(priceTable),
        revisions: EstimateRevisionLocalDataSource(),
      );

      await repository.priceTable();
      await repository.priceTable();
      expect(priceTable.calls, 1);

      final table = await priceTable.fetch();
      await repository.setFloorPrice(table.services.first.id, 999);
      await repository.priceTable();
      expect(priceTable.calls, greaterThan(2));
    });
  });
}

class _CountingPriceTable implements PriceTableDataSource {
  int calls = 0;

  @override
  Future<PriceTableModel> fetch() {
    calls++;
    return const PriceTableLocalDataSource().fetch();
  }
}
