// chatbot/presentation/bloc/chat_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loading({String? message}) = _Loading;

  const factory ChatState.loaded({
    required List<ChatEvent> events,
    InputEvent?
        activeInputEvent, // The input event that is currently active (waiting for user input)
    @Default(false) bool isProcessing,
    @Default(false) bool isSessionClosed,

    // Message level error (e.g. failed to send input). Preserve chat history while allowing retry.
    String? error,
    bool? isRetryable,
  }) = Loaded;

  // Session level error (e.g. failed to load session, critical errors)
  const factory ChatState.error({
    required String message,
    @Default(true) bool isRetryable,
  }) = _Error;
}

extension ChatStateX on ChatState {
  // Filters out metadata events (like dialog_input) that shouldn't appear as bubbles
  List<ChatEvent> get displayableEvents => maybeMap(
        loaded: (s) => s.events.where((e) {
          if (e is InputEvent &&
              e.inputConfig.inputType == InputType.dialogInput) {
            return false;
          }
          return e.type != EventType.close;
        }).toList(),
        orElse: () => [],
      );
}
