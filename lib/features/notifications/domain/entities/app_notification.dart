import 'package:equatable/equatable.dart';

/// An in-app notification (backend GET /v2/notifications).
class AppNotification extends Equatable {
  final int id;
  final String? type; // e.g. 'booking.confirmed', 'appointment.accepted'
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;
  final int? appointmentId;
  final int? careTaskId;
  final int? threadId;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.appointmentId,
    required this.careTaskId,
    this.threadId,
  });

  AppNotification asRead() => AppNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        isRead: true,
        createdAt: createdAt,
        appointmentId: appointmentId,
        careTaskId: careTaskId,
        threadId: threadId,
      );

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AppNotification(
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String?,
      title: json['title'] as String? ?? 'Notification',
      body: json['body'] as String? ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] is String
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      appointmentId: (json['appointment_id'] as num?)?.toInt(),
      careTaskId: data is Map<String, dynamic>
          ? (data['care_task_id'] as num?)?.toInt()
          : null,
      threadId: data is Map<String, dynamic>
          ? (data['threadId'] as num?)?.toInt()
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        body,
        isRead,
        createdAt,
        appointmentId,
        careTaskId,
        threadId
      ];
}
