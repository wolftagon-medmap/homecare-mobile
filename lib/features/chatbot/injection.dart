import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/features/chatbot/data/datasources/assistant_script_datasource.dart';
import 'package:m2health/features/chatbot/data/datasources/assistant_session_store.dart';
import 'package:m2health/features/chatbot/data/repositories/assistant_repository_impl.dart';
import 'package:m2health/features/chatbot/data/repositories/assistant_session_repository_impl.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_session_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';

/// Dependency registrations for the AI Assistant surface. Called from
/// `service_locator.dart`. Conversation history is device storage.
void initChatbotModule(GetIt sl) {
  sl.registerLazySingleton<AssistantScriptDataSource>(
    () => AssistantScriptRemoteDataSource(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<AssistantRepository>(
    () => AssistantRepositoryImpl(source: sl<AssistantScriptDataSource>()),
  );

  sl.registerLazySingleton<AssistantSessionStore>(
    () => AssistantSessionStore(),
  );

  sl.registerLazySingleton<AssistantSessionRepository>(
    () => AssistantSessionRepositoryImpl(store: sl<AssistantSessionStore>()),
  );

  sl.registerFactory<AssistantCubit>(
    () => AssistantCubit(
      repository: sl<AssistantRepository>(),
      sessions: sl<AssistantSessionRepository>(),
    ),
  );
}
