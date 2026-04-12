import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/blocs/voice_input/voice_input_state.dart';
import 'package:m2health/core/services/ai_tools_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceInputCubit extends Cubit<VoiceInputState> {
  final AIToolsService _aiToolsService;
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _amplitudeTimer;
  String? _currentPath;

  VoiceInputCubit({required AIToolsService aiToolsService})
      : _aiToolsService = aiToolsService,
        super(const VoiceInputState.idle());

  @override
  Future<void> close() {
    _stopAmplitudeTimer();
    _recorder.dispose();
    return super.close();
  }

  void _startAmplitudeTimer() {
    _stopAmplitudeTimer();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (state.maybeMap(recording: (_) => true, orElse: () => false)) {
        final amplitude = await _recorder.getAmplitude();
        // Map decibels to 0.0 - 1.0 range (approximately)
        // dB usually ranges from -160 to 0
        final volume = (math.pow(10, amplitude.current / 20).toDouble()).clamp(0.0, 1.0);
        emit(VoiceInputState.recording(amplitude: volume));
      }
    });
  }

  void _stopAmplitudeTimer() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
  }

  Future<void> startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isPermanentlyDenied || status.isRestricted) {
        // iOS: permission was previously denied and the system won't show
        // the prompt again. The user must re-enable it manually in Settings.
        emit(const VoiceInputState.permissionPermanentlyDenied());
        emit(const VoiceInputState.idle());
        return;
      }
      if (!status.isGranted) {
        emit(const VoiceInputState.error(message: 'Microphone permission denied'));
        emit(const VoiceInputState.idle());
        return;
      }

      final tempDir = await getTemporaryDirectory();
      _currentPath = '${tempDir.path}/audio_input_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          bitRate: 128000,
        ),
        path: _currentPath!,
      );

      emit(const VoiceInputState.recording());
      _startAmplitudeTimer();
    } catch (e) {
      log('Error starting recording: $e', name: 'VoiceInputCubit');
      emit(const VoiceInputState.error(message: 'Failed to start recording.'));
      emit(const VoiceInputState.idle());
    }
  }

  Future<void> stopRecording() async {
    _stopAmplitudeTimer();
    try {
      final path = await _recorder.stop();
      if (path != null) {
        _transcribeAudio(File(path));
      } else {
        emit(const VoiceInputState.idle());
      }
    } catch (e) {
      log('Error stopping recording: $e', name: 'VoiceInputCubit');
      emit(const VoiceInputState.idle());
    }
  }

  Future<void> pauseRecording() async {
    try {
      if (await _recorder.isRecording()) {
        await _recorder.pause();
        _stopAmplitudeTimer();
        emit(const VoiceInputState.paused(amplitude: 0.0));
      }
    } catch (e) {
      log('Error pausing recording: $e', name: 'VoiceInputCubit');
    }
  }

  Future<void> resumeRecording() async {
    try {
      if (await _recorder.isPaused()) {
        await _recorder.resume();
        emit(const VoiceInputState.recording());
        _startAmplitudeTimer();
      }
    } catch (e) {
      log('Error resuming recording: $e', name: 'VoiceInputCubit');
    }
  }

  Future<void> cancelRecording() async {
    _stopAmplitudeTimer();
    try {
      await _recorder.stop();
      if (_currentPath != null) {
        final file = File(_currentPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      _currentPath = null;
      emit(const VoiceInputState.idle());
    } catch (e) {
      log('Error cancelling recording: $e', name: 'VoiceInputCubit');
      emit(const VoiceInputState.idle());
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
      _currentPath = null;
    }
  }

  void reset() {
    emit(const VoiceInputState.idle());
  }
}
