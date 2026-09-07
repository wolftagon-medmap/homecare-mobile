import 'package:m2health/core/messaging/thread_index_source.dart';
import 'package:m2health/core/messaging/thread_ref.dart';

import '../domain/repositories/messaging_repository.dart';

/// Feeds `lib/core`'s thread index from this feature's repository.
///
/// The core contract deliberately knows nothing about `MessageThread` — this is
/// the one place the rich entity is flattened into the handful of fields an
/// entry point actually needs.
class ThreadIndexAdapter implements ThreadIndexSource {
  final MessagingRepository _repository;

  ThreadIndexAdapter(this._repository);

  @override
  Future<List<ThreadEntry>> loadThreadIndex() async {
    final result = await _repository.loadThreads();
    return result.fold(
      // The cubit logs and keeps what it had; an empty index just means no
      // message buttons, never a broken screen.
      (failure) => throw Exception(failure.message),
      (threads) => threads
          .map((thread) => ThreadEntry(
                threadId: thread.id,
                appointmentId: thread.appointmentId,
                careTaskId: thread.careTaskId,
                unread: thread.unread,
                counterpartName: thread.counterpart?.name ?? 'M2Health',
                isOpen: thread.isOpen,
              ))
          .toList(),
    );
  }
}
