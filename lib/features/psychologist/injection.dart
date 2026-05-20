import 'package:get_it/get_it.dart';
import 'package:m2health/features/psychologist/data/repositories/psychologist_appointment_repository_impl.dart';
import 'package:m2health/features/psychologist/domain/repositories/psychologist_appointment_repository.dart';
import 'package:m2health/features/psychologist/domain/usecases/create_psychology_appointment.dart';

void initPsychologistModule(GetIt sl) {
  sl.registerLazySingleton(() => CreatePsychologyAppointment(sl()));
  sl.registerLazySingleton<PsychologistAppointmentRepository>(
    () => PsychologistAppointmentRepositoryImpl(appointmentService: sl()),
  );
}
