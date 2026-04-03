import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/services/ai_tools_service.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';
import 'package:m2health/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

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
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isTranscribing = false;

  @override
  void dispose() {
    _controller.dispose();
    _recorder.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSendText(_controller.text.trim());
      _controller.clear();
    }
  }

  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        final path = await _recorder.stop();
        setState(() {
          _isRecording = false;
        });

        if (path != null) {
          _transcribeAudio(File(path));
        }
      } else {
        // Check microphone permission
        final status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Microphone permission denied'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        // Start recording
        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/audio_input_${DateTime.now().millisecondsSinceEpoch}.wav';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000,
            bitRate: 128000,
          ),
          path: path,
        );

        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      log('Error toggling recording: $e', name: 'ChatInputFactory');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _transcribeAudio(File file) async {
    setState(() {
      _isTranscribing = true;
    });

    try {
      final aiToolsService = sl<AIToolsService>();
      final text = await aiToolsService.transcribeAudio(file);

      if (mounted) {
        if (text != null && text.isNotEmpty) {
          _controller.text = text;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to transcribe audio. Please try again later.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTranscribing = false;
        });
      }
      // Delete temporary audio file
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doesAcceptDialogInput =
        widget.config?.inputType == InputType.dialogInput;

    return Column(
      children: [
        if (widget.isProcessing || _isTranscribing)
          const LinearProgressIndicator(color: Const.aqua),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    color: _isRecording ? Colors.red.withValues(alpha: 0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Voice Input Button
                      IconButton(
                        icon: Icon(
                          _isRecording ? Icons.stop_circle_rounded : Icons.mic_none_outlined,
                          color: _isRecording ? Colors.red : Colors.grey,
                        ),
                        onPressed: widget.isProcessing || _isTranscribing ? null : _toggleRecording,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: 7,
                          minLines: 1,
                          enabled: doesAcceptDialogInput &&
                              !widget.isProcessing &&
                              !_isTranscribing &&
                              !_isRecording,
                          style: const TextStyle(fontSize: 13),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: _isRecording
                                ? "Recording..."
                                : _isTranscribing
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
                          !_isRecording &&
                          !_isTranscribing
                      ? Const.aqua
                      : Colors.grey,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: doesAcceptDialogInput &&
                            !_isRecording &&
                            !_isTranscribing
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
  }
}
