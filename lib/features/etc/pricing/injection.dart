import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/features/etc/pricing/data/datasources/estimate_revision_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/floor_price_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/etc/pricing/data/datasources/provider_rate_datasource.dart';
import 'package:m2health/features/etc/pricing/data/repositories/pricing_repository_impl.dart';
import 'package:m2health/features/etc/pricing/domain/repositories/pricing_repository.dart';
import 'package:m2health/features/etc/pricing/presentation/bloc/estimate_revision_cubit.dart';
import 'package:m2health/features/etc/pricing/presentation/bloc/floor_price_cubit.dart';
import 'package:m2health/features/etc/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/features/etc/pricing/presentation/bloc/provider_rates_cubit.dart';

/// Dependency registrations for pricing and estimates. Called from
/// `service_locator.dart`.
void initPricingModule(GetIt sl) {
  sl.registerLazySingleton<PriceTableDataSource>(
    () => PriceTableRemoteDataSource(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<ProviderRateDataSource>(
    () => ProviderRateRemoteDataSource(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<FloorPriceDataSource>(
    () => FloorPriceRemoteDataSource(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<EstimateRevisionDataSource>(
    () => EstimateRevisionRemoteDataSource(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<PricingRepository>(
    () => PricingRepositoryImpl(
      priceTableSource: sl<PriceTableDataSource>(),
      providerRates: sl<ProviderRateDataSource>(),
      floorPriceSource: sl<FloorPriceDataSource>(),
      revisions: sl<EstimateRevisionDataSource>(),
    ),
  );

  sl.registerFactory<PriceTableCubit>(
    () => PriceTableCubit(sl<PricingRepository>()),
  );
  sl.registerFactory<ProviderRatesCubit>(
    () => ProviderRatesCubit(sl<PricingRepository>()),
  );
  sl.registerFactory<FloorPriceCubit>(
    () => FloorPriceCubit(sl<PricingRepository>()),
  );

  // Screen-scoped, one per thread: the messaging feature passes the care task.
  sl.registerFactoryParam<EstimateRevisionCubit, int, void>(
    (careTaskId, _) =>
        EstimateRevisionCubit(sl<PricingRepository>(), careTaskId),
  );
}
