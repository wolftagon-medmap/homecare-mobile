import 'package:m2health/features/chatbot/domain/entities/conversation.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';

class ChatbotModels {
  static Message messageFromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int?,
      role: json['role'] == 'assistant'
          ? MessageRole.assistant
          : MessageRole.user,
      content: (json['content'] as String?) ?? '',
    );
  }

  static Conversation conversationFromJson(
    Map<String, dynamic> json, {
    List<Message> messages = const [],
  }) {
    final rawMessages = json['messages'] as List<dynamic>?;
    return Conversation(
      id: json['id'] as int,
      service: (json['service'] as String?) ?? 'general',
      title: json['title'] as String?,
      lastMessageAt: _parseDate(json['lastMessageAt']),
      messages: rawMessages != null
          ? rawMessages
              .map((e) => messageFromJson(e as Map<String, dynamic>))
              .toList()
          : messages,
    );
  }

  static ConversationSummary summaryFromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      id: json['id'] as int,
      service: (json['service'] as String?) ?? 'general',
      title: json['title'] as String?,
      lastMessageAt: _parseDate(json['lastMessageAt']),
      preview: json['preview'] as String?,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
