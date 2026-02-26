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
    InputConfiguration? inputConfig,
    @Default(false) bool isProcessing,
    @Default(false) bool isSessionClosed,
    String? error,
  }) = Loaded;

  const factory ChatState.error(String message) = _Error;
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
