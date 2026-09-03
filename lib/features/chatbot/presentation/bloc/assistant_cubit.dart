import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_script.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_session_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';
import 'package:uuid/uuid.dart';

/// Drives the guided assistant conversation over a scripted step graph.
///
/// There is no model call here. Every reply is a token the script already
/// declares, so the transcript is reproducible: the same taps always produce
/// the same conversation. That is also what makes history cheap — a saved
/// conversation is the tokens, replayed.
class AssistantCubit extends Cubit<AssistantState> {
  final AssistantRepository repository;
  final AssistantSessionRepository sessions;

  AssistantCubit({
    required this.repository,
    required this.sessions,
  }) : super(const AssistantLoading());

  AssistantScript? _script;
  ScriptStep? _step;
  int _nextBlockId = 0;

  AssistantSession? _session;
  List<AssistantTurn> _turns = [];
  bool _recording = true;

  String? get sessionId => _session?.id;

  Future<void> start() async {
    final script = await _loadScript();
    if (script == null) return;
    _recording = true;
    _beginSession();
  }

  /// Opens a clean conversation. The outgoing one needs no archiving step —
  /// every turn was already written to the store as it happened.
  void newConversation() {
    if (_script == null) return;
    _recording = true;
    _beginSession();
  }

  /// Rebuilds a saved conversation read-only. Nothing is recorded and no route
  /// is ever requested, so a replayed `next_step` action cannot navigate.
  Future<void> open(AssistantSession session) async {
    final script = await _loadScript();
    if (script == null) return;
    _recording = false;
    _session = session;
    _turns = [];
    _reset();
    for (final turn in session.turns) {
      _apply(turn);
    }
  }

  void restart() {
    if (_script == null) return;
    _reset();
  }

  Future<AssistantScript?> _loadScript() async {
    emit(const AssistantLoading());
    final result = await repository.script();
    return result.fold(
      (failure) {
        log('assistant script failed', name: 'chatbot.cubit', error: failure);
        emit(AssistantFailed(failure.message));
        return null;
      },
      (script) {
        _script = script;
        return script;
      },
    );
  }

  void _beginSession() {
    final now = DateTime.now();
    _turns = [];
    _session = AssistantSession(
      id: const Uuid().v4(),
      scriptId: _script?.scriptId ?? '',
      startedAt: now,
      updatedAt: now,
      preview: null,
      turns: const [],
    );
    _reset();
  }

  void _reset() {
    _nextBlockId = 0;
    _step = null;
    emit(const AssistantReady(
      blocks: [],
      resolved: {},
      selections: {},
      answers: {},
    ));
    _enter(_script!.entryStep);
  }

  void _enter(String stepId) {
    final current = state;
    if (current is! AssistantReady) return;
    final step = _script?.step(stepId);
    if (step == null) {
      log('unknown step $stepId', name: 'chatbot.cubit');
      return;
    }
    _step = step;
    emit(current.copyWith(
      blocks: [
        ...current.blocks,
        ...step.blocks.map((block) => block.copyWithId(_nextBlockId++)),
      ],
    ));
  }

  void choose(int blockId, String replyId) {
    final current = state;
    if (current is! AssistantReady) return;
    if (current.resolved.containsKey(blockId)) return;

    final block = _blockOf(current, blockId);
    final echo = switch (block) {
      SingleChoiceBlock(:final options) => _choice(options, replyId)?.echoText,
      TopicGridBlock(:final topics) => _topic(topics, replyId)?.echoText,
      _ => null,
    };
    final summary = switch (block) {
      SingleChoiceBlock(:final options) =>
        _choice(options, replyId)?.summaryText,
      _ => null,
    };

    final step = _step;
    emit(current.copyWith(
      resolved: {...current.resolved, blockId: replyId},
      answers: _record(current.answers, step?.answerKey, summary),
      blocks: echo == null
          ? current.blocks
          : [...current.blocks, UserTextBlock(id: _nextBlockId++, text: echo)],
    ));

    _remember(AssistantTurn(
      kind: AssistantTurnKind.choose,
      replyIds: [replyId],
    ));

    final next = step?.nextFor(replyId);
    if (next != null) _enter(next);
  }

  void toggle(int blockId, String optionId) {
    final current = state;
    if (current is! AssistantReady) return;
    if (current.resolved.containsKey(blockId)) return;

    final block = _blockOf(current, blockId);
    if (block is! MultiChoiceBlock) return;

    final picked = [...?current.selections[blockId]];
    final exclusive = block.exclusiveOptionId;

    if (picked.contains(optionId)) {
      picked.remove(optionId);
    } else if (optionId == exclusive) {
      picked
        ..clear()
        ..add(optionId);
    } else {
      picked
        ..remove(exclusive)
        ..add(optionId);
    }

    emit(current.copyWith(
      selections: {...current.selections, blockId: picked},
    ));
  }

  void submitSelection(int blockId) {
    final current = state;
    if (current is! AssistantReady) return;
    if (current.resolved.containsKey(blockId)) return;

    final block = _blockOf(current, blockId);
    if (block is! MultiChoiceBlock) return;

    final picked = current.selections[blockId] ?? const <String>[];
    if (picked.isEmpty) return;

    final labels = block.options
        .where((option) => picked.contains(option.replyId))
        .map((option) => option.summaryText)
        .join(', ');

    final step = _step;
    emit(current.copyWith(
      resolved: {...current.resolved, blockId: picked.join(',')},
      answers: _record(current.answers, step?.answerKey, labels),
      blocks: [
        ...current.blocks,
        UserTextBlock(id: _nextBlockId++, text: labels),
      ],
    ));

    _remember(AssistantTurn(
      kind: AssistantTurnKind.submit,
      replyIds: List<String>.of(picked),
    ));

    final next = step?.nextFor(picked.first);
    if (next != null) _enter(next);
  }

  void act(NextStepAction action) {
    final current = state;
    if (current is! AssistantReady) return;

    if (action.restart) {
      if (_recording) newConversation();
      return;
    }

    final reply = action.reply;
    emit(current.copyWith(
      blocks: reply == null
          ? [
              ...current.blocks,
              UserTextBlock(id: _nextBlockId++, text: action.title),
            ]
          : [
              ...current.blocks,
              UserTextBlock(id: _nextBlockId++, text: action.title),
              AssistantTextBlock(id: _nextBlockId++, text: reply),
            ],
      pendingRoute: _recording ? action.route : null,
    ));

    _remember(AssistantTurn(
      kind: AssistantTurnKind.act,
      replyIds: [action.replyId],
    ));
  }

  void openSuggestion(ServiceSuggestion suggestion) {
    final current = state;
    if (current is! AssistantReady) return;
    if (!_recording) return;
    if (suggestion.route == null) return;
    emit(current.copyWith(pendingRoute: suggestion.route));
  }

  void routeConsumed() {
    final current = state;
    if (current is! AssistantReady) return;
    emit(current.copyWith());
  }

  void sendText(String text) {
    final current = state;
    if (current is! AssistantReady) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final step = _step;
    final blocks = [
      ...current.blocks,
      UserTextBlock(id: _nextBlockId++, text: trimmed),
    ];

    final advanceTo = step?.textNext;
    if (advanceTo != null) {
      emit(current.copyWith(blocks: blocks));
      _remember(AssistantTurn(kind: AssistantTurnKind.text, text: trimmed));
      _enter(advanceTo);
      return;
    }

    final reply = step?.textReply ?? _script?.offTopicReply ?? '';
    emit(current.copyWith(
      blocks: [
        ...blocks,
        if (reply.isNotEmpty)
          AssistantTextBlock(id: _nextBlockId++, text: reply),
      ],
    ));
    _remember(AssistantTurn(kind: AssistantTurnKind.text, text: trimmed));
  }

  /// Re-applies one recorded turn against whatever question is currently open.
  /// A token the script no longer declares simply stops the replay, leaving a
  /// partial transcript rather than throwing.
  void _apply(AssistantTurn turn) {
    final current = state;
    if (current is! AssistantReady) return;

    switch (turn.kind) {
      case AssistantTurnKind.text:
        sendText(turn.text ?? '');
      case AssistantTurnKind.choose:
        final id = _openBlockId(current);
        if (id != null && turn.replyIds.isNotEmpty) {
          choose(id, turn.replyIds.first);
        }
      case AssistantTurnKind.submit:
        final id = _openBlockId(current);
        if (id == null) return;
        for (final optionId in turn.replyIds) {
          toggle(id, optionId);
        }
        submitSelection(id);
      case AssistantTurnKind.act:
        final block = current.blocks.whereType<NextStepBlock>().lastOrNull;
        if (block == null || turn.replyIds.isEmpty) return;
        for (final action in block.actions) {
          if (action.replyId == turn.replyIds.first) {
            act(action);
            return;
          }
        }
    }
  }

  /// The question still awaiting an answer — the last unresolved interactive
  /// block, not simply the last block, because free text appends bubbles after
  /// an open question.
  int? _openBlockId(AssistantReady current) {
    for (final block in current.blocks.reversed) {
      if (current.resolved.containsKey(block.id)) continue;
      final interactive = block is TopicGridBlock ||
          block is SingleChoiceBlock ||
          block is MultiChoiceBlock ||
          block is SummaryBlock;
      if (interactive) return block.id;
    }
    return null;
  }

  void _remember(AssistantTurn turn) {
    if (!_recording) return;
    _turns.add(turn);
    _persist();
  }

  Future<void> _persist() async {
    final session = _session;
    if (!_recording || session == null || _turns.isEmpty) return;
    final updated = session.copyWith(
      updatedAt: DateTime.now(),
      preview: _preview(),
      turns: List<AssistantTurn>.of(_turns),
    );
    _session = updated;
    final result = await sessions.save(updated);
    result.fold(
      (failure) =>
          log('session save failed', name: 'chatbot.cubit', error: failure),
      (_) {},
    );
  }

  String? _preview() {
    final current = state;
    if (current is! AssistantReady) return null;
    for (final block in current.blocks) {
      if (block is UserTextBlock) return block.text;
    }
    return null;
  }

  Map<String, String> _record(
    Map<String, String> answers,
    String? key,
    String? value,
  ) {
    if (key == null || value == null || value.isEmpty) return answers;
    return {...answers, key: value};
  }

  AssistantBlock? _blockOf(AssistantReady state, int blockId) {
    for (final block in state.blocks) {
      if (block.id == blockId) return block;
    }
    return null;
  }

  AssistantChoice? _choice(List<AssistantChoice> options, String replyId) {
    for (final option in options) {
      if (option.replyId == replyId) return option;
    }
    return null;
  }

  AssistantTopic? _topic(List<AssistantTopic> topics, String replyId) {
    for (final topic in topics) {
      if (topic.replyId == replyId) return topic;
    }
    return null;
  }
}
