import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubble.dart';
import 'package:m2health/features/chatbot/presentation/widgets/user_bubble.dart';

/// Renders a single chat message as the appropriate bubble.
class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message.isUser
        ? UserBubble(message: message)
        : AssistantBubble(message: message);
  }
}
