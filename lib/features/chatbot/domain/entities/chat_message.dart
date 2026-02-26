import 'dart:io';

class ChatMessage {
  final String content;
  final bool isFromUser;
  final List<Attachment> attachments;
  final bool isStreaming;
  final String? nodeExecutionId;
  final String? outputKey;
  final String? reasoningContent;
  final List<String>? suggestedQuestions;
  final MessageStatus status;

  ChatMessage({
    required this.content,
    required this.isFromUser,
    this.attachments = const [],
    this.isStreaming = false,
    this.nodeExecutionId,
    this.outputKey,
    this.reasoningContent,
    this.suggestedQuestions,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({
    String? content,
    bool? isFromUser,
    List<Attachment>? attachments,
    bool? isStreaming,
    String? nodeExecutionId,
    String? outputKey,
    String? reasoningContent,
    List<String>? suggestedQuestions,
    MessageStatus? status,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      attachments: attachments ?? this.attachments,
      isStreaming: isStreaming ?? this.isStreaming,
      nodeExecutionId: nodeExecutionId ?? this.nodeExecutionId,
      outputKey: outputKey ?? this.outputKey,
      reasoningContent: reasoningContent ?? this.reasoningContent,
      suggestedQuestions: suggestedQuestions ?? this.suggestedQuestions,
      status: status ?? this.status,
    );
  }
}

enum MessageStatus { sending, sent, error }

class Attachment {
  final String? url;
  final String? name;
  final File? localFile;
  final AttachmentType type;

  Attachment({
    this.url,
    this.name,
    this.localFile,
    required this.type,
  });

  Attachment.local({required File file, this.name})
      : localFile = file,
        url = null,
        type = AttachmentType.file;

  Attachment.remote({required this.url, this.name})
      : localFile = null,
        type = AttachmentType.file;

  bool get isLocal => localFile != null;
}

enum AttachmentType { file, image }
