import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/blocs/user_role_cubit.dart';
import 'package:m2health/core/messaging/thread_index_cubit.dart';
import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/features/messaging/data/datasources/messaging_local_datasource.dart';
import 'package:m2health/features/messaging/data/datasources/thread_stream.dart';
import 'package:m2health/features/messaging/data/repositories/messaging_repository_impl.dart';
import 'package:m2health/features/messaging/data/thread_index_adapter.dart';
import 'package:m2health/features/messaging/domain/repositories/messaging_repository.dart';
import 'package:m2health/features/messaging/messaging_routes.dart';
import 'package:m2health/features/messaging/presentation/bloc/thread_activity_hub.dart';
import 'package:m2health/features/messaging/presentation/widgets/chat_bubble.dart';
import 'package:m2health/route/navigator_keys.dart';

/// A notification deep link arrives with the thread id and nothing else. If the
/// host does not resolve the thread, `counterpartUserId` is null, `isMine`
/// returns true for every authored message, and the whole conversation draws as
/// the patient talking to themselves.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GetIt sl;

  setUp(() async {
    sl = GetIt.instance;
    await sl.reset();
    final repository = MessagingRepositoryImpl(MessagingLocalDataSource())
        as MessagingRepository;
    final index = ThreadIndexCubit(ThreadIndexAdapter(repository));
    sl.registerSingleton<MessagingRepository>(repository);
    sl.registerSingleton<ThreadIndexCubit>(index);
    sl.registerSingleton<ThreadActivityHub>(
        ThreadActivityHub(ThreadStreamLocal(), index));
  });

  tearDown(() => GetIt.instance.reset());

  Future<void> openDeepLink(WidgetTester tester) async {
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: MessagingRoutes.threadPath(1),
      routes: MessagingRoutes.routes,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<UserRoleCubit>(
          create: (_) => UserRoleCubit()..setUserRole(UserRole.patient),
        ),
        BlocProvider<ThreadIndexCubit>.value(value: sl<ThreadIndexCubit>()),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('a deep-linked thread still knows which side wrote each message',
      (tester) async {
    await openDeepLink(tester);

    final bubbles = tester
        .widgetList<ChatBubble>(find.byType(ChatBubble))
        .map((b) => b.isMine)
        .toList();

    // Thread 1 is three lines from the professional and two from the patient.
    // Counting matters: an unresolved counterpart still leaves the system line
    // drawn as not-mine, so `contains(false)` would pass while every real
    // message was wrong.
    expect(bubbles.where((mine) => mine), hasLength(2));
    expect(bubbles.where((mine) => !mine).length, greaterThanOrEqualTo(3),
        reason:
            'every authored bubble drawn as mine means the counterpart was never resolved');
  });

  testWidgets('and it recovers the counterpart name for the app bar',
      (tester) async {
    await openDeepLink(tester);

    expect(find.text('Aisyah Rahman'), findsOneWidget);
  });
}
