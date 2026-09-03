import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/core/messaging/thread_index_cubit.dart';
import 'package:m2health/core/messaging/thread_index_source.dart';

import 'data/datasources/messaging_datasource.dart';
import 'data/datasources/messaging_local_datasource.dart';
import 'data/datasources/messaging_remote_datasource.dart';
import 'data/datasources/thread_socket_client.dart';
import 'data/datasources/thread_stream.dart';
import 'data/repositories/messaging_repository_impl.dart';
import 'domain/repositories/messaging_repository.dart';
import 'data/thread_index_adapter.dart';
import 'presentation/bloc/thread_activity_hub.dart';

/// Dependency registrations for patient / professional messaging. Owned by A2.
///
/// Called from `service_locator.dart` — do not open that file. Data sources
/// resolve through `AppFlags.remote(Feature.x)`; see
/// `lib/core/config/feature_flags.dart`.
void initMessagingModule(GetIt sl) {
  // Threads, messages and the time proposal all come from one transport, so
  // they share one flag decision: `messageThreads` is the switch, and
  // `messageStream` and `timeProposal` gate the live and proposal paths within
  // it. Flipping any of them to remote moves the whole source, which is what
  // stops a half-fixture half-server thread.
  final remote = AppFlags.remote(Feature.messageThreads) ||
      AppFlags.remote(Feature.messageStream) ||
      AppFlags.remote(Feature.timeProposal);

  sl.registerLazySingleton<MessagingDataSource>(
    () => remote
        ? MessagingRemoteDataSource(sl<Dio>())
        : MessagingLocalDataSource(),
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
    () => AppFlags.remote(Feature.messageStream)
        ? ThreadSocketClient(sl<Dio>())
        : ThreadStreamLocal(),
  );

  sl.registerLazySingleton<ThreadActivityHub>(
    () => ThreadActivityHub(sl<ThreadStream>(), sl<ThreadIndexCubit>()),
  );
}
