import 'package:get_it/get_it.dart';
import 'package:m2health/features/physiotherapy/data/repositories/physiotherapy_appointment_repository_impl.dart';
import 'package:m2health/features/physiotherapy/domain/repositories/physiotherapy_appointment_repository.dart';
import 'package:m2health/features/physiotherapy/domain/usecases/create_physiotherapy_appointment.dart';

void initPhysiotherapyModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreatePhysiotherapyAppointment(sl()));

  // Repository
  sl.registerLazySingleton<PhysiotherapyAppointmentRepository>(
    () => PhysiotherapyAppointmentRepositoryImpl(
      appointmentService: sl(),
    ),
  );
}
