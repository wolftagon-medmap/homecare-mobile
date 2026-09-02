import 'package:equatable/equatable.dart';

import 'chat_message.dart';

enum ThreadStatus { open, closed }

enum ParticipantRole { patient, professional, admin }

class ThreadCounterpart extends Equatable {
  final int userId;
  final String name;
  final String? avatar;
  final ParticipantRole role;

  const ThreadCounterpart({
    required this.userId,
    required this.name,
    required this.avatar,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, name, avatar, role];
}

class MessagePreview extends Equatable {
  final MessageKind kind;
  final String? body;
  final int? authorUserId;
  final DateTime createdAt;

  const MessagePreview({
    required this.kind,
    required this.body,
    required this.authorUserId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [kind, body, authorUserId, createdAt];
}

/// One conversation, as it appears in the thread list. [unread] is per-viewer,
/// not a property of the thread.
class MessageThread extends Equatable {
  final int id;
  final int careTaskId;
  final int? appointmentId;
  final ThreadStatus status;
  final String serviceLabel;
  final ThreadCounterpart? counterpart;
  final MessagePreview? lastMessage;
  final int unread;
  final DateTime? lastMessageAt;

  const MessageThread({
    required this.id,
    required this.careTaskId,
    required this.appointmentId,
    required this.status,
    required this.serviceLabel,
    required this.counterpart,
    required this.lastMessage,
    required this.unread,
    required this.lastMessageAt,
  });

  bool get isOpen => status == ThreadStatus.open;

  @override
  List<Object?> get props => [
        id,
        careTaskId,
        appointmentId,
        status,
        serviceLabel,
        counterpart,
        lastMessage,
        unread,
        lastMessageAt,
      ];
}

/// How a screen names the thread it wants without knowing its id.
///
/// An appointment card knows its appointment; a care-task card knows its task.
/// Neither should have to carry a thread id, and no v1 payload had to grow one
/// to make this work — [ThreadIndexCubit] resolves the ref against the list it
/// already loaded.
class ThreadRef extends Equatable {
  final int? appointmentId;
  final int? careTaskId;

  const ThreadRef._({this.appointmentId, this.careTaskId});

  const ThreadRef.forAppointment(int id) : this._(appointmentId: id);

  const ThreadRef.forCareTask(int id) : this._(careTaskId: id);

  @override
  List<Object?> get props => [appointmentId, careTaskId];
}
