import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/thread_event.dart';
import '../../domain/repositories/messaging_repository.dart';

class ThreadState extends Equatable {
  final List<ChatMessage> messages;
  final bool loading;
  final bool sending;

  /// Set once, then cleared by the page after it shows it — a card action that
  /// failed has to say so without wiping the conversation off the screen.
  final String? error;

  /// A suggested opener the sender tapped. It fills the composer rather than
  /// sending, so nobody sends a sentence they have not read.
  final String? draft;

  /// How far the other side has read. Everything up to and including this id
  /// has been seen by them.
  final int? readUpToMessageId;

  const ThreadState({
    this.messages = const [],
    this.loading = true,
    this.sending = false,
    this.error,
    this.draft,
    this.readUpToMessageId,
  });

  ThreadState copyWith({
    List<ChatMessage>? messages,
    bool? loading,
    bool? sending,
    String? error,
    bool clearError = false,
    String? draft,
    int? readUpToMessageId,
  }) =>
      ThreadState(
        messages: messages ?? this.messages,
        loading: loading ?? this.loading,
        sending: sending ?? this.sending,
        error: clearError ? null : (error ?? this.error),
        draft: draft ?? this.draft,
        readUpToMessageId: readUpToMessageId ?? this.readUpToMessageId,
      );

  @override
  List<Object?> get props =>
      [messages, loading, sending, error, draft, readUpToMessageId];
}

/// One open conversation.
///
/// Every card action goes through the repository and then re-reads the thread,
/// rather than patching the card in place. The record is the truth; the card is
/// what the record currently looks like.
class ThreadCubit extends Cubit<ThreadState> {
  final MessagingRepository _repository;
  final int threadId;

  StreamSubscription<ThreadEvent>? _activity;

  ThreadCubit(this._repository, this.threadId, {Stream<ThreadEvent>? activity})
      : super(const ThreadState()) {
    _activity = activity
        ?.where((event) => event.threadId == threadId)
        .listen((_) => _reload());
  }

  Future<void> load() => _fetch(showSpinner: true);

  Future<void> _reload() => _fetch(showSpinner: false);

  Future<void> _fetch({required bool showSpinner}) async {
    if (showSpinner) emit(state.copyWith(loading: true, clearError: true));
    final result = await _repository.loadMessages(threadId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(loading: false, error: failure.message)),
      (page) async {
        emit(state.copyWith(
          messages: page.messages,
          loading: false,
          readUpToMessageId: page.readUpToMessageId,
        ));
        await _markRead(page.messages);
      },
    );
  }

  Future<void> send(String body) async {
    final text = body.trim();
    if (text.isEmpty || state.sending) return;

    emit(state.copyWith(sending: true, clearError: true));
    final result = await _repository.sendMessage(threadId, text);
    if (isClosed) return;
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
    if (isClosed) return;
    final failure = result.fold((f) => f, (_) => null);

    if (failure != null) {
      emit(state.copyWith(sending: false, error: failure.message as String));
      return;
    }

    final reloaded = await _repository.loadMessages(threadId);
    if (isClosed) return;
    reloaded.fold(
      (f) => emit(state.copyWith(sending: false, error: f.message)),
      (page) => emit(state.copyWith(
        messages: page.messages,
        sending: false,
        readUpToMessageId: page.readUpToMessageId,
      )),
    );
  }

  Future<void> _markRead(List<ChatMessage> messages) async {
    if (messages.isEmpty) return;
    await _repository.markRead(threadId, messages.last.id);
  }

  void clearError() => emit(state.copyWith(clearError: true));

  /// Hands a suggested opener to the composer. Nothing is sent by this.
  void useOpener(String text) => emit(state.copyWith(draft: text));

  @override
  Future<void> close() async {
    await _activity?.cancel();
    return super.close();
  }
}
