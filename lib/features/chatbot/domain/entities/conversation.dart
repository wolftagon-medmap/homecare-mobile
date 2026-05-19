import 'package:equatable/equatable.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';

/// A full conversation with its ordered message history.
class Conversation extends Equatable {
  final int id;
  final String service;
  final String? title;
  final DateTime? lastMessageAt;
  final List<Message> messages;

  const Conversation({
    required this.id,
    required this.service,
    this.title,
    this.lastMessageAt,
    this.messages = const [],
  });

  @override
  List<Object?> get props => [id, service, title, lastMessageAt, messages];
}

/// Lightweight conversation entry used by the conversation list screen.
class ConversationSummary extends Equatable {
  final int id;
  final String service;
  final String? title;
  final DateTime? lastMessageAt;
  final String? preview;

  const ConversationSummary({
    required this.id,
    required this.service,
    this.title,
    this.lastMessageAt,
    this.preview,
  });

  @override
  List<Object?> get props => [id, service, title, lastMessageAt, preview];
}
