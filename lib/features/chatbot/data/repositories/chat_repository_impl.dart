import 'dart:developer';
import 'dart:io';

import 'package:m2health/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_session.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Stream<ChatEvent> invokeSession({
    String? existingSessionId,
    bool stream = true,
  }) async* {
    await for (final eventModel in _remoteDataSource.invokeSession(
      stream: stream,
    )) {
      final event = eventModel.toEntity();
      yield event;
    }
  }

  @override
  Stream<ChatEvent> sendInput({
    required String nodeId,
    required String? messageId,
    required Map<String, dynamic> input,
  }) async* {
    await for (final eventModel in _remoteDataSource.sendInput(
      nodeId: nodeId,
      messageId: messageId,
      input: input,
    )) {
      final event = eventModel.toEntity();
      yield event;
    }
  }

  @override
  Future<String> uploadFile(File file) async {
    return await _remoteDataSource.uploadFile(file);
  }

  @override
  Future<ChatSession?> getActiveSession() async {
    try {
      final session = await _remoteDataSource.getSessionHistory();
      final events = session.events.map((e) => e.toEntity()).toList();

      // Find last input event for pending input
      InputConfiguration? pendingInput;
      for (final event in events.reversed) {
        if (event is InputEvent) {
          pendingInput = event.inputConfig;
          break;
        }
      }

      log('Active session found with ${events.length} events. Pending input type: ${pendingInput != null ? pendingInput.inputType : 'none'}',
          name: 'ChatRepositoryImpl');

      return ChatSession(
        sessionId: session.sessionId,
        createdAt: session.createdAt,
        expiresAt: session.expiresAt,
        events: events,
        pendingInput: pendingInput,
      );
    } catch (e) {
      log('No active session found or failed to fetch session history: $e',
          name: 'ChatRepositoryImpl');
      return null;
    }
  }

  @override
  Future<void> closeSession(String sessionId) async {
    await _remoteDataSource.closeSession(sessionId);
  }
}
