import 'package:get_it/get_it.dart';
import 'package:m2health/features/optometrist/data/repositories/optometrist_appointment_repository_impl.dart';
import 'package:m2health/features/optometrist/domain/repositories/optometrist_appointment_repository.dart';
import 'package:m2health/features/optometrist/domain/usecases/create_optometry_appointment.dart';

void initOptometristModule(GetIt sl) {
  sl.registerLazySingleton(() => CreateOptometryAppointment(sl()));
  sl.registerLazySingleton<OptometristAppointmentRepository>(
    () => OptometristAppointmentRepositoryImpl(appointmentService: sl()),
  );
}
