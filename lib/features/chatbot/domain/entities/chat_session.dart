import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';

class ChatSession {
  final String sessionId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<ChatEvent> events;
  final InputEvent? activeInputEvent;

  ChatSession({
    required this.sessionId,
    required this.createdAt,
    required this.expiresAt,
    this.events = const [],
    this.activeInputEvent,
  });

  // Check if waiting for user input
  bool get isWaitingForInput => activeInputEvent != null;
  // Check if session expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
