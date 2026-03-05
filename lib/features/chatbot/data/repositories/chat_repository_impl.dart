import 'dart:developer';
import 'dart:io';

import 'package:m2health/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_session.dart';
import 'package:m2health/features/chatbot/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Stream<ChatEvent> invokeSession({
    required String service,
    String? existingSessionId,
    bool stream = true,
  }) async* {
    await for (final eventModel in _remoteDataSource.invokeSession(
      service: service,
      stream: stream,
    )) {
      final event = eventModel.toEntity();
      yield event;
    }
  }

  @override
  Stream<ChatEvent> sendInput({
    required String service,
    required String nodeId,
    required String? messageId,
    required Map<String, dynamic> input,
  }) async* {
    await for (final eventModel in _remoteDataSource.sendInput(
      service: service,
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
  Future<ChatSession?> getActiveSession({
    required String service,
  }) async {
    try {
      final session =
          await _remoteDataSource.getSessionHistory(service: service);
      final events = session.events.map((e) => e.toEntity()).toList();

      // Find last input event for pending input
      InputEvent? activeInputEvent;
      for (final event in events.reversed) {
        if (event is InputEvent) {
          activeInputEvent = event;
          break;
        }
      }

      log('Active session found with ${events.length} events. Pending input type: ${activeInputEvent != null ? activeInputEvent.inputConfig.inputType : 'none'}',
          name: 'ChatRepositoryImpl');

      return ChatSession(
        sessionId: session.sessionId,
        createdAt: session.createdAt,
        expiresAt: session.expiresAt,
        events: events,
        activeInputEvent: activeInputEvent,
      );
    } catch (e) {
      log('No active session found or failed to fetch session history: $e',
          name: 'ChatRepositoryImpl');
      return null;
    }
  }

  @override
  Future<void> closeSession({required String service}) async {
    await _remoteDataSource.closeSession(service: service);
  }
}
