import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_remote_datasource.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/repositories/health_profile_repository.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';

void initHealthProfileModule(GetIt sl) {
  sl.registerLazySingleton<HealthProfileDataSource>(
    () => HealthProfileRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<HealthProfileRepository>(
    () => HealthProfileRepositoryImpl(sl<HealthProfileDataSource>()),
  );
  sl.registerLazySingleton(
      () => GetHealthSections(sl<HealthProfileRepository>()));
  sl.registerLazySingleton(
      () => GetHealthSection(sl<HealthProfileRepository>()));
  sl.registerLazySingleton(
      () => SaveHealthSection(sl<HealthProfileRepository>()));
}
