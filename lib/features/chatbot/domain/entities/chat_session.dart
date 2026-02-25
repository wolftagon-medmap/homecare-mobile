import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';

class ChatSession {
  final String sessionId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<ChatEvent> events;
  final InputConfiguration? pendingInput;

  ChatSession({
    required this.sessionId,
    required this.createdAt,
    required this.expiresAt,
    this.events = const [],
    this.pendingInput,
  });

  // Check if waiting for user input
  bool get isWaitingForInput => pendingInput != null;

  // Check if session expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
