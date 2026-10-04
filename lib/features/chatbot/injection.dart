import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/features/chatbot/data/datasources/assistant_remote_datasource.dart';
import 'package:m2health/features/chatbot/data/repositories/assistant_repository_impl.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';

void initChatbotModule(GetIt sl) {
  sl.registerLazySingleton<AssistantRemoteDataSource>(
    () => AssistantRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<AssistantRepository>(
    () => AssistantRepositoryImpl(sl<AssistantRemoteDataSource>()),
  );

  sl.registerFactory<AssistantCubit>(
    () => AssistantCubit(repository: sl<AssistantRepository>()),
  );
}
