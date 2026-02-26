import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/chatbot/presentation/bloc/chat_cubit.dart';
import 'package:m2health/features/chatbot/presentation/pages/chat_doctor_ai.dart';
import 'package:m2health/features/chatbot/presentation/pages/chat_pharma.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class ChatbotRoutes {
  static List<GoRoute> routes = [
    GoRoute(
        path: AppRoutes.chatPharmaAI,
        name: AppRoutes.chatPharmaAI,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider<ChatCubit>(
            create: (context) => ChatCubit(
              repository: sl(),
              service: 'pharmacy',
            ),
            child: const ChatPharmaPage(),
          );
        }),
    GoRoute(
        path: AppRoutes.chatDoctorAI,
        name: AppRoutes.chatDoctorAI,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider<ChatCubit>(
            create: (context) => ChatCubit(
              repository: sl(),
              service: 'general',
            ),
            child: const ChatDoctorAIPage(),
          );
        }),
  ];
}
