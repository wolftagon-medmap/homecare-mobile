import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/core/messaging/messaging_entry.dart';
import 'package:m2health/core/messaging/thread_index_cubit.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

import 'domain/entities/message_thread.dart';
import 'domain/repositories/messaging_repository.dart';
import 'presentation/bloc/thread_activity_hub.dart';
import 'presentation/bloc/thread_cubit.dart';
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

  /// Callers outside this feature navigate with `MessagingEntry.threadPath`.
  static String threadPath(int threadId) => MessagingEntry.threadPath(threadId);

  static List<RouteBase> routes = [
    GoRoute(
      // Root navigator: a conversation covers the bottom app bar.
      parentNavigatorKey: rootNavigatorKey,
      path: entry,
      builder: (context, state) => BlocProvider(
        create: (_) => ThreadListCubit(
          sl<MessagingRepository>(),
          activity: sl<ThreadActivityHub>().events,
        ),
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

            // The list passes the thread it already has, so the header renders
            // immediately. A deep link from a notification passes nothing, and
            // the core index supplies the name until the messages arrive.
            final passed = state.extra is MessageThread
                ? state.extra as MessageThread
                : null;
            final fallbackName = context
                .read<ThreadIndexCubit>()
                .state
                .byId(threadId)
                ?.counterpartName;

            return BlocProvider(
              create: (_) => ThreadCubit(
                sl<MessagingRepository>(),
                threadId,
                activity: sl<ThreadActivityHub>().events,
              ),
              child: _ThreadHost(
                threadId: threadId,
                passed: passed,
                fallbackName: fallbackName,
              ),
            );
          },
        ),
      ],
    ),
  ];
}

/// A deep link carries only the id, so the counterpart — and with it, which
/// side of the conversation each message belongs to — has to be recovered
/// before the bubbles can be drawn correctly.
class _ThreadHost extends StatelessWidget {
  const _ThreadHost({
    required this.threadId,
    required this.passed,
    required this.fallbackName,
  });

  final int threadId;
  final MessageThread? passed;
  final String? fallbackName;

  Widget _page(BuildContext context, MessageThread? thread) =>
      context.read<UserRoleCubit>().state.isProvider
          ? ProfessionalChatPage(thread: thread, fallbackName: fallbackName)
          : PatientChatPage(thread: thread, fallbackName: fallbackName);

  @override
  Widget build(BuildContext context) {
    if (passed != null) return _page(context, passed);

    return BlocProvider(
      create: (_) => ThreadListCubit(sl<MessagingRepository>())..load(),
      child: BlocBuilder<ThreadListCubit, ThreadListState>(
        builder: (context, state) {
          MessageThread? resolved;
          if (state is ThreadListLoaded) {
            for (final thread in state.threads) {
              if (thread.id == threadId) {
                resolved = thread;
                break;
              }
            }
          }
          return _page(context, resolved);
        },
      ),
    );
  }
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
