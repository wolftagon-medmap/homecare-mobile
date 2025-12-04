import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:m2health/features/profiles/data/datasources/address_remote_datasource.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/features/profiles/data/datasources/certificate_remote_datasource.dart';
import 'package:m2health/features/profiles/data/repositories/address_repository_impl.dart';
import 'package:m2health/features/profiles/data/repositories/profile_repository_impl.dart';
import 'package:m2health/features/profiles/data/repositories/certificate_repository_impl.dart';
import 'package:m2health/features/profiles/domain/repositories/address_repository.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/features/profiles/domain/repositories/certificate_repository.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';

void initProfileModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => GetProfessionalProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfessionalProfile(sl()));
  sl.registerLazySingleton(() => CreateCertificate(sl()));
  sl.registerLazySingleton(() => UpdateCertificate(sl()));
  sl.registerLazySingleton(() => DeleteCertificate(sl()));
  sl.registerLazySingleton(() => SaveAddress(sl()));
  sl.registerLazySingleton(() => SearchPlaces(sl()));
  sl.registerLazySingleton(() => GetPlaceDetails(sl()));

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<CertificateRepository>(
    () => CertificateRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(remoteDatasource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<CertificateRemoteDatasource>(
    () => CertificateRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AddressRemoteDatasource>(
    () => AddressRemoteDatasourceImpl(dio: sl<Dio>()),
  );
}
