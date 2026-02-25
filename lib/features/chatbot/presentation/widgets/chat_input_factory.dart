import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';

class ChatInputFactory extends StatefulWidget {
  final InputConfiguration? config;
  final bool isProcessing;
  final Function(String) onSendText;
  // final Function(List<File>) onSendFiles;
  // final Function(String) onSendSelection;
  // final Function(String, bool) onSendConfirmation;

  const ChatInputFactory({
    super.key,
    this.config,
    required this.isProcessing,
    required this.onSendText,
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
    if (widget.isProcessing) return const LinearProgressIndicator();

    // If AI is not waiting for anything, disable input
    if (widget.config == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Waiting for assistant...",
            style: TextStyle(color: Colors.grey)),
      );
    }

    switch (widget.config!.inputType) {
      case InputType.dialogInput:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildChatTextField(),
        );
      // case InputType.messageInlineOption:
      //   return _buildOptionSelector();
      case InputType.formInput:
      case InputType.messageInlineInput:
      // Rendered inline in the EventBubbleFactory instead
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildChatTextField() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: TextField(
        controller: _controller,
        onSubmitted: (_) => _handleSend(),
        decoration: InputDecoration(
          hintText: "Type your message...",
          suffixIcon: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Const.aqua,
              ),
              onPressed: _handleSend),
        ),
      ),
    );
  }
}
