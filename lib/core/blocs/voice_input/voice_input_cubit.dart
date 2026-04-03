import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/core/services/ai_tools_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceInputCubit extends Cubit<VoiceInputState> {
  final AIToolsService _aiToolsService;
  final AudioRecorder _recorder = AudioRecorder();

  VoiceInputCubit({required AIToolsService aiToolsService})
      : _aiToolsService = aiToolsService,
        super(const VoiceInputState.idle());

  @override
  Future<void> close() {
    _recorder.dispose();
    return super.close();
  }

  Future<void> toggleRecording() async {
    try {
      final isRecording =
          state.maybeWhen(recording: () => true, orElse: () => false);
      if (isRecording) {
        await _stopRecording();
      } else {
        await _checkMicrophonePermission();
        await _startRecording();
      }
    } catch (e) {
      log('Error toggling recording: $e', name: 'VoiceInputCubit');
      emit(const VoiceInputState.error(message: 'Failed to start recording.'));
      emit(const VoiceInputState.idle());
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    if (path != null) {
      _transcribeAudio(File(path));
    } else {
      emit(const VoiceInputState.idle());
    }
  }

  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    final path =
        '${tempDir.path}/audio_input_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        bitRate: 128000,
      ),
      path: path,
    );

    emit(const VoiceInputState.recording());
  }

  Future<void> _checkMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      emit(
          const VoiceInputState.error(message: 'Microphone permission denied'));
      emit(const VoiceInputState.idle());
      return;
    }
  }

  Future<void> _transcribeAudio(File file) async {
    emit(const VoiceInputState.transcribing());

    try {
      final text = await _aiToolsService.transcribeAudio(file);

      if (text != null && text.isNotEmpty) {
        emit(VoiceInputState.success(text: text));
      } else {
        emit(const VoiceInputState.error(
            message: 'Failed to transcribe audio. Please try again later.'));
      }
    } catch (e) {
      log('Transcription error: $e', name: 'VoiceInputCubit');
      emit(const VoiceInputState.error(message: 'Transcription failed.'));
    } finally {
      emit(const VoiceInputState.idle());
      // Delete temporary audio file
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  void reset() {
    emit(const VoiceInputState.idle());
  }
}
