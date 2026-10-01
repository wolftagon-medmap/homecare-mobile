import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';

class AssistantCubit extends Cubit<AssistantState> {
  final AssistantRepository repository;

  AssistantCubit({required this.repository}) : super(const AssistantLoading());

  static const _reconnectDelay = Duration(seconds: 3);
  static const _replyWatchdog = Duration(seconds: 70);
  static const _loadFailed = 'Something went wrong. Please try again.';
  static const _sendFailed = 'Could not send. Please try again.';
  static const _noReply = 'No reply yet. Please try again.';

  StreamSubscription<AssistantBlock>? _subscription;
  Timer? _reconnectTimer;
  Timer? _watchdog;
  final Set<int> _seen = {};
  int _lastEventId = 0;
  int _localId = 0;

  String? get sessionId {
    final current = state;
    return current is AssistantReady ? current.sessionId : null;
  }

  static bool isInteractive(AssistantReady state, AssistantBlock block) {
    if (state.readOnly || state.awaitingReply) return false;
    if (state.resolved.containsKey(block.id)) return false;
    final last = state.blocks.lastWhere(
      _isInteractiveKind,
      orElse: () => const UnknownAssistantBlock(id: 0, kind: 'none'),
    );
    return _isInteractiveKind(block) && last.id == block.id;
  }

  static bool _isInteractiveKind(AssistantBlock block) =>
      block is TopicGridBlock ||
      block is QuestionBlock ||
      block is SummaryBlock ||
      block is ConfirmRequestBlock;

  Future<void> start({bool fresh = false}) async {
    _stopStream();
    _seen.clear();
    _lastEventId = 0;
    emit(const AssistantLoading());

    final started = await repository.startSession(fresh: fresh);
    final id = started.fold<String?>((_) => null, (value) => value);
    if (isClosed) return;
    if (id == null) {
      emit(const AssistantFailed(_loadFailed));
      return;
    }

    final loaded = await repository.history(id);
    final blocks = loaded.fold<List<AssistantBlock>?>((_) => null, (b) => b);
    if (isClosed) return;
    if (blocks == null) {
      emit(const AssistantFailed(_loadFailed));
      return;
    }

    for (final block in blocks) {
      _seen.add(block.id);
      if (block.id > _lastEventId) _lastEventId = block.id;
    }
    emit(AssistantReady(sessionId: id, blocks: blocks));
    _subscribe(id);
  }

  Future<void> view(String sessionId) async {
    emit(const AssistantLoading());
    final loaded = await repository.history(sessionId);
    if (isClosed) return;
    loaded.fold(
      (_) => emit(const AssistantFailed(_loadFailed)),
      (blocks) => emit(AssistantReady(
        sessionId: sessionId,
        readOnly: true,
        blocks: blocks,
        connected: true,
      )),
    );
  }

  void _subscribe(String sessionId) {
    _subscription?.cancel();
    _subscription =
        repository.stream(sessionId, lastEventId: _lastEventId).listen(
              _onBlock,
              onError: (Object error) {
                log('stream error', name: 'chatbot.cubit', error: error);
                _onConnectionLost(sessionId);
              },
              onDone: () => _onConnectionLost(sessionId),
            );
    final current = state;
    if (current is AssistantReady) emit(current.copyWith(connected: true));
  }

  void _onBlock(AssistantBlock block) {
    final current = state;
    if (current is! AssistantReady) return;
    if (_seen.contains(block.id)) return;
    _seen.add(block.id);
    if (block.id > _lastEventId) _lastEventId = block.id;
    _watchdog?.cancel();
    emit(current.copyWith(
      blocks: [...current.blocks, block],
      awaitingReply: false,
      connected: true,
    ));
  }

  void _onConnectionLost(String sessionId) {
    if (isClosed) return;
    final current = state;
    if (current is! AssistantReady || current.readOnly) return;
    emit(current.copyWith(connected: false));
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (isClosed) return;
      final latest = state;
      if (latest is AssistantReady && !latest.readOnly) _subscribe(sessionId);
    });
  }

  void _stopStream() {
    _subscription?.cancel();
    _subscription = null;
    _reconnectTimer?.cancel();
    _watchdog?.cancel();
  }

  Future<void> _send({
    required String label,
    required Future<Either<Failure, Unit>> Function(String sessionId) call,
    int? resolveBlockId,
    String? resolveValue,
  }) async {
    final current = state;
    if (current is! AssistantReady ||
        current.readOnly ||
        current.awaitingReply) {
      return;
    }

    emit(current.copyWith(
      blocks: [
        ...current.blocks,
        UserTextBlock(id: --_localId, text: label),
      ],
      resolved: resolveBlockId == null
          ? null
          : {...current.resolved, resolveBlockId: resolveValue!},
      awaitingReply: true,
      clearActionError: true,
    ));

    _watchdog?.cancel();
    _watchdog = Timer(_replyWatchdog, () {
      if (isClosed) return;
      final latest = state;
      if (latest is AssistantReady && latest.awaitingReply) {
        emit(latest.copyWith(awaitingReply: false, actionError: _noReply));
      }
    });

    final result = await call(current.sessionId);
    if (isClosed) return;
    result.fold(
      (failure) {
        log('send failed', name: 'chatbot.cubit', error: failure);
        _watchdog?.cancel();
        final latest = state;
        if (latest is! AssistantReady) return;
        final resolved = Map<int, String>.of(latest.resolved);
        if (resolveBlockId != null) resolved.remove(resolveBlockId);
        emit(latest.copyWith(
          resolved: resolved,
          awaitingReply: false,
          actionError: _sendFailed,
        ));
      },
      (_) {},
    );
  }

  Future<void> sendText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return Future.value();
    return _send(
      label: trimmed,
      call: (id) => repository.sendText(id, trimmed),
    );
  }

  Future<void> selectTopic(int blockId, AssistantTopic topic) {
    if (_isResolved(blockId)) return Future.value();
    return _send(
      label: topic.label,
      call: (id) => repository.sendReply(
        id,
        replyId: topic.replyId,
        label: topic.label,
      ),
      resolveBlockId: blockId,
      resolveValue: topic.replyId,
    );
  }

  Future<void> chooseOption(int blockId, QuestionBlock question, int index) {
    if (question.mode != QuestionMode.single || _isResolved(blockId)) {
      return Future.value();
    }
    final label = _labelOf(question, index);
    if (label == null) return Future.value();
    return _send(
      label: label,
      call: (id) => repository.sendReply(
        id,
        replyId: 'hc:${question.questionId}:$index',
        label: label,
      ),
      resolveBlockId: blockId,
      resolveValue: '$index',
    );
  }

  void toggleOption(int blockId, QuestionBlock question, int index) {
    final current = state;
    if (current is! AssistantReady || current.readOnly) return;
    if (question.mode != QuestionMode.multi || _isResolved(blockId)) return;

    final picked = {...?current.selections[blockId]};
    if (picked.contains(index)) {
      picked.remove(index);
    } else if (index == question.exclusiveIndex) {
      picked
        ..clear()
        ..add(index);
    } else {
      picked
        ..remove(question.exclusiveIndex)
        ..add(index);
    }
    emit(
        current.copyWith(selections: {...current.selections, blockId: picked}));
  }

  Future<void> submitSelection(int blockId, QuestionBlock question) {
    final current = state;
    if (current is! AssistantReady || question.mode != QuestionMode.multi) {
      return Future.value();
    }
    if (_isResolved(blockId)) return Future.value();
    final picked = (current.selections[blockId] ?? const <int>{}).toList()
      ..sort();
    if (picked.isEmpty) return Future.value();

    final labels = [
      for (final index in picked)
        if (_labelOf(question, index) != null) _labelOf(question, index)!,
    ].join(', ');
    return _send(
      label: labels,
      call: (id) => repository.sendReply(
        id,
        replyId: 'hc:${question.questionId}:${picked.join(',')}',
        label: labels,
      ),
      resolveBlockId: blockId,
      resolveValue: 'submitted',
    );
  }

  Future<void> answerSummary(
    int blockId,
    SummaryBlock summary, {
    required bool confirm,
  }) {
    if (_isResolved(blockId)) return Future.value();
    final replyId = confirm ? summary.confirmReplyId : summary.editReplyId;
    final label = confirm ? summary.confirmLabel : summary.editLabel;
    return _send(
      label: label,
      call: (id) => repository.sendReply(id, replyId: replyId, label: label),
      resolveBlockId: blockId,
      resolveValue: replyId,
    );
  }

  Future<void> answerConfirmRequest(
    int blockId,
    ConfirmRequestBlock request, {
    required bool confirm,
    required String label,
  }) {
    if (_isResolved(blockId)) return Future.value();
    final replyId = confirm ? request.confirmId : request.cancelId;
    return _send(
      label: label,
      call: (id) => repository.sendReply(id, replyId: replyId, label: label),
      resolveBlockId: blockId,
      resolveValue: replyId,
    );
  }

  Future<void> act(NextStepAction action) {
    final current = state;
    if (current is! AssistantReady || current.readOnly) return Future.value();
    switch (action.kind) {
      case NextStepKind.exploreServices:
        emit(current.copyWith(navigation: const OpenAllServices()));
        return Future.value();
      case NextStepKind.reply:
        return _send(
          label: action.title,
          call: (id) => repository.sendReply(
            id,
            replyId: action.replyId,
            label: action.title,
          ),
        );
      case NextStepKind.newConversation:
      case NextStepKind.unknown:
        return Future.value();
    }
  }

  void openSuggestion(ServiceSuggestion suggestion) {
    final current = state;
    final booking = suggestion.booking;
    if (current is! AssistantReady || current.readOnly || booking == null) {
      return;
    }
    emit(current.copyWith(navigation: OpenGuidedBooking(booking)));
  }

  void navigationConsumed() {
    final current = state;
    if (current is AssistantReady) {
      emit(current.copyWith(clearNavigation: true));
    }
  }

  void errorShown() {
    final current = state;
    if (current is AssistantReady) {
      emit(current.copyWith(clearActionError: true));
    }
  }

  bool _isResolved(int blockId) {
    final current = state;
    return current is! AssistantReady || current.resolved.containsKey(blockId);
  }

  String? _labelOf(QuestionBlock question, int index) {
    for (final option in question.options) {
      if (option.index == index) return option.label;
    }
    return null;
  }

  @override
  Future<void> close() {
    _stopStream();
    return super.close();
  }
}
