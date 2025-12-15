import 'package:get_it/get_it.dart';
import 'package:m2health/features/homecare_elderly/data/repositories/homecare_appointment_repository_impl.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_appointment_repository.dart';
import 'package:m2health/features/homecare_elderly/domain/usecases/create_homecare_appointment.dart';

void initHomecareElderlyModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreateHomecareAppointment(sl()));

  // Repository
  sl.registerLazySingleton<HomecareAppointmentRepository>(
    () => HomecareAppointmentRepositoryImpl(
      appointmentService: sl(),
    ),
  );
}
