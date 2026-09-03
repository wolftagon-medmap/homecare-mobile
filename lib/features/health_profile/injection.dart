import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/file_upload/data/datasources/file_upload_remote_data_source.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_datasource.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_local_datasource.dart';
import 'package:m2health/features/health_profile/data/datasources/health_profile_remote_datasource.dart';
import 'package:m2health/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:m2health/features/health_profile/domain/repositories/health_profile_repository.dart';
import 'package:m2health/features/health_profile/domain/usecases/health_profile_usecases.dart';
import 'package:m2health/features/health_profile/health_profile_routes.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_profile_cubit.dart';
import 'package:m2health/features/health_profile/presentation/bloc/health_section_cubit.dart';

void initHealthProfileModule(GetIt sl) {
  sl.registerLazySingleton<HealthProfileDataSource>(
    () => AppFlags.remote(Feature.healthProfileSections)
        ? HealthProfileRemoteDataSource(sl<Dio>())
        : HealthProfileLocalDataSource(),
  );

  sl.registerLazySingleton<HealthAttachmentDataSource>(
    () => AppFlags.remote(Feature.healthProfileSections)
        ? HealthAttachmentRemoteDataSource(sl<FileUploadRemoteDataSource>())
        : HealthAttachmentLocalDataSource(),
  );

  sl.registerLazySingleton<HealthProfileRepository>(
    () => HealthProfileRepositoryImpl(
      sl<HealthProfileDataSource>(),
      sl<HealthAttachmentDataSource>(),
    ),
  );

  sl.registerLazySingleton(() => GetHealthSections(sl<HealthProfileRepository>()));
  sl.registerLazySingleton(() => GetHealthSection(sl<HealthProfileRepository>()));
  sl.registerLazySingleton(() => SaveHealthSection(sl<HealthProfileRepository>()));
  sl.registerLazySingleton(
    () => UploadHealthAttachment(sl<HealthProfileRepository>()),
  );

  sl.registerFactory(() => HealthProfileCubit(sl<GetHealthSections>()));

  sl.registerFactoryParam<HealthSectionCubit, HealthSectionArgs, void>(
    (args, _) => HealthSectionCubit(
      code: args.code,
      patientProfileId: args.patientProfileId,
      getSection: sl<GetHealthSection>(),
      saveSection: sl<SaveHealthSection>(),
      uploadAttachment: sl<UploadHealthAttachment>(),
    ),
  );
}
