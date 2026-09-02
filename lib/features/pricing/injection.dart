import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/pricing/data/datasources/price_table_datasource.dart';
import 'package:m2health/features/pricing/data/repositories/pricing_repository_impl.dart';
import 'package:m2health/features/pricing/domain/repositories/pricing_repository.dart';
import 'package:m2health/features/pricing/presentation/bloc/price_table_cubit.dart';

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

  sl.registerLazySingleton<PricingRepository>(
    () => PricingRepositoryImpl(sl<PriceTableDataSource>()),
  );

  sl.registerFactory<PriceTableCubit>(
    () => PriceTableCubit(sl<PricingRepository>()),
  );
}
