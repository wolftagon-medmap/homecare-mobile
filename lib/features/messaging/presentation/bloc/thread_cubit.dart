import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/messaging_repository.dart';

class ThreadState extends Equatable {
  final List<ChatMessage> messages;
  final bool loading;
  final bool sending;

  /// Set once, then cleared by the page after it shows it — a card action that
  /// failed has to say so without wiping the conversation off the screen.
  final String? error;

  const ThreadState({
    this.messages = const [],
    this.loading = true,
    this.sending = false,
    this.error,
  });

  ThreadState copyWith({
    List<ChatMessage>? messages,
    bool? loading,
    bool? sending,
    String? error,
    bool clearError = false,
  }) =>
      ThreadState(
        messages: messages ?? this.messages,
        loading: loading ?? this.loading,
        sending: sending ?? this.sending,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [messages, loading, sending, error];
}

/// One open conversation.
///
/// Every card action goes through the repository and then re-reads the thread,
/// rather than patching the card in place. The record is the truth; the card is
/// what the record currently looks like.
class ThreadCubit extends Cubit<ThreadState> {
  final MessagingRepository _repository;
  final int threadId;

  ThreadCubit(this._repository, this.threadId) : super(const ThreadState());

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    final result = await _repository.loadMessages(threadId);
    result.fold(
      (failure) => emit(state.copyWith(loading: false, error: failure.message)),
      (messages) async {
        emit(state.copyWith(messages: messages, loading: false));
        await _markRead(messages);
      },
    );
  }

  Future<void> send(String body) async {
    final text = body.trim();
    if (text.isEmpty || state.sending) return;

    emit(state.copyWith(sending: true, clearError: true));
    final result = await _repository.sendMessage(threadId, text);
    result.fold(
      (failure) => emit(state.copyWith(sending: false, error: failure.message)),
      (message) => emit(state.copyWith(
        messages: [...state.messages, message],
        sending: false,
      )),
    );
  }

  Future<void> acceptProposal(int proposalId) =>
      _act(() => _repository.acceptProposal(threadId, proposalId));

  Future<void> chooseAnotherTime(int proposalId, {DateTime? preferred}) =>
      _act(() => _repository.chooseAnotherTime(
            threadId: threadId,
            proposalId: proposalId,
            preferred: preferred,
          ));

  Future<void> proposeTime({
    required int careTaskId,
    required DateTime start,
    required DateTime end,
    String? reason,
  }) =>
      _act(() => _repository.proposeTime(
            threadId: threadId,
            careTaskId: careTaskId,
            start: start,
            end: end,
            reason: reason,
          ));

  Future<void> approveEstimate(int revisionId) =>
      _act(() => _repository.approveEstimate(threadId, revisionId));

  /// Run a card action, then reload so the card and any system line it produced
  /// both come from the server's version of events.
  Future<void> _act(Future<dynamic> Function() action) async {
    emit(state.copyWith(sending: true, clearError: true));
    final result = await action();
    final failure = result.fold((f) => f, (_) => null);

    if (failure != null) {
      emit(state.copyWith(sending: false, error: failure.message as String));
      return;
    }

    final reloaded = await _repository.loadMessages(threadId);
    reloaded.fold(
      (f) => emit(state.copyWith(sending: false, error: f.message)),
      (messages) => emit(state.copyWith(messages: messages, sending: false)),
    );
  }

  Future<void> _markRead(List<ChatMessage> messages) async {
    if (messages.isEmpty) return;
    await _repository.markRead(threadId, messages.last.id);
  }

  void clearError() => emit(state.copyWith(clearError: true));
}
