import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';
import 'package:m2health/service_locator.dart';

class ChatInputFactory extends StatefulWidget {
  final InputConfiguration? config;
  final bool isProcessing;
  final Function(String) onSendText;

  const ChatInputFactory({
    super.key,
    this.config,
    required this.isProcessing,
    required this.onSendText,
  });

  @override
  State<ChatInputFactory> createState() => _ChatInputFactoryState();
}

class _ChatInputFactoryState extends State<ChatInputFactory> {
  final TextEditingController _controller = TextEditingController();
  late final VoiceInputCubit _voiceInputCubit;

  @override
  void initState() {
    super.initState();
    _voiceInputCubit = sl<VoiceInputCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _voiceInputCubit.close();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSendText(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final doesAcceptDialogInput =
        widget.config?.inputType == InputType.dialogInput;

    return BlocProvider.value(
      value: _voiceInputCubit,
      child: BlocListener<VoiceInputCubit, VoiceInputState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (text) {
              _controller.text = text;
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
        child: BlocBuilder<VoiceInputCubit, VoiceInputState>(
          builder: (context, voiceState) {
            final isRecording = voiceState.maybeWhen(
              recording: () => true,
              orElse: () => false,
            );
            final isTranscribing = voiceState.maybeWhen(
              transcribing: () => true,
              orElse: () => false,
            );

            return Column(
              children: [
                if (widget.isProcessing || isTranscribing)
                  const LinearProgressIndicator(color: Const.aqua),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, -1),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isRecording
                                ? Colors.red.withValues(alpha: 0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Voice Input Button
                              IconButton(
                                icon: Icon(
                                  isRecording
                                      ? Icons.stop_circle_rounded
                                      : Icons.mic_none_outlined,
                                  color: isRecording ? Colors.red : Colors.grey,
                                ),
                                onPressed: widget.isProcessing || isTranscribing
                                    ? null
                                    : () => _voiceInputCubit.toggleRecording(),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  maxLines: 7,
                                  minLines: 1,
                                  enabled: doesAcceptDialogInput &&
                                      !widget.isProcessing &&
                                      !isTranscribing &&
                                      !isRecording,
                                  style: const TextStyle(fontSize: 13),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  decoration: InputDecoration(
                                    hintText: isRecording
                                        ? "Recording..."
                                        : isTranscribing
                                            ? "Transcribing..."
                                            : "Write your message",
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 4,
                                    ),
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
                          backgroundColor: doesAcceptDialogInput &&
                                  !isRecording &&
                                  !isTranscribing
                              ? Const.aqua
                              : Colors.grey,
                          child: IconButton(
                            icon: const Icon(Icons.send_rounded,
                                color: Colors.white),
                            onPressed: doesAcceptDialogInput &&
                                    !isRecording &&
                                    !isTranscribing
                                ? _handleSend
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
