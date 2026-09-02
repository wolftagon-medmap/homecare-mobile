import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/core/widgets/voice_input/voice_recording_view.dart';
import 'package:m2health/features/intake_booking/domain/entities/composer_state.dart';
import 'package:m2health/service_locator.dart';

/// The input bar. Its behaviour is dictated entirely by [ComposerState] from the
/// backend — when disabled it shows a notice instead of a text field. Supports
/// voice dictation (record → transcribe → fills the field).
class ComposerBar extends StatefulWidget {
  final ComposerState composer;
  final bool isSending;
  final ValueChanged<String> onSend;

  const ComposerBar({
    super.key,
    required this.composer,
    required this.isSending,
    required this.onSend,
  });

  @override
  State<ComposerBar> createState() => _ComposerBarState();
}

class _ComposerBarState extends State<ComposerBar> {
  final TextEditingController _controller = TextEditingController();
  late final VoiceInputCubit _voiceCubit;

  @override
  void initState() {
    super.initState();
    _voiceCubit = sl<VoiceInputCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _voiceCubit.close();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.composer.enabled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        color: Colors.white,
        child: Text(
          widget.composer.notice ?? 'This conversation is closed.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF8A96BC), fontSize: 13),
        ),
      );
    }

    return BlocProvider.value(
      value: _voiceCubit,
      child: BlocListener<VoiceInputCubit, VoiceInputState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (text) => _controller.text = text,
            error: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating),
            ),
            permissionPermanentlyDenied: () => _showMicSettingsDialog(context),
          );
        },
        child: BlocBuilder<VoiceInputCubit, VoiceInputState>(
          builder: (context, voiceState) {
            final isRecording =
                voiceState.maybeWhen(recording: (_) => true, orElse: () => false);
            final isPaused =
                voiceState.maybeWhen(paused: (_) => true, orElse: () => false);
            final isTranscribing = voiceState.maybeWhen(
                transcribing: () => true, orElse: () => false);
            final showVoiceUI = isRecording || isPaused;

            return Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isTranscribing)
                    const LinearProgressIndicator(color: Const.aqua),
                  showVoiceUI
                      ? VoiceRecordingView(cubit: _voiceCubit)
                      : _standardInput(isTranscribing),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _standardInput(bool isTranscribing) {
    final enabled = !widget.isSending && !isTranscribing;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 4,
            enabled: enabled,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: isTranscribing
                  ? 'Transcribing…'
                  : (widget.composer.placeholder ?? 'Type your message…'),
              hintStyle: const TextStyle(color: Color(0xFF8A96BC), fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF1F3F8),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              prefixIcon: IconButton(
                icon: const Icon(Icons.mic_none_outlined,
                    color: Color(0xFF8A96BC)),
                onPressed: enabled ? () => _voiceCubit.startRecording() : null,
                tooltip: 'Voice input',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: enabled ? Const.aqua : Colors.grey,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: enabled ? _submit : null,
            child: SizedBox(
              width: 44,
              height: 44,
              child: widget.isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  void _showMicSettingsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Microphone Access Required'),
        content: const Text(
          'Microphone permission has been denied. Please enable it in your '
          'device Settings to use voice input.',
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
  }
}
