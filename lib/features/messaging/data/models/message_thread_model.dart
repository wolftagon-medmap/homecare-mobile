import '../../domain/entities/message_thread.dart';
import 'chat_message_model.dart';

/// Mirrors `ThreadSummary`.
class MessageThreadModel {
  final int id;
  final int careTaskId;
  final int? appointmentId;
  final String status;
  final String serviceLabel;
  final Map<String, dynamic>? counterpart;
  final Map<String, dynamic>? lastMessage;
  final int unread;
  final String? lastMessageAt;
  final Map<String, dynamic>? context;

  const MessageThreadModel({
    required this.id,
    required this.careTaskId,
    required this.appointmentId,
    required this.status,
    required this.serviceLabel,
    required this.counterpart,
    required this.lastMessage,
    required this.unread,
    required this.lastMessageAt,
    this.context,
  });

  factory MessageThreadModel.fromJson(Map<String, dynamic> json) =>
      MessageThreadModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        careTaskId: (json['careTaskId'] as num?)?.toInt() ?? 0,
        appointmentId: (json['appointmentId'] as num?)?.toInt(),
        status: json['status'] as String? ?? 'open',
        serviceLabel: json['serviceLabel'] as String? ?? '',
        counterpart: json['counterpart'] is Map
            ? Map<String, dynamic>.from(json['counterpart'] as Map)
            : null,
        lastMessage: json['lastMessage'] is Map
            ? Map<String, dynamic>.from(json['lastMessage'] as Map)
            : null,
        unread: (json['unread'] as num?)?.toInt() ?? 0,
        lastMessageAt: json['lastMessageAt'] as String?,
        context: json['context'] is Map
            ? Map<String, dynamic>.from(json['context'] as Map)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'careTaskId': careTaskId,
        'appointmentId': appointmentId,
        'status': status,
        'serviceLabel': serviceLabel,
        'counterpart': counterpart,
        'lastMessage': lastMessage,
        'unread': unread,
        'lastMessageAt': lastMessageAt,
        'context': context,
      };

  MessageThread toEntity() => MessageThread(
        id: id,
        careTaskId: careTaskId,
        appointmentId: appointmentId,
        status: status == 'closed' ? ThreadStatus.closed : ThreadStatus.open,
        serviceLabel: serviceLabel,
        counterpart:
            counterpart == null ? null : _counterpartFrom(counterpart!),
        lastMessage: lastMessage == null ? null : _previewFrom(lastMessage!),
        unread: unread,
        lastMessageAt: DateTime.tryParse(lastMessageAt ?? ''),
        context: _contextFrom(context),
      );

  static ThreadContext _contextFrom(Map<String, dynamic>? json) {
    if (json == null) return const ThreadContext();
    return ThreadContext(
      issueLabels: [
        for (final label in (json['issueLabels'] as List?) ?? const [])
          label.toString(),
      ],
      location: json['location'] as String?,
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
    );
  }

  static ThreadCounterpart _counterpartFrom(Map<String, dynamic> json) =>
      ThreadCounterpart(
        userId: (json['userId'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? 'M2Health',
        avatar: json['avatar'] as String?,
        role: switch (json['role'] as String?) {
          'patient' => ParticipantRole.patient,
          'admin' => ParticipantRole.admin,
          _ => ParticipantRole.professional,
        },
      );

  static MessagePreview _previewFrom(Map<String, dynamic> json) =>
      MessagePreview(
        kind: ChatMessageModel.fromJson({...json, 'id': 0, 'threadId': 0})
            .toEntity()
            .kind,
        body: json['body'] as String?,
        authorUserId: (json['authorUserId'] as num?)?.toInt(),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}
