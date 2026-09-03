import 'package:equatable/equatable.dart';

enum AssistantTurnKind { choose, submit, text, act }

/// One recorded interaction. A conversation is stored as the tokens the patient
/// produced, never as rendered blocks: replaying the tokens through the same
/// script reproduces the transcript exactly, and nothing about the block set
/// has to survive in storage.
class AssistantTurn extends Equatable {
  final AssistantTurnKind kind;
  final List<String> replyIds;
  final String? text;

  const AssistantTurn({
    required this.kind,
    this.replyIds = const [],
    this.text,
  });

  @override
  List<Object?> get props => [kind, replyIds, text];
}

class AssistantSession extends Equatable {
  final String id;
  final String scriptId;
  final DateTime startedAt;
  final DateTime updatedAt;
  final String? preview;
  final List<AssistantTurn> turns;

  const AssistantSession({
    required this.id,
    required this.scriptId,
    required this.startedAt,
    required this.updatedAt,
    required this.preview,
    required this.turns,
  });

  bool get isEmpty => turns.isEmpty;

  AssistantSession copyWith({
    DateTime? updatedAt,
    String? preview,
    List<AssistantTurn>? turns,
  }) {
    return AssistantSession(
      id: id,
      scriptId: scriptId,
      startedAt: startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preview: preview ?? this.preview,
      turns: turns ?? this.turns,
    );
  }

  @override
  List<Object?> get props =>
      [id, scriptId, startedAt, updatedAt, preview, turns];
}
