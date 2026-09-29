import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/core/messaging/thread_index_cubit.dart';
import 'package:m2health/core/messaging/thread_index_source.dart';

import 'data/datasources/messaging_datasource.dart';
import 'data/datasources/messaging_remote_datasource.dart';
import 'data/datasources/thread_socket_client.dart';
import 'data/datasources/thread_stream.dart';
import 'data/repositories/messaging_repository_impl.dart';
import 'domain/repositories/messaging_repository.dart';
import 'data/thread_index_adapter.dart';
import 'presentation/bloc/thread_activity_hub.dart';

/// Dependency registrations for patient / professional messaging. Called from
/// `service_locator.dart`.
void initMessagingModule(GetIt sl) {
  sl.registerLazySingleton<MessagingDataSource>(
    () => MessagingRemoteDataSource(sl<Dio>()),
  );

  sl.registerLazySingleton<MessagingRepository>(
    () => MessagingRepositoryImpl(sl<MessagingDataSource>()),
  );

  // The index is core's, fed from here. Registering the core type is what lets
  // features/appointment read it without importing this feature.
  sl.registerLazySingleton<ThreadIndexSource>(
    () => ThreadIndexAdapter(sl<MessagingRepository>()),
  );

  // One instance app-wide: every message entry point reads the same index, so a
  // thread read in one place clears its badge everywhere.
  sl.registerLazySingleton<ThreadIndexCubit>(
    () => ThreadIndexCubit(sl<ThreadIndexSource>()),
  );

  sl.registerLazySingleton<ThreadStream>(
    () => ThreadSocketClient(sl<Dio>()),
  );

  sl.registerLazySingleton<ThreadActivityHub>(
    () => ThreadActivityHub(sl<ThreadStream>(), sl<ThreadIndexCubit>()),
  );
}
