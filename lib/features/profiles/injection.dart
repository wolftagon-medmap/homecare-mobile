import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:m2health/features/profiles/data/datasources/address_remote_datasource.dart';
import 'package:m2health/features/profiles/data/datasources/countries_remote_datasource.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/features/profiles/data/repositories/address_repository_impl.dart';
import 'package:m2health/features/profiles/data/repositories/profile_repository_impl.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';

void initProfileModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetProfiles(sl()));
  sl.registerLazySingleton(() => CreateProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => DeleteProfile(sl()));
  sl.registerLazySingleton(() => SaveAddress(sl()));
  sl.registerLazySingleton(() => SaveWorkplaceAddress(sl()));
  sl.registerLazySingleton(() => SearchPlaces(sl()));
  sl.registerLazySingleton(() => GetPlaceDetails(sl()));
  sl.registerLazySingleton(() => GetAddresses(sl()));
  sl.registerLazySingleton(() => CreateAddress(sl()));
  sl.registerLazySingleton(() => UpdateAddress(sl()));
  sl.registerLazySingleton(() => DeleteAddress(sl()));
  sl.registerLazySingleton(() => SetDefaultAddress(sl()));

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(remoteDatasource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<CountriesRemoteDatasource>(
    () => CountriesRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AddressRemoteDatasource>(
    () => AddressRemoteDatasourceImpl(dio: sl<Dio>()),
  );
}
