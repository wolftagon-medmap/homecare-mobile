import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/domain/entities/block.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/domain/entities/composer_state.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/domain/repositories/intake_repository.dart';
import 'package:m2health/features/_legacy/chat_intake_booking/presentation/bloc/intake_state.dart';

/// Drives one conversational booking session. Thin on purpose: it manages the
/// SSE connection, appends/dedupes server blocks, holds the latest composer, and
/// posts user actions. No booking logic — the backend owns that.
class IntakeCubit extends Cubit<IntakeState> {
  final IntakeRepository _repository;

  StreamSubscription<Block>? _sseSub;
  Timer? _reconnectTimer;
  final Set<int> _seenIds = {};
  int _lastEventId = 0;
  int _localId = 0; // negative ids for optimistic user bubbles

  static const _reconnectDelay = Duration(seconds: 3);

  IntakeCubit({required IntakeRepository repository})
      : _repository = repository,
        super(const IntakeInitial());

  /// Start/resume the active session; [fresh] archives the current one and
  /// begins a new conversation. Dedupe state is per-session, so it resets here —
  /// a stale SSE cursor from the previous session would skip the new one's blocks.
  Future<void> start({bool fresh = false}) async {
    // Fire-and-forget: awaiting the cancel can hang on the open SSE socket
    // (no CancelToken), which would freeze the whole restart.
    _sseSub?.cancel();
    _sseSub = null;
    _reconnectTimer?.cancel();
    _seenIds.clear();
    _lastEventId = 0;

    emit(const IntakeConnecting());
    try {
      final sessionId = await _repository.startSession(fresh: fresh);
      final history = await _repository.fetchHistory(sessionId);
      for (final b in history) {
        _seenIds.add(b.id);
        if (b.id > _lastEventId) _lastEventId = b.id;
      }
      emit(IntakeActive(
        sessionId: sessionId,
        blocks: history,
        composer: _latestComposer(history) ?? ComposerState.defaults,
      ));
      _subscribe(sessionId);
    } catch (e) {
      emit(IntakeFatal(_messageOf(e)));
    }
  }

  Future<void> sendText(String text) async {
    final trimmed = text.trim();
    final current = state;
    if (trimmed.isEmpty || current is! IntakeActive) return;

    final optimistic = UserTextBlock(id: --_localId, text: trimmed);
    emit(current.copyWith(
      blocks: [...current.blocks, optimistic],
      awaitingReply: true,
      clearActionError: true,
    ));

    try {
      await _repository.sendText(sessionId: current.sessionId, text: trimmed);
    } catch (e) {
      _failAction(e);
    }
  }

  /// Respond to an interactive block (confirm / abort / select) by echoing its
  /// token. Marks the block resolved so its buttons become one-shot; on failure
  /// the block is un-resolved so the user can retry.
  Future<void> respond({required int blockId, required String replyId}) async {
    final current = state;
    if (current is! IntakeActive) return;
    if (current.awaitingReply || current.resolvedChoices.containsKey(blockId)) {
      return;
    }

    emit(current.copyWith(
      resolvedChoices: {...current.resolvedChoices, blockId: replyId},
      awaitingReply: true,
      clearActionError: true,
    ));

    try {
      await _repository.sendReply(
          sessionId: current.sessionId, replyId: replyId);
    } catch (e) {
      final cur = state;
      if (cur is IntakeActive) {
        final choices = Map<int, String>.from(cur.resolvedChoices)
          ..remove(blockId);
        emit(cur.copyWith(
          resolvedChoices: choices,
          awaitingReply: false,
          actionError: _messageOf(e),
        ));
      }
    }
  }

  /// Send a map-picked location answering a `location_request` block. Marks the
  /// block resolved (one-shot); un-resolves on failure so the user can retry.
  Future<void> sendLocation({
    required int blockId,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final current = state;
    if (current is! IntakeActive) return;
    if (current.awaitingReply || current.resolvedChoices.containsKey(blockId))
      return;

    emit(current.copyWith(
      resolvedChoices: {...current.resolvedChoices, blockId: 'picked'},
      awaitingReply: true,
      clearActionError: true,
    ));

    try {
      await _repository.sendLocation(
        sessionId: current.sessionId,
        lat: lat,
        lng: lng,
        address: address,
      );
    } catch (e) {
      final cur = state;
      if (cur is IntakeActive) {
        final choices = Map<int, String>.from(cur.resolvedChoices)
          ..remove(blockId);
        emit(cur.copyWith(
          resolvedChoices: choices,
          awaitingReply: false,
          actionError: _messageOf(e),
        ));
      }
    }
  }

  // ── SSE ───────────────────────────────────────────────────────────────────

  void _subscribe(String sessionId) {
    _sseSub?.cancel();
    _sseSub =
        _repository.streamBlocks(sessionId, lastEventId: _lastEventId).listen(
              _onBlock,
              onError: (_) => _onConnectionLost(sessionId),
              onDone: () => _onConnectionLost(sessionId),
            );
    final current = state;
    if (current is IntakeActive) emit(current.copyWith(connected: true));
  }

  void _onBlock(Block block) {
    final current = state;
    if (current is! IntakeActive) return;
    if (_seenIds.contains(block.id)) return;
    _seenIds.add(block.id);
    if (block.id > _lastEventId) _lastEventId = block.id;
    emit(current.copyWith(
      blocks: [...current.blocks, block],
      composer: block.composer ?? current.composer,
      awaitingReply: false,
      connected: true,
    ));
  }

  void _onConnectionLost(String sessionId) {
    final current = state;
    if (current is IntakeActive) emit(current.copyWith(connected: false));
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (isClosed) return;
      if (state is IntakeActive) _subscribe(sessionId);
    });
  }

  void _failAction(Object error) {
    final current = state;
    if (current is IntakeActive) {
      emit(current.copyWith(
          awaitingReply: false, actionError: _messageOf(error)));
    }
  }

  ComposerState? _latestComposer(List<Block> blocks) {
    for (final b in blocks.reversed) {
      if (b.composer != null) return b.composer;
    }
    return null;
  }

  String _messageOf(Object error) => 'Something went wrong. Please try again.';

  @override
  Future<void> close() {
    _sseSub?.cancel();
    _reconnectTimer?.cancel();
    return super.close();
  }
}
