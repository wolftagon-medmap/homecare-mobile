import 'dart:convert';

import 'package:m2health/features/chatbot/data/models/assistant_session_model.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Conversation history, on this device only. The transcript of a symptom
/// conversation is health data, so it is never sent anywhere: there is no
/// server session store for the assistant and this store is not a seam for one.
class AssistantSessionStore {
  static const String _key = 'assistant_sessions_v1';
  static const int _limit = 20;

  AssistantSessionStore();

  /// Every write is a read-modify-write, and the conversation saves itself on
  /// each turn. Without this queue two overlapping saves both read the same
  /// snapshot and the slower one puts the older transcript back.
  Future<void> _queue = Future<void>.value();

  Future<void> get settled => _queue;

  Future<List<AssistantSession>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final sessions = decoded
          .whereType<Map<String, dynamic>>()
          .map(AssistantSessionModel.fromJson)
          .where((session) => session.id.isNotEmpty)
          .toList();
      sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return sessions;
    } on FormatException {
      await prefs.remove(_key);
      return const [];
    }
  }

  Future<void> save(AssistantSession session) {
    if (session.isEmpty) return _queue;
    return _enqueue(() async {
      final sessions = List<AssistantSession>.of(await list())
        ..removeWhere((existing) => existing.id == session.id);
      sessions
        ..insert(0, session)
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      await _write(
        sessions.length > _limit ? sessions.sublist(0, _limit) : sessions,
      );
    });
  }

  Future<void> delete(String id) {
    return _enqueue(() async {
      final sessions = List<AssistantSession>.of(await list())
        ..removeWhere((session) => session.id == id);
      await _write(sessions);
    });
  }

  Future<void> _enqueue(Future<void> Function() write) {
    final next = _queue.then((_) => write());
    _queue = next.catchError((Object _) {});
    return next;
  }

  Future<void> _write(List<AssistantSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(sessions.map(AssistantSessionModel.toJson).toList()),
    );
  }
}
