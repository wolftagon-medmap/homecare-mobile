import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/services_selection/data/datasources/services_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/services_selection/data/repositories/services_repository_impl.dart';
import 'package:m2health/features/booking_appointment/services_selection/domain/repositories/services_repository.dart';
import 'package:m2health/features/booking_appointment/services_selection/domain/usecases/get_services.dart';

void initServiceModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetServices(sl()));

  // Repository
  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton(() => ServicesRemoteDatasource(sl()));
}
