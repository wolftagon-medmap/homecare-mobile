import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_remote_datasource.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/entities/health_profile_subject.dart';
import 'package:m2health/features/health_profile/domain/repositories/health_profile_repository.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/health_profile_routes.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';

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

  sl.registerFactoryParam<HealthProfileCubit, HealthProfileSubject, void>(
    (subject, _) => HealthProfileCubit(
      getSections: sl<GetHealthSections>(),
      subject: subject,
    ),
  );
  sl.registerFactoryParam<HealthSectionCubit, HealthSectionArgs, void>(
    (args, _) => HealthSectionCubit(
      code: args.code,
      patientProfileId: args.patientProfileId,
      getSection: sl<GetHealthSection>(),
      saveSection: sl<SaveHealthSection>(),
    ),
  );
}
