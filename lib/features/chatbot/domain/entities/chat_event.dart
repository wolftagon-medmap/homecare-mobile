import 'package:m2health/features/chatbot/domain/entities/chat_message.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';

abstract class ChatEvent {
  final String nodeId;
  final String? nodeExecutionId;
  final String? messageId;
  final EventType type;
  final EventStatus status;
  final EventSender sender;

  ChatEvent({
    required this.nodeId,
    this.nodeExecutionId,
    this.messageId,
    required this.type,
    this.status = EventStatus.end,
    required this.sender,
  });
}

enum EventSender { assistant, user }

enum EventType {
  userInput, // User input event
  guideWord, // Opening message
  guideQuestion, // Suggested questions
  input, // Waiting for user input
  outputMsg, // Standard output
  outputWithInputMsg, // Output + editable input
  outputWithChooseMsg, // Output + selection
  streamMsg, // Streaming content
  close, // Session ended
  error, // Error event
  unknown, // For unrecognized event types
}

enum EventStatus { stream, end }

// User Input Event
class UserInputEvent extends ChatEvent {
  final String textInput;

  UserInputEvent({
    super.nodeId = "", // No need nodeId for user input events, set to empty
    required this.textInput,
    super.sender = EventSender.user,
  }) : super(
          type: EventType.userInput,
        );
}

// Input Event (Waiting for user input)
class InputEvent extends ChatEvent {
  final InputConfiguration inputConfig;

  InputEvent({
    required super.nodeId,
    required this.inputConfig,
    super.messageId,
    super.nodeExecutionId,
    super.sender = EventSender.assistant,
  }) : super(type: EventType.input);
}

// Output Message Event (Standard output)
class OutputMessageEvent extends ChatEvent {
  final String content;
  final String? outputKey;
  final List<Attachment> attachments;
  final String? sourceUrl;
  final Map<String, dynamic>? extra;

  OutputMessageEvent({
    required super.nodeId,
    required this.content,
    this.outputKey,
    this.attachments = const [],
    this.sourceUrl,
    this.extra,
    super.messageId,
    super.nodeExecutionId,
    super.status,
    super.sender = EventSender.assistant,
  }) : super(type: EventType.outputMsg);
}

//  Stream Message Event (Streaming chunks)
class StreamMessageEvent extends ChatEvent {
  final String content;
  final String? outputKey;
  final String? reasoningContent;
  final EventStatus streamStatus;

  StreamMessageEvent({
    required super.nodeId,
    required this.content,
    this.outputKey,
    this.reasoningContent,
    required this.streamStatus,
    super.nodeExecutionId,
    super.sender = EventSender.assistant,
  }) : super(
          type: EventType.streamMsg,
          status: streamStatus,
        );
}

// Unknown Event (For unrecognized event types)
class UnknownEvent extends ChatEvent {
  UnknownEvent({
    required super.nodeId,
    super.status = EventStatus.end,
  }) : super(type: EventType.unknown, sender: EventSender.assistant);
}

//  Close Event (Session ended)
// class CloseEvent extends ChatEvent {
//   final String? errorCode;
//   final String? errorMessage;

//   CloseEvent({
//     this.errorCode,
//     this.errorMessage,
//     required super.nodeId,
//     super.nodeExecutionId,
//   }) : super(type: EventType.close);

//   bool get isError => errorCode != null || errorMessage != null;
// }

//  Error Event (Processing error)
// class ErrorEvent extends ChatEvent {
//   final String errorCode;
//   final String errorMessage;

//   ErrorEvent({
//     required this.errorCode,
//     required this.errorMessage,
//     required super.nodeId,
//     super.nodeExecutionId,
//   }) : super(type: EventType.error);
// }
