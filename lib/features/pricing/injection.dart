import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/pricing/data/datasources/estimate_revision_datasource.dart';
import 'package:m2health/features/pricing/data/datasources/floor_price_datasource.dart';
import 'package:m2health/features/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/pricing/data/datasources/provider_rate_datasource.dart';
import 'package:m2health/features/pricing/data/repositories/pricing_repository_impl.dart';
import 'package:m2health/features/pricing/domain/repositories/pricing_repository.dart';
import 'package:m2health/features/pricing/presentation/bloc/estimate_revision_cubit.dart';
import 'package:m2health/features/pricing/presentation/bloc/floor_price_cubit.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/features/pricing/presentation/bloc/provider_rates_cubit.dart';

/// Dependency registrations for pricing and estimates. Owned by A3.
///
/// Called from `service_locator.dart` — do not open that file.
/// Data sources resolve through `AppFlags.remote(Feature.x)`; see
/// `lib/core/config/feature_flags.dart`.
void initPricingModule(GetIt sl) {
  sl.registerLazySingleton<PriceTableDataSource>(
    () => AppFlags.remote(Feature.servicePricing)
        ? PriceTableRemoteDataSource(dio: sl<Dio>())
        : const PriceTableLocalDataSource(),
  );

  sl.registerLazySingleton<ProviderRateDataSource>(
    () => AppFlags.remote(Feature.professionalPricing)
        ? ProviderRateRemoteDataSource(dio: sl<Dio>())
        : ProviderRateLocalDataSource(sl<PriceTableDataSource>()),
  );

  // The admin floor shares the professionalPricing flag: both write the same
  // price columns and there is no case for cutting one over without the other.
  sl.registerLazySingleton<FloorPriceDataSource>(
    () => AppFlags.remote(Feature.professionalPricing)
        ? FloorPriceRemoteDataSource(dio: sl<Dio>())
        : FloorPriceLocalDataSource(sl<PriceTableDataSource>()),
  );

  sl.registerLazySingleton<EstimateRevisionDataSource>(
    () => AppFlags.remote(Feature.estimateRevision)
        ? EstimateRevisionRemoteDataSource(dio: sl<Dio>())
        : EstimateRevisionLocalDataSource(),
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
