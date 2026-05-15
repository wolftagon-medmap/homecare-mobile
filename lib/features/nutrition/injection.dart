import 'package:get_it/get_it.dart';
import 'package:m2health/features/nutrition/data/repositories/nutrition_appointment_repository_impl.dart';
import 'package:m2health/features/nutrition/domain/repositories/nutrition_appointment_repository.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';

void initNutritionModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreateNutritionAppointment(sl()));

  // Repository
  sl.registerLazySingleton<NutritionAppointmentRepository>(
    () => NutritionAppointmentRepositoryImpl(
      appointmentService: sl(),
    ),
  );
}
