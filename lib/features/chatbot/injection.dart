import 'package:get_it/get_it.dart';
import 'package:m2health/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:m2health/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';

void initChatbotModule(GetIt sl) {
  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );

  // Cubits/Blocs (should be factory or transient)
  // sl.registerFactory<ChatCubit>(
  //   () => ChatCubit(repository: sl<ChatRepository>()),
  // );
}
