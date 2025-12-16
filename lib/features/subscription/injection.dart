import 'package:get_it/get_it.dart';
import 'package:m2health/features/subscription/data/datasources/subscription_remote_data_source.dart';
import 'package:m2health/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:m2health/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:m2health/features/subscription/domain/usecases/get_subscription_plans.dart';
import 'package:m2health/features/subscription/domain/usecases/get_user_subscriptions.dart';
import 'package:m2health/features/subscription/domain/usecases/purchase_subscription.dart';
import 'package:m2health/features/subscription/presentation/bloc/subscription_cubit.dart';

import 'package:m2health/features/subscription/domain/usecases/toggle_subscription_plan_active.dart';
import 'package:m2health/features/subscription/domain/usecases/update_subscription_plan.dart';

void initSubscriptionModule(GetIt sl) {
  // Datasource
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
      () => SubscriptionRemoteDataSourceImpl(dio: sl()));

  // Repository
  sl.registerLazySingleton<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(remoteDataSource: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetSubscriptionPlans(sl()));
  sl.registerLazySingleton(() => GetUserSubscriptions(sl()));
  sl.registerLazySingleton(() => PurchaseSubscription(sl()));
  sl.registerLazySingleton(() => UpdateSubscriptionPlan(sl()));
  sl.registerLazySingleton(() => ToggleSubscriptionPlanActive(sl()));

  // Cubit
  sl.registerFactory(() => SubscriptionCubit(
        getSubscriptionPlans: sl(),
        getUserSubscriptions: sl(),
        purchaseSubscription: sl(),
      ));
}
