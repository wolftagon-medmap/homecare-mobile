import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';

class UserBubble extends StatelessWidget {
  final UserInputEvent event;
  const UserBubble({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 48, right: 16, bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Const.aqua,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          event.textInput,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
