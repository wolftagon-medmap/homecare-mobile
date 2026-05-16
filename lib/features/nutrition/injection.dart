import 'package:get_it/get_it.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_assessment_detail_cubit.dart';
import 'package:m2health/features/nutrition/presentation/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/features/nutrition/data/datasources/nutrition_datasource.dart';
import 'package:m2health/features/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'package:m2health/features/nutrition/domain/repositories/nutrition_repository.dart';
import 'package:m2health/features/nutrition/domain/usecases/create_nutrition_appointment.dart';

void initNutritionModule(GetIt sl) {
  // Datasources
  sl.registerLazySingleton(() => NutritionDatasource(sl()));

  // Use cases
  sl.registerLazySingleton(() => CreateNutritionAppointment(sl()));

  // Repositories
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(
      appointmentService: sl(),
      nutritionDatasource: sl(),
    ),
  );

  // Cubits (factory — new instance per navigation)
  sl.registerFactory(() => NutritionPlanCubit(sl()));
  sl.registerFactory(() => NutritionAssessmentDetailCubit(sl()));
}
