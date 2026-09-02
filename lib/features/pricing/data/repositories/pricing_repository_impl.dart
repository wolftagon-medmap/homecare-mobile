import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/pricing/domain/entities/price_table.dart';
import 'package:m2health/features/pricing/domain/repositories/pricing_repository.dart';

class PricingRepositoryImpl implements PricingRepository {
  final PriceTableDataSource dataSource;

  PricingRepositoryImpl(this.dataSource);

  PriceTable? _cached;

  @override
  Future<Either<Failure, PriceTable>> priceTable({bool refresh = false}) async {
    if (!refresh && _cached != null) return Right(_cached!);
    try {
      return Right(_cached = await dataSource.fetch());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
