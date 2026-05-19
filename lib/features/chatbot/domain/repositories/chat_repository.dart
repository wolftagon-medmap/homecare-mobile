import 'package:m2health/features/chatbot/domain/entities/conversation.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';

typedef SendResult = ({Message userMessage, Message assistantMessage});

abstract class ChatRepository {
  Future<List<ConversationSummary>> listConversations({
    required String service,
    int page = 1,
  });

  Future<Conversation> getConversation(int conversationId);

  Future<Conversation> createConversation({
    required String service,
    required String message,
  });

  Future<SendResult> sendMessage({
    required int conversationId,
    required String message,
  });

  Future<void> deleteConversation(int conversationId);
}
