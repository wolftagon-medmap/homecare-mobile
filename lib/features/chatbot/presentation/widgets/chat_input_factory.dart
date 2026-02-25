import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';

class ChatInputFactory extends StatefulWidget {
  final InputConfiguration? config;
  final bool isProcessing;
  final Function(String) onSendText;
  final VoidCallback? onVoiceInput;
  // final Function(List<File>) onSendFiles;
  // final Function(String) onSendSelection;
  // final Function(String, bool) onSendConfirmation;

  const ChatInputFactory({
    super.key,
    this.config,
    required this.isProcessing,
    required this.onSendText,
    this.onVoiceInput,
    // required this.onSendFiles,
    // required this.onSendSelection,
    // required this.onSendConfirmation,
  });

  @override
  State<ChatInputFactory> createState() => _ChatInputFactoryState();
}

class _ChatInputFactoryState extends State<ChatInputFactory> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSendText(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // If AI is not waiting for anything, disable input
    if (widget.config == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Thinking...", style: TextStyle(color: Colors.grey)),
      );
    }

    if (widget.config!.inputType == InputType.dialogInput) {
      return Column(
        children: [
          if (widget.isProcessing) const LinearProgressIndicator(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 2, offset: Offset(0, -1))
              ],
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end, // Align to bottom as text grows
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Voice Input Button
                        IconButton(
                          icon: const Icon(Icons.mic_none_outlined,
                              color: Colors.grey),
                          onPressed: widget.onVoiceInput,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            // Multiline Support
                            maxLines: 7,
                            minLines: 1,
                            style: const TextStyle(fontSize: 13),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              hintText: "Write your message",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: CircleAvatar(
                    backgroundColor: Const.aqua,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _handleSend,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
