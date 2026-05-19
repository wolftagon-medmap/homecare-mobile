import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';

class UserBubble extends StatelessWidget {
  final Message message;
  const UserBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 48, right: 16, bottom: 8),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Const.aqua,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SelectableText(
          message.content,
          selectionColor: Colors.white30,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
