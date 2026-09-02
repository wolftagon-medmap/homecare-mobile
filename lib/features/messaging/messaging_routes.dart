import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

import 'domain/entities/message_thread.dart';
import 'domain/repositories/messaging_repository.dart';
import 'presentation/bloc/thread_cubit.dart';
import 'presentation/bloc/thread_index_cubit.dart';
import 'presentation/bloc/thread_list_cubit.dart';
import 'presentation/pages/message_thread_list_page.dart';
import 'presentation/pages/patient_chat_page.dart';
import 'presentation/pages/professional_chat_page.dart';

/// Routes for patient / professional messaging. Owned by A2.
///
/// Registered once in `app_router.dart` — do not open that file. Add internal
/// paths as constants here; `AppRoutes` carries only the entry point.
class MessagingRoutes {
  static const String entry = AppRoutes.messages;
  static const String thread = '$entry/thread/:threadId';

  static String threadPath(int threadId) => '$entry/thread/$threadId';

  static List<RouteBase> routes = [
    GoRoute(
      // Root navigator: a conversation covers the bottom app bar.
      parentNavigatorKey: rootNavigatorKey,
      path: entry,
      builder: (context, state) => BlocProvider(
        create: (_) => ThreadListCubit(sl<MessagingRepository>()),
        child: const MessageThreadListPage(),
      ),
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'thread/:threadId',
          builder: (context, state) {
            final threadId =
                int.tryParse(state.pathParameters['threadId'] ?? '');
            if (threadId == null) return const _UnknownThread();

            // The list passes the thread it already has so the header renders
            // immediately; a deep link from a notification passes nothing and
            // the index fills it in.
            final passed = state.extra is MessageThread
                ? state.extra as MessageThread
                : context
                    .read<ThreadIndexCubit>()
                    .state
                    .threads
                    .where(
                      (t) => t.id == threadId,
                    )
                    .firstOrNull;

            return BlocProvider(
              create: (_) => ThreadCubit(sl<MessagingRepository>(), threadId),
              child: context.read<UserRoleCubit>().state.isProvider
                  ? ProfessionalChatPage(thread: passed)
                  : PatientChatPage(thread: passed),
            );
          },
        ),
      ],
    ),
  ];
}

class _UnknownThread extends StatelessWidget {
  const _UnknownThread();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation')),
      body: const Center(
          child: Text('That conversation is no longer available.')),
    );
  }
}
