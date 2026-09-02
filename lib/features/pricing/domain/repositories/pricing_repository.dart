import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/pricing/domain/entities/floor_price_update.dart';
import 'package:m2health/features/pricing/domain/entities/price_table.dart';
import 'package:m2health/features/pricing/domain/entities/provider_service_rate.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';

abstract class PricingRepository {
  /// Cached after the first load: prices change rarely and every service card
  /// on the home page asks for them.
  Future<Either<Failure, PriceTable>> priceTable({bool refresh = false});

  Future<Either<Failure, List<ProviderServiceRate>>> myRates();

  /// serviceId -> price, or null to fall back to the standard price.
  Future<Either<Failure, List<ProviderServiceRate>>> saveMyRates(
    Map<int, double?> basePrices,
  );

  Future<Either<Failure, List<ServicePrice>>> floorPrices();

  Future<Either<Failure, FloorPriceUpdate>> setFloorPrice(
    int serviceId,
    double price,
  );
}
