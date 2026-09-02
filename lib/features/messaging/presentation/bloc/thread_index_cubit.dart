import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/message_thread.dart';
import '../../domain/repositories/messaging_repository.dart';

class ThreadIndexState extends Equatable {
  final List<MessageThread> threads;
  final bool loaded;

  const ThreadIndexState({this.threads = const [], this.loaded = false});

  int get totalUnread => threads.fold(0, (sum, thread) => sum + thread.unread);

  /// The thread a card is asking about, or null when there is no conversation
  /// for it. A null answer means the card renders no message button at all —
  /// which is why a card can never navigate to a dead screen.
  MessageThread? resolve(ThreadRef ref) {
    for (final thread in threads) {
      if (!thread.isOpen) continue;
      if (ref.appointmentId != null &&
          thread.appointmentId == ref.appointmentId) {
        return thread;
      }
      if (ref.careTaskId != null && thread.careTaskId == ref.careTaskId) {
        return thread;
      }
    }
    return null;
  }

  ThreadIndexState copyWith({List<MessageThread>? threads, bool? loaded}) =>
      ThreadIndexState(
        threads: threads ?? this.threads,
        loaded: loaded ?? this.loaded,
      );

  @override
  List<Object?> get props => [threads, loaded];
}

/// The index every message entry point reads.
///
/// It exists so that an appointment card can offer a conversation without the
/// appointment payload ever having to carry a thread id — the card names what
/// it is (`ThreadRef.forAppointment(42)`) and this resolves it against the list
/// it already loaded. That is what kept this feature out of every v1 response
/// shape.
class ThreadIndexCubit extends Cubit<ThreadIndexState> {
  final MessagingRepository _repository;

  ThreadIndexCubit(this._repository) : super(const ThreadIndexState());

  Future<void> load() async {
    final result = await _repository.loadThreads();
    result.fold(
      (failure) {
        // A missing index costs a message button, never a screen. Every caller
        // treats "no thread" as "no button", so failing quietly is correct.
        log('thread index unavailable: ${failure.message}',
            name: 'messaging.index');
        emit(state.copyWith(loaded: true));
      },
      (threads) => emit(ThreadIndexState(threads: threads, loaded: true)),
    );
  }

  /// Called after a thread is read, so every badge in the app settles at once.
  Future<void> refresh() => load();
}
