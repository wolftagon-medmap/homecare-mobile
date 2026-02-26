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

// 0. User Input Event
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

// 1. Guide Word Event (Opening)
// class GuideWordEvent extends ChatEvent {
//   final String message;
//   final String? reasoningContent;

//   GuideWordEvent({
//     required super.nodeId,
//     required this.message,
//     this.reasoningContent,
//     super.messageId,
//     super.nodeExecutionId,
//     super.status,
//   }) : super(type: EventType.guideWord);
// }

// 2. Guide Question Event (Suggested questions)
// class GuideQuestionEvent extends ChatEvent {
//   final List<String> questions;

//   GuideQuestionEvent({
//     required super.nodeId,
//     required this.questions,
//     super.messageId,
//     super.nodeExecutionId,
//     super.status,
//   }) : super(type: EventType.guideQuestion);
// }

// 3. Input Event (Waiting for user input)
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

// 4. Output Message Event (Standard output)
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

// 5. Output With Input Event (Output + editable text)
// class OutputWithInputEvent extends ChatEvent {
//   final String content;
//   final String? outputKey;
//   final List<Attachment> attachments;
//   final InputConfiguration inputConfig; // Contains editable field

//   OutputWithInputEvent({
//     required super.nodeId,
//     required this.content,
//     required this.inputConfig,
//     this.outputKey,
//     this.attachments = const [],
//     super.messageId,
//     super.nodeExecutionId,
//     super.status,
//   }) : super(type: EventType.outputWithInputMsg);
// }

// 6. Output With Choose Event (Output + selection options)
// class OutputWithChooseEvent extends ChatEvent {
//   final String content;
//   final String? outputKey;
//   final List<Attachment> attachments;
//   final InputConfiguration inputConfig; // Contains select options

//   OutputWithChooseEvent({
//     required super.nodeId,
//     required this.content,
//     required this.inputConfig,
//     this.outputKey,
//     this.attachments = const [],
//     super.messageId,
//     super.nodeExecutionId,
//     super.status,
//   }) : super(type: EventType.outputWithChooseMsg);
// }

// 7. Stream Message Event (Streaming chunks)
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

// 8. Close Event (Session ended)
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

// 9. Error Event (Processing error)
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

class UnknownEvent extends ChatEvent {
  UnknownEvent({
    required super.nodeId,
    super.status = EventStatus.end,
  }) : super(type: EventType.unknown, sender: EventSender.assistant);
}
