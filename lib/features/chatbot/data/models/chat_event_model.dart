
import 'package:m2health/features/chatbot/domain/entities/chat_event.dart';
import 'package:m2health/features/chatbot/domain/entities/attachment.dart';
import 'package:m2health/features/chatbot/domain/entities/input_configuration.dart';

part 'output_schema_model.dart';
part 'input_schema_model.dart';

class ChatEventModel {
  final String sessionId;
  final String event;
  final String nodeId;
  final String? nodeExecutionId;
  final String? messageId;
  final String? status;
  final OutputSchemaModel? outputSchema;
  final InputSchemaModel? inputSchema;
  final Map<String, dynamic>? userInput;
  final String? sender; // "assistant" or "user"

  ChatEventModel({
    required this.sessionId,
    required this.event,
    required this.nodeId,
    this.nodeExecutionId,
    this.messageId,
    this.status,
    this.outputSchema,
    this.inputSchema,
    this.userInput,
    this.sender,
  });

  factory ChatEventModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as String?;
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return ChatEventModel(
      sessionId: json['session_id'] as String? ?? '',
      event: data['event'] as String,
      nodeId: data['node_id'] as String? ?? '',
      nodeExecutionId: data['node_execution_id'] as String?,
      messageId: data['message_id'] as String?,
      status: data['status'] as String?,
      outputSchema: data['output_schema'] != null
          ? OutputSchemaModel.fromJson(
              data['output_schema'] as Map<String, dynamic>)
          : null,
      inputSchema: data['input_schema'] != null
          ? InputSchemaModel.fromJson(
              data['input_schema'] as Map<String, dynamic>)
          : null,
      userInput: data['input'] as Map<String, dynamic>?,
      sender: sender,
    );
  }

  ChatEvent toEntity() {
    EventStatus convertStatus(String? status) {
      switch (status) {
        case 'stream':
          return EventStatus.stream;
        case 'end':
        default:
          return EventStatus.end;
      }
    }

    EventSender convertSender(String? sender) {
      switch (sender) {
        case 'user':
          return EventSender.user;
        case 'assistant':
        default:
          return EventSender.assistant;
      }
    }

    switch (event) {
      case 'user_input':
        // Extract text from input structure like {"node_xxx": {"user_input": "text to be displayed"}}
        String? extractedText;
        userInput?.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            extractedText = value['user_input'] as String?;
          }
        });
        return UserInputEvent(
          textInput: extractedText ?? '',
          sender: convertSender(sender),
        );

      // case 'guide_word':
      //   return GuideWordEvent(
      //     nodeId: nodeId,
      //     message: outputSchema?.message ?? '',
      //     reasoningContent: outputSchema?.reasoningContent,
      //     messageId: messageId,
      //     nodeExecutionId: nodeExecutionId,
      //     status: convertStatus(status),
      //   );

      // case 'guide_question':
      //   final questions = (outputSchema?.message as List<dynamic>?)
      //           ?.map((e) => e.toString())
      //           .toList() ??
      //       [];
      //   return GuideQuestionEvent(
      //     nodeId: nodeId,
      //     questions: questions,
      //     messageId: messageId,
      //     nodeExecutionId: nodeExecutionId,
      //   );

      case 'input':
        if (inputSchema == null) {
          throw const FormatException(
              'Input schema is missing for input event');
        }
        return InputEvent(
          nodeId: nodeId,
          inputConfig: inputSchema!
              .toInputConfigurationEntity(), // Ensure nodeId is set in the input config
          messageId: messageId,
          nodeExecutionId: nodeExecutionId,
          sender: convertSender(sender),
        );

      case 'output_msg':
        return OutputMessageEvent(
          nodeId: nodeId,
          content: outputSchema?.message ?? '',
          outputKey: outputSchema?.outputKey,
          attachments:
              outputSchema?.files?.map((f) => f.toAttachment()).toList() ?? [],
          sourceUrl: outputSchema?.sourceUrl,
          extra: outputSchema?.extra,
          messageId: messageId,
          nodeExecutionId: nodeExecutionId,
          status: convertStatus(status),
          sender: convertSender(sender),
        );

      // case 'output_with_input_msg':
      //   if (inputSchema == null) {
      //     throw const FormatException(
      //         'Input schema is missing for output_with_input_msg event');
      //   }

      //   return OutputWithInputEvent(
      //     nodeId: nodeId,
      //     content: outputSchema?.message ?? '',
      //     inputConfig: inputSchema!.toInputConfigurationEntity(),
      //     outputKey: outputSchema?.outputKey,
      //     attachments:
      //         outputSchema?.files?.map((f) => f.toAttachment()).toList() ?? [],
      //     messageId: messageId,
      //     nodeExecutionId: nodeExecutionId,
      //     status: convertStatus(status),
      //   );

      // case 'output_with_choose_msg':
      //   if (inputSchema == null) {
      //     throw const FormatException(
      //         'Input schema is missing for output_with_choose_msg event');
      //   }
      //   return OutputWithChooseEvent(
      //     nodeId: nodeId,
      //     content: outputSchema?.message ?? '',
      //     inputConfig: inputSchema!.toInputConfigurationEntity(),
      //     outputKey: outputSchema?.outputKey,
      //     attachments:
      //         outputSchema?.files?.map((f) => f.toAttachment()).toList() ?? [],
      //     messageId: messageId,
      //     nodeExecutionId: nodeExecutionId,
      //     status: convertStatus(status),
      //   );

      case 'stream_msg':
        return StreamMessageEvent(
          nodeId: nodeId,
          content: outputSchema?.message ?? '',
          outputKey: outputSchema?.outputKey,
          reasoningContent: outputSchema?.reasoningContent,
          streamStatus: convertStatus(status),
          nodeExecutionId: nodeExecutionId,
          sender: convertSender(sender),
        );

      // case 'close':
      //   final errorData = outputSchema?.message;
      //   return CloseEvent(
      //     errorCode: errorData is Map ? errorData['code']?.toString() : null,
      //     errorMessage:
      //         errorData is Map ? errorData['message']?.toString() : null,
      //     nodeId: nodeId,
      //     nodeExecutionId: nodeExecutionId,
      //   );

      default:
        return UnknownEvent(nodeId: nodeId);
      // throw UnimplementedError('Unknown event type: $event');
    }
  }
}
