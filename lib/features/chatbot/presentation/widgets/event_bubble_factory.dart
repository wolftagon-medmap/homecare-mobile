// chatbot/presentation/widgets/event_bubble_factory.dart
import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_bubble.dart';
import 'package:m2health/features/chatbot/presentation/widgets/user_bubble.dart';

class EventBubbleFactory extends StatelessWidget {
  final ChatEvent event;
  final bool isActive;

  const EventBubbleFactory(
      {super.key, required this.event, required this.isActive});

  @override
  Widget build(BuildContext context) {
    switch (event.type) {
      case EventType.userInput:
        return UserBubble(event: event as UserInputEvent);

      case EventType.outputMsg:
      case EventType.streamMsg:
        // Combined handler for standard and streaming text
        return AssistantBubble(event: event);

      case EventType.input:
        final inputEvent = event as InputEvent;
        // Skip rendering dialog prompts in the list
        if (inputEvent.inputConfig.inputType == InputType.dialogInput) {
          return const SizedBox.shrink();
        }
        return const SizedBox.shrink();
        // return InlineFormWidget(event: inputEvent, isEnabled: isActive);

      default:
        return const SizedBox.shrink();
    }
  }
}
