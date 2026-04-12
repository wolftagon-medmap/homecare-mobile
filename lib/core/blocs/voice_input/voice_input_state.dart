import 'package:freezed_annotation/freezed_annotation.dart';

part 'voice_input_state.freezed.dart';

@freezed
class VoiceInputState with _$VoiceInputState {
  const factory VoiceInputState.idle() = _Idle;
  const factory VoiceInputState.recording({@Default(0.0) double amplitude}) = _Recording;
  const factory VoiceInputState.paused({@Default(0.0) double amplitude}) = _Paused;
  const factory VoiceInputState.transcribing() = _Transcribing;
  const factory VoiceInputState.success({required String text}) = _Success;
  const factory VoiceInputState.error({required String message}) = _Error;
  const factory VoiceInputState.permissionPermanentlyDenied() =
      _PermissionPermanentlyDenied;
}
