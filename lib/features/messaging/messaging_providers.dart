import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:m2health/core/messaging/thread_index_cubit.dart';

import 'presentation/bloc/thread_activity_hub.dart';

/// App-wide blocs for patient / professional messaging. Owned by A2.
///
/// Spread into the root `MultiBlocProvider` in `main.dart` — do not open that
/// file. Screen-scoped blocs belong on their route, not here.
class MessagingProviders {
  static List<SingleChildWidget> get providers => [
        // App-wide because a message button can appear on any appointment card,
        // in either app, and they all read the same unread counts.
        BlocProvider<ThreadIndexCubit>(
          create: (_) => sl<ThreadIndexCubit>()..load(),
        ),
        // `lazy: false` is load-bearing: nothing reads the hub out of the tree,
        // so without it `create` never runs and live delivery silently never
        // starts.
        Provider<ThreadActivityHub>(
          lazy: false,
          create: (_) {
            final hub = sl<ThreadActivityHub>();
            unawaited(hub.start());
            return hub;
          },
          dispose: (_, hub) => unawaited(hub.stop()),
        ),
      ];
}
