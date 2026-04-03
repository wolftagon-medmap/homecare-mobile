import 'package:get_it/get_it.dart';
import 'package:m2health/features/second_opinion_imaging/data/datasources/second_opinion_imaging_remote_datasource.dart';
import 'package:m2health/features/second_opinion_imaging/data/repositories/second_opinion_imaging_repository_impl.dart';
import 'package:m2health/features/second_opinion_imaging/domain/repositories/second_opinion_imaging_repository.dart';

void initSecondOpinionImagingModule(GetIt sl) {
  // Data sources
  sl.registerLazySingleton(
    () => SecondOpinionImagingRemoteDataSource(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<SecondOpinionImagingRepository>(
    () => SecondOpinionImagingRepositoryImpl(
      appointmentService: sl(),
      remoteDataSource: sl(),
    ),
  );
}
