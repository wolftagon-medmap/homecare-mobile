import 'package:flutter/material.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';

class AssistantBubble extends StatelessWidget {
  final ChatEvent event;
  const AssistantBubble({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    String content = "";
    if (event is OutputMessageEvent) {
      content = (event as OutputMessageEvent).content;
    }
    if (event is StreamMessageEvent) {
      content = (event as StreamMessageEvent).content;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 16, right: 8),
          //   child: CircleAvatar(
          //     backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          //     radius: 20,
          //     child: Image.asset(
          //       'assets/icons/ic_pharma_ai.png',
          //       fit: BoxFit.cover,
          //       width: 24,
          //       height: 24,
          //     ),
          //   ),
          // ),
          const Padding(padding: EdgeInsets.only(left: 20)),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: 48, bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Text(content),
            ),
          ),
        ],
      ),
    );
  }
}
