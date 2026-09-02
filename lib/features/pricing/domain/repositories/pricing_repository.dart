import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/pricing/domain/entities/price_table.dart';

abstract class PricingRepository {
  /// Cached after the first load: prices change rarely and every service card
  /// on the home page asks for them.
  Future<Either<Failure, PriceTable>> priceTable({bool refresh = false});
}
