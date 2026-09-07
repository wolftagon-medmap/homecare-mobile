import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_cubit.dart';
import 'package:m2health/features/chatbot/presentation/pages/ai_assistant_page.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class ChatbotRoutes {
  static const String aiAssistant = '/ai-assistant';

  static List<GoRoute> routes = [
    GoRoute(
      path: aiAssistant,
      name: aiAssistant,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => BlocProvider<AssistantCubit>(
        create: (_) => sl<AssistantCubit>(),
        child: const AiAssistantPage(),
      ),
    ),
  ];
}
