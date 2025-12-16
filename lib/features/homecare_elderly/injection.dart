import 'package:get_it/get_it.dart';
import 'package:m2health/features/homecare_elderly/admin/bloc/admin_homecare_cubit.dart';
import 'package:m2health/features/homecare_elderly/data/datasources/homecare_remote_data_source.dart';
import 'package:m2health/features/homecare_elderly/data/repositories/homecare_appointment_repository_impl.dart';
import 'package:m2health/features/homecare_elderly/data/repositories/homecare_repository_impl.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_appointment_repository.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_repository.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/create_homecare_appointment.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/get_homecare_rates.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/update_homecare_rate.dart';

void initHomecareElderlyModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreateHomecareAppointment(sl()));
  sl.registerLazySingleton(() => GetHomecareRates(sl()));
  sl.registerLazySingleton(() => UpdateHomecareRate(sl()));

  // Repository
  sl.registerLazySingleton<HomecareAppointmentRepository>(
    () => HomecareAppointmentRepositoryImpl(
      appointmentService: sl(),
    ),
  );
  sl.registerLazySingleton<HomecareRepository>(
    () => HomecareRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<HomecareRemoteDataSource>(
    () => HomecareRemoteDataSourceImpl(dio: sl()),
  );

  // Admin Cubit
  sl.registerFactory(() => AdminHomecareCubit(
    getHomecareRates: sl(),
    updateHomecareRate: sl(),
    getSubscriptionPlans: sl(),
    updateSubscriptionPlan: sl(),
    toggleSubscriptionPlanActive: sl(),
  ));
}