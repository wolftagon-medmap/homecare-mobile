import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'thread_index_source.dart';
import 'thread_ref.dart';

class ThreadIndexState extends Equatable {
  final List<ThreadEntry> entries;
  final bool loaded;

  const ThreadIndexState({this.entries = const [], this.loaded = false});

  int get totalUnread => entries.fold(0, (sum, entry) => sum + entry.unread);

  /// The conversation a card is asking about, or null when there is none.
  ///
  /// A null answer means the card renders no message button at all — which is
  /// why a card can never navigate to a screen that is not there.
  ThreadEntry? resolve(ThreadRef ref) {
    for (final entry in entries) {
      if (entry.matches(ref)) return entry;
    }
    return null;
  }

  /// Used by a deep link, which arrives with a thread id and nothing else.
  ThreadEntry? byId(int threadId) {
    for (final entry in entries) {
      if (entry.threadId == threadId) return entry;
    }
    return null;
  }

  @override
  List<Object?> get props => [entries, loaded];
}

/// The index every message entry point reads.
///
/// It lives in `lib/core` because `features/appointment` and
/// `features/notifications` both need it, and neither may reach into
/// `features/messaging` (AGENTS.md rule 3). The messaging feature supplies the
/// data through [ThreadIndexSource]; nothing else knows it exists.
class ThreadIndexCubit extends Cubit<ThreadIndexState> {
  final ThreadIndexSource _source;

  ThreadIndexCubit(this._source) : super(const ThreadIndexState());

  Future<void> load() async {
    try {
      emit(ThreadIndexState(
          entries: await _source.loadThreadIndex(), loaded: true));
    } catch (e, stackTrace) {
      // A missing index costs a message button, never a screen. Every caller
      // treats "no thread" as "no button", so failing quietly is correct.
      log('thread index unavailable',
          name: 'messaging.index', error: e, stackTrace: stackTrace);
      emit(ThreadIndexState(entries: state.entries, loaded: true));
    }
  }

  /// Called after a thread is read, so every badge in the app settles at once.
  Future<void> refresh() => load();
}
