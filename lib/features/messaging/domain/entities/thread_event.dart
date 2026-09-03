import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThreadEvent extends Equatable {
  final int threadId;
  final int? messageId;

  const ThreadEvent({required this.threadId, this.messageId});

  static ThreadEvent? parseFrame(String raw) {
    Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;
    if (decoded['type'] != 'activity') return null;

    final threadId = (decoded['threadId'] as num?)?.toInt();
    if (threadId == null || threadId <= 0) return null;

    return ThreadEvent(
      threadId: threadId,
      messageId: (decoded['messageId'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [threadId, messageId];
}
