import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'copy_helper.dart';

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

    return GestureDetector(
      onLongPress: () => copyToClipboard(context, content),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarkdownBody(
                      data: content,
                      selectable:
                          true, // Allows user to select text for copying
                      styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        h2: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        h3: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        h4: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        h5: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        p: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                        ),
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                        listBullet: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                        horizontalRuleDecoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      onTapLink: (text, href, title) {
                        // Handle links if the AI provides source_url
                      },
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () => copyToClipboard(context, content),
                        child: const Icon(Icons.copy_rounded,
                            size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
