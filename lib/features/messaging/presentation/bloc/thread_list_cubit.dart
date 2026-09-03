import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/message_thread.dart';
import '../../domain/entities/thread_event.dart';
import '../../domain/repositories/messaging_repository.dart';

sealed class ThreadListState extends Equatable {
  const ThreadListState();

  @override
  List<Object?> get props => [];
}

class ThreadListInitial extends ThreadListState {
  const ThreadListInitial();
}

class ThreadListLoading extends ThreadListState {
  const ThreadListLoading();
}

class ThreadListLoaded extends ThreadListState {
  final List<MessageThread> threads;

  const ThreadListLoaded(this.threads);

  @override
  List<Object?> get props => [threads];
}

class ThreadListError extends ThreadListState {
  final String message;

  const ThreadListError(this.message);

  @override
  List<Object?> get props => [message];
}

class ThreadListCubit extends Cubit<ThreadListState> {
  final MessagingRepository _repository;

  StreamSubscription<ThreadEvent>? _activity;

  ThreadListCubit(this._repository, {Stream<ThreadEvent>? activity})
      : super(const ThreadListInitial()) {
    _activity = activity?.listen((_) => _fetch(showSpinner: false));
  }

  Future<void> load() => _fetch(showSpinner: true);

  Future<void> _fetch({required bool showSpinner}) async {
    if (showSpinner) emit(const ThreadListLoading());
    final result = await _repository.loadThreads();
    if (isClosed) return;
    emit(result.fold(
      (failure) => ThreadListError(failure.message),
      // Newest activity first; a thread that has never been written to sorts last.
      (threads) => ThreadListLoaded(threads.toList()
        ..sort((a, b) {
          final left = a.lastMessageAt;
          final right = b.lastMessageAt;
          if (left == null && right == null) return 0;
          if (left == null) return 1;
          if (right == null) return -1;
          return right.compareTo(left);
        })),
    ));
  }

  @override
  Future<void> close() async {
    await _activity?.cancel();
    return super.close();
  }
}
