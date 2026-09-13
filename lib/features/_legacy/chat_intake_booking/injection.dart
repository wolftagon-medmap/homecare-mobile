import 'package:get_it/get_it.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/data/datasources/intake_remote_datasource.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/data/repositories/intake_repository_impl.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/domain/repositories/intake_repository.dart';

void initIntakeBookingModule(GetIt sl) {
  sl.registerLazySingleton<IntakeRepository>(
    () => IntakeRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<IntakeRemoteDataSource>(
    () => IntakeRemoteDataSourceImpl(sl()),
  );
}
