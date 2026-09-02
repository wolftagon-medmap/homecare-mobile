import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/message_thread.dart';
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

  ThreadListCubit(this._repository) : super(const ThreadListInitial());

  Future<void> load() async {
    emit(const ThreadListLoading());
    final result = await _repository.loadThreads();
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
}
