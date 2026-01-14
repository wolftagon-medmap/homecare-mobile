import 'package:get_it/get_it.dart';
import 'package:m2health/features/settings/account/delete_account/data/repositories/delete_account_repository.dart';

void initSettingsModule(GetIt sl) {
  sl.registerLazySingleton(() => DeleteAccountRepository(dio: sl()));
}
