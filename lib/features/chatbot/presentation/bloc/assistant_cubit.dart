import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_script.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';
import 'package:m2health/features/chatbot/presentation/bloc/assistant_state.dart';

/// Drives the guided assistant conversation over a scripted step graph.
///
/// There is no model call here. Every reply is a token the script already
/// declares, so the transcript is reproducible: the same taps always produce
/// the same conversation.
class AssistantCubit extends Cubit<AssistantState> {
  final AssistantRepository repository;

  AssistantCubit({required this.repository}) : super(const AssistantLoading());

  AssistantScript? _script;
  ScriptStep? _step;
  int _nextBlockId = 0;

  Future<void> start() async {
    emit(const AssistantLoading());
    final result = await repository.script();
    result.fold(
      (failure) {
        log('assistant script failed', name: 'chatbot.cubit', error: failure);
        emit(AssistantFailed(failure.message));
      },
      (script) {
        _script = script;
        _reset();
      },
    );
  }

  void restart() {
    if (_script == null) return;
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

    final next = step?.nextFor(picked.first);
    if (next != null) _enter(next);
  }

  void act(NextStepAction action) {
    final current = state;
    if (current is! AssistantReady) return;

    if (action.restart) {
      restart();
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
      pendingRoute: action.route,
    ));
  }

  void openSuggestion(ServiceSuggestion suggestion) {
    final current = state;
    if (current is! AssistantReady) return;
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
