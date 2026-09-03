import '../../domain/entities/chat_message.dart';
import 'estimate_revision_model.dart';
import 'time_proposal_model.dart';

/// Mirrors `MessageDTO` from the backend messaging module. Parsing is defensive
/// so one malformed message can never take down a whole conversation.
class ChatMessageModel {
  final int id;
  final int threadId;
  final String kind;
  final String? body;
  final int? authorUserId;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.threadId,
    required this.kind,
    required this.body,
    required this.authorUserId,
    required this.payload,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        threadId: (json['threadId'] as num?)?.toInt() ?? 0,
        kind: json['kind'] as String? ?? 'text',
        body: json['body'] as String?,
        authorUserId: (json['authorUserId'] as num?)?.toInt(),
        payload: json['payload'] is Map
            ? Map<String, dynamic>.from(json['payload'] as Map)
            : null,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'threadId': threadId,
        'kind': kind,
        'body': body,
        'authorUserId': authorUserId,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
      };

  ChatMessage toEntity() {
    final parsedKind = _kindFrom(kind);
    return ChatMessage(
      id: id,
      threadId: threadId,
      kind: parsedKind,
      body: body,
      authorUserId: authorUserId,
      createdAt: createdAt,
      timeProposal: parsedKind == MessageKind.timeProposal && payload != null
          ? TimeProposalModel.fromJson(payload!).toEntity()
          : null,
      estimateRevision:
          parsedKind == MessageKind.estimateRevision && payload != null
              ? EstimateRevisionModel.fromJson(payload!).toEntity()
              : null,
    );
  }

  // An unknown kind renders as a plain bubble rather than crashing: a server
  // that learns a new card type must not break an app that has not shipped yet.
  static MessageKind _kindFrom(String raw) => switch (raw) {
        'time_proposal' => MessageKind.timeProposal,
        'estimate_revision' => MessageKind.estimateRevision,
        'system' => MessageKind.system,
        _ => MessageKind.text,
      };
}

/// Mirrors `MessagePage`.
class ChatMessagePageModel {
  final List<ChatMessageModel> messages;
  final int? readUpToMessageId;

  const ChatMessagePageModel({
    this.messages = const [],
    this.readUpToMessageId,
  });

  factory ChatMessagePageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessagePageModel(
        messages: [
          for (final raw in (json['messages'] as List?) ?? const [])
            if (raw is Map<String, dynamic>) ChatMessageModel.fromJson(raw),
        ],
        readUpToMessageId: (json['readUpToMessageId'] as num?)?.toInt(),
      );

  ChatMessagePage toEntity() => ChatMessagePage(
        messages: messages.map((m) => m.toEntity()).toList(),
        readUpToMessageId: readUpToMessageId,
      );
}
