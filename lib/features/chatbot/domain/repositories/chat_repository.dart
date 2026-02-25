import 'dart:io';

import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_session.dart';

abstract class ChatRepository {
  /// Initialize new session or reconnect to existing one
  /// Returns stream of events from the workflow
  Stream<ChatEvent> invokeSession({
    String? existingSessionId,
    bool stream = true,
  });

  /// Send user input to active session
  /// Returns stream of response events
  Stream<ChatEvent> sendInput({
    required String nodeId,
    required String? messageId,
    required Map<String, dynamic> input,
  });

  /// Upload file and return remote URL
  Future<String> uploadFile(File file);

  /// Get active session history from backend
  /// Returns null if no active session
  Future<ChatSession?> getActiveSession();

  /// Close/stop active session
  Future<void> closeSession(String sessionId);
}
