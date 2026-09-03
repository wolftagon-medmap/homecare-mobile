import 'package:equatable/equatable.dart';

import 'estimate_revision.dart';
import 'time_proposal.dart';

/// What a message carries. The two structured kinds render as action cards and
/// are written from the real records — the chat is the surface, never the
/// source of truth.
enum MessageKind { text, timeProposal, estimateRevision, system }

class ChatMessage extends Equatable {
  final int id;
  final int threadId;
  final MessageKind kind;
  final String? body;

  /// Null on a system line.
  final int? authorUserId;
  final TimeProposal? timeProposal;
  final EstimateRevision? estimateRevision;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.kind,
    required this.body,
    required this.authorUserId,
    required this.createdAt,
    this.timeProposal,
    this.estimateRevision,
  });

  bool get isSystem => kind == MessageKind.system;

  /// Mine if a person wrote it and that person is not the other side.
  ///
  /// Framed against the counterpart rather than the viewer on purpose: a thread
  /// has exactly two voices, so knowing who the *other* one is settles it —
  /// no auth lookup, and nothing to get wrong when the same screen is opened
  /// by a patient and by a professional.
  bool isMine(int? counterpartUserId) =>
      authorUserId != null && authorUserId != counterpartUserId;

  ChatMessage copyWith({
    TimeProposal? timeProposal,
    EstimateRevision? estimateRevision,
  }) =>
      ChatMessage(
        id: id,
        threadId: threadId,
        kind: kind,
        body: body,
        authorUserId: authorUserId,
        createdAt: createdAt,
        timeProposal: timeProposal ?? this.timeProposal,
        estimateRevision: estimateRevision ?? this.estimateRevision,
      );

  @override
  List<Object?> get props => [
        id,
        threadId,
        kind,
        body,
        authorUserId,
        createdAt,
        timeProposal,
        estimateRevision
      ];
}

/// A thread's messages plus how far the other side has read.
///
/// A cursor, not per-message state: everything up to and including
/// [readUpToMessageId] has been seen, which is why the screen marks one message
/// rather than ticking every bubble.
class ChatMessagePage extends Equatable {
  final List<ChatMessage> messages;
  final int? readUpToMessageId;

  const ChatMessagePage({this.messages = const [], this.readUpToMessageId});

  @override
  List<Object?> get props => [messages, readUpToMessageId];
}
