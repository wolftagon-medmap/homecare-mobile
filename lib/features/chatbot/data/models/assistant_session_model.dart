import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';

class AssistantSessionModel {
  const AssistantSessionModel._();

  static AssistantSession fromJson(Map<String, dynamic> json) {
    final rawTurns = (json['turns'] as List?) ?? const [];
    final startedAt = _date(json['started_at']) ?? DateTime.now();
    return AssistantSession(
      id: json['id'] as String? ?? '',
      scriptId: json['script_id'] as String? ?? '',
      startedAt: startedAt,
      updatedAt: _date(json['updated_at']) ?? startedAt,
      preview: json['preview'] as String?,
      turns: rawTurns
          .map((turn) => _turnFromJson(turn as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  static Map<String, dynamic> toJson(AssistantSession session) => {
        'id': session.id,
        'script_id': session.scriptId,
        'started_at': session.startedAt.toIso8601String(),
        'updated_at': session.updatedAt.toIso8601String(),
        'preview': session.preview,
        'turns': session.turns.map(_turnToJson).toList(growable: false),
      };

  static AssistantTurn _turnFromJson(Map<String, dynamic> json) {
    final rawReplies = (json['reply_ids'] as List?) ?? const [];
    return AssistantTurn(
      kind: _kind(json['kind'] as String?),
      replyIds: rawReplies.map((id) => id as String).toList(growable: false),
      text: json['text'] as String?,
    );
  }

  static Map<String, dynamic> _turnToJson(AssistantTurn turn) => {
        'kind': turn.kind.name,
        'reply_ids': turn.replyIds,
        'text': turn.text,
      };

  static AssistantTurnKind _kind(String? raw) {
    for (final kind in AssistantTurnKind.values) {
      if (kind.name == raw) return kind;
    }
    return AssistantTurnKind.text;
  }

  static DateTime? _date(Object? raw) =>
      raw is String ? DateTime.tryParse(raw) : null;
}
