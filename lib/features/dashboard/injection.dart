import 'package:get_it/get_it.dart';
import 'package:m2health/features/dashboard/data/datasources/home_layout_local_datasource.dart';
import 'package:m2health/features/dashboard/data/repositories/home_layout_repository_impl.dart';
import 'package:m2health/features/dashboard/domain/repositories/home_layout_repository.dart';
import 'package:m2health/features/dashboard/domain/usecases/index.dart';
import 'package:m2health/features/dashboard/presentation/bloc/home_services_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initDashboardModule(GetIt sl) {
  // Cubits
  sl.registerFactory(
    () => HomeServicesCubit(getHomeLayout: sl(), setHomeLayout: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHomeLayout(sl()));
  sl.registerLazySingleton(() => SetHomeLayout(sl()));

  // Repositories
  sl.registerLazySingleton<HomeLayoutRepository>(
    () => HomeLayoutRepositoryImpl(localDatasource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HomeLayoutLocalDatasource>(
    () => HomeLayoutLocalDatasourceImpl(prefs: sl<SharedPreferences>()),
  );
}
