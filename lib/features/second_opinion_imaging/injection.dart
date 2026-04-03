import 'package:get_it/get_it.dart';
import 'package:m2health/features/second_opinion_imaging/data/repositories/second_opinion_imaging_repository_impl.dart';
import 'package:m2health/features/second_opinion_imaging/domain/repositories/second_opinion_imaging_repository.dart';

void initSecondOpinionImagingModule(GetIt sl) {
  // Repository
  sl.registerLazySingleton<SecondOpinionImagingRepository>(
    () => SecondOpinionImagingRepositoryImpl(
      appointmentService: sl(),
    ),
  );
}
