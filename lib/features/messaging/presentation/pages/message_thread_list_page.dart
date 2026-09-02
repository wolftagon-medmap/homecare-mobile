import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';

import '../../messaging_routes.dart';
import '../bloc/thread_index_cubit.dart';
import '../bloc/thread_list_cubit.dart';
import '../widgets/thread_list_tile.dart';

/// Every conversation the signed-in user is part of. Reached from the bell —
/// the notification inbox is where people already go to find what is new.
class MessageThreadListPage extends StatefulWidget {
  const MessageThreadListPage({super.key});

  @override
  State<MessageThreadListPage> createState() => _MessageThreadListPageState();
}

class _MessageThreadListPageState extends State<MessageThreadListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ThreadListCubit>().load();
  }

  Future<void> _open(int threadId) async {
    await context.push(MessagingRoutes.threadPath(threadId));
    if (!mounted) return;
    await context.read<ThreadListCubit>().load();
    if (mounted) await context.read<ThreadIndexCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ThreadListCubit, ThreadListState>(
        builder: (context, state) => switch (state) {
          ThreadListInitial() ||
          ThreadListLoading() =>
            const BookingLoadingState(message: 'Loading your conversations'),
          ThreadListError(:final message) => BookingErrorState(
              message: message,
              onRetry: () => context.read<ThreadListCubit>().load(),
            ),
          ThreadListLoaded(:final threads) when threads.isEmpty =>
            const BookingEmptyState(
              message:
                  'When you send a booking request, you can talk to the professional here.',
              icon: Icons.forum_outlined,
            ),
          ThreadListLoaded(:final threads) => RefreshIndicator(
              onRefresh: () => context.read<ThreadListCubit>().load(),
              backgroundColor: Colors.white,
              color: Const.aqua,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 32),
                itemCount: threads.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 72,
                  color: Const.borderSubtle,
                ),
                itemBuilder: (_, index) => ThreadListTile(
                  thread: threads[index],
                  onTap: () => _open(threads[index].id),
                ),
              ),
            ),
        },
      ),
    );
  }
}
