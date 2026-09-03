import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_cubit.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/core/widgets/voice_input/voice_recording_view.dart';
import 'package:m2health/features/chatbot/presentation/widgets/assistant_theme.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class AssistantComposer extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onSend;
  final bool enabled;
  final String? notice;

  const AssistantComposer({
    super.key,
    required this.hint,
    required this.onSend,
    this.enabled = true,
    this.notice,
  });

  @override
  State<AssistantComposer> createState() => _AssistantComposerState();
}

class _AssistantComposerState extends State<AssistantComposer> {
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

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          color: AssistantPalette.canvas,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Text(
            widget.notice ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AssistantPalette.muted,
              fontSize: 13,
            ),
          ),
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
                behavior: SnackBarBehavior.floating,
              ),
            ),
            permissionPermanentlyDenied: () => _showMicSettingsDialog(context),
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

            return SafeArea(
              top: false,
              child: Container(
                color: AssistantPalette.canvas,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isTranscribing)
                      const LinearProgressIndicator(
                        color: AssistantPalette.primary,
                      ),
                    isRecording || isPaused
                        ? VoiceRecordingView(cubit: _voiceCubit)
                        : _input(isTranscribing),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _input(bool isTranscribing) {
    final t = context.t.chatbot;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AssistantPalette.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AssistantPalette.border),
            ),
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.mic_none_outlined,
                    color: AssistantPalette.muted,
                  ),
                  tooltip: t.voiceInput,
                  onPressed: isTranscribing
                      ? null
                      : () => _voiceCubit.startRecording(),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    enabled: !isTranscribing,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    style: const TextStyle(
                      color: AssistantPalette.navy,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      hintText: isTranscribing ? t.transcribing : widget.hint,
                      hintStyle: const TextStyle(
                        color: AssistantPalette.muted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Semantics(
          button: true,
          label: t.send,
          child: Material(
            color: isTranscribing
                ? AssistantPalette.muted
                : AssistantPalette.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: isTranscribing ? null : _send,
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showMicSettingsDialog(BuildContext context) {
    final t = context.t.chatbot;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.micDeniedTitle),
        content: Text(t.micDeniedBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            child: Text(t.openSettings),
          ),
        ],
      ),
    );
  }
}
