import 'package:m2health/features/chatbot/data/models/chat_event_model.dart';

class ChatSessionModel {
  final String sessionId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<ChatEventModel> events;

  ChatSessionModel({
    required this.sessionId,
    required this.createdAt,
    required this.expiresAt,
    this.events = const [],
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    final data = json['session'];
    return ChatSessionModel(
      sessionId: data['session_id'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      expiresAt: DateTime.parse(data['expires_at'] as String),
      events: (data['events'] as List<dynamic>?)
              ?.map((e) => ChatEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
