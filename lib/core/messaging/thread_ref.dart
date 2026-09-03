import 'package:equatable/equatable.dart';

/// How a screen names the conversation it wants without knowing its id.
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

/// The little a message entry point needs to know about a conversation: whether
/// there is one, where it is, and whether anything in it is unread.
///
/// Deliberately not the messaging feature's own `MessageThread`. Keeping this
/// small is what lets `features/appointment` offer a conversation without
/// depending on `features/messaging` at all.
class ThreadEntry extends Equatable {
  final int threadId;
  final int? appointmentId;
  final int? careTaskId;
  final int unread;
  final String counterpartName;
  final bool isOpen;

  const ThreadEntry({
    required this.threadId,
    required this.appointmentId,
    required this.careTaskId,
    required this.unread,
    required this.counterpartName,
    required this.isOpen,
  });

  bool matches(ThreadRef ref) {
    if (!isOpen) return false;
    if (ref.appointmentId != null) return appointmentId == ref.appointmentId;
    if (ref.careTaskId != null) return careTaskId == ref.careTaskId;
    return false;
  }

  @override
  List<Object?> get props =>
      [threadId, appointmentId, careTaskId, unread, counterpartName, isOpen];
}
