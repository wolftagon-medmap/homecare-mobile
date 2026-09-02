import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/core/widgets/voice_input/voice_recording_view.dart';
import 'package:m2health/service_locator.dart';

/// Bottom chat input bar: free text + voice dictation. Disabled while a
/// message is in flight (the AI turn is synchronous and can take 20-40s).
class ChatInput extends StatefulWidget {
  final bool isSending;
  final Function(String) onSend;

  const ChatInput({
    super.key,
    required this.isSending,
    required this.onSend,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
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
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isSending) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            permissionPermanentlyDenied: () {
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Microphone Access Required'),
                  content: const Text(
                    'Microphone permission has been denied. '
                    'Please enable it in your device Settings to use voice input.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        openAppSettings();
                      },
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: BlocBuilder<VoiceInputCubit, VoiceInputState>(
          builder: (context, voiceState) {
            final isRecording = voiceState.maybeWhen(
              recording: (_) => true,
              orElse: () => false,
            );
            final isPaused = voiceState.maybeWhen(
              paused: (_) => true,
              orElse: () => false,
            );
            final isTranscribing = voiceState.maybeWhen(
              transcribing: () => true,
              orElse: () => false,
            );

            final showVoiceUI = isRecording || isPaused;

            return Column(
              children: [
                if (widget.isSending || isTranscribing)
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
                  child: showVoiceUI
                      ? VoiceRecordingView(cubit: _voiceInputCubit)
                      : _buildStandardInputUI(isTranscribing),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStandardInputUI(bool isTranscribing) {
    final inputEnabled = !widget.isSending && !isTranscribing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
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
                IconButton(
                  icon: const Icon(Icons.mic_none_outlined, color: Colors.grey),
                  onPressed: inputEnabled
                      ? () => _voiceInputCubit.startRecording()
                      : null,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 7,
                    minLines: 1,
                    enabled: inputEnabled,
                    style: const TextStyle(fontSize: 13),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: isTranscribing
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
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: CircleAvatar(
            backgroundColor: inputEnabled ? Const.aqua : Colors.grey,
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: inputEnabled ? _handleSend : null,
            ),
          ),
        ),
      ],
    );
  }
}
