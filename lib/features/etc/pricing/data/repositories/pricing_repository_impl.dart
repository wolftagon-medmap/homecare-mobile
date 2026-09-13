import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/etc/pricing/data/datasources/estimate_revision_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/floor_price_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/provider_rate_datasource.dart';
import 'package:m2health/features/etc/pricing/domain/entities/estimate_revision.dart';
import 'package:m2health/features/etc/pricing/domain/entities/floor_price_update.dart';
import 'package:m2health/features/etc/pricing/domain/entities/price_table.dart';
import 'package:m2health/features/etc/pricing/domain/entities/provider_service_rate.dart';
import 'package:m2health/features/etc/pricing/domain/entities/service_price.dart';
import 'package:m2health/features/etc/pricing/domain/repositories/pricing_repository.dart';

class PricingRepositoryImpl implements PricingRepository {
  final PriceTableDataSource priceTableSource;
  final ProviderRateDataSource providerRates;
  final FloorPriceDataSource floorPriceSource;
  final EstimateRevisionDataSource revisions;

  PricingRepositoryImpl({
    required this.priceTableSource,
    required this.providerRates,
    required this.floorPriceSource,
    required this.revisions,
  });

  PriceTable? _cached;

  @override
  Future<Either<Failure, PriceTable>> priceTable({bool refresh = false}) async {
    if (!refresh && _cached != null) return Right(_cached!);
    return _guard(() async => _cached = await priceTableSource.fetch());
  }

  @override
  Future<Either<Failure, List<ProviderServiceRate>>> myRates() =>
      _guard(providerRates.myRates);

  @override
  Future<Either<Failure, List<ProviderServiceRate>>> saveMyRates(
    Map<int, double?> basePrices,
  ) =>
      _guard(() => providerRates.save(basePrices));

  @override
  Future<Either<Failure, List<ServicePrice>>> floorPrices() =>
      _guard(floorPriceSource.all);

  /// Prices moved, so the cached table is stale.
  @override
  Future<Either<Failure, FloorPriceUpdate>> setFloorPrice(
    int serviceId,
    double price,
  ) =>
      _guard(() async {
        final update = await floorPriceSource.setFloor(serviceId, price);
        _cached = null;
        return update;
      });

  @override
  Future<Either<Failure, List<EstimateRevision>>> estimateRevisions(
    int careTaskId,
  ) =>
      _guard(() => revisions.forCareTask(careTaskId));

  @override
  Future<Either<Failure, EstimateRevision>> respondToRevision(
    int revisionId, {
    required bool approve,
  }) =>
      _guard(() => approve
          ? revisions.approve(revisionId)
          : revisions.reject(revisionId));

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
