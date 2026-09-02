import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:m2health/features/professional_profile/data/datasources/certificate_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/datasources/expertise_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/datasources/professional_profile_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/datasources/service_area_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/datasources/work_preference_remote_datasource.dart';
import 'package:m2health/features/professional_profile/data/repositories/certificate_repository_impl.dart';
import 'package:m2health/features/professional_profile/data/repositories/professional_profile_repository_impl.dart';
import 'package:m2health/features/professional_profile/domain/repositories/certificate_repository.dart';
import 'package:m2health/features/professional_profile/domain/repositories/professional_profile_repository.dart';
import 'package:m2health/features/professional_profile/domain/usecases/index.dart';

void initProfessionalProfileModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetProfessionalProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfessionalProfile(sl()));
  sl.registerLazySingleton(() => SubmitProfessionalVerification(sl()));
  sl.registerLazySingleton(() => CreateCertificate(sl()));
  sl.registerLazySingleton(() => UpdateCertificate(sl()));
  sl.registerLazySingleton(() => DeleteCertificate(sl()));

  // Repositories
  sl.registerLazySingleton<ProfessionalProfileRepository>(
    () => ProfessionalProfileRepositoryImpl(
      remoteDatasource: sl(),
      expertiseDatasource: sl(),
      workPreferenceDatasource: sl(),
      serviceAreaDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<CertificateRepository>(
    () => CertificateRepositoryImpl(remoteDatasource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfessionalProfileRemoteDatasource>(
    () => ProfessionalProfileRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<CertificateRemoteDatasource>(
    () => CertificateRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ExpertiseRemoteDatasource>(
    () => ExpertiseRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<WorkPreferenceRemoteDatasource>(
    () => WorkPreferenceRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ServiceAreaRemoteDatasource>(
    () => ServiceAreaRemoteDatasourceImpl(dio: sl<Dio>()),
  );
}
