import 'package:get_it/get_it.dart';
import 'package:m2health/features/smoking_cessation/data/datasources/smoking_cessation_datasource.dart';
import 'package:m2health/features/smoking_cessation/data/repositories/smoking_cessation_repository_impl.dart';
import 'package:m2health/features/smoking_cessation/domain/repositories/smoking_cessation_repository.dart';

void initSmokingCessationModule(GetIt sl) {
  // Repository
  sl.registerLazySingleton<SmokingCessationRepository>(
    () => SmokingCessationRepositoryImpl(remoteDatasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<SmokingCessationRemoteDatasource>(
    () => SmokingCessationRemoteDatasourceImpl(dio: sl()),
  );
}
