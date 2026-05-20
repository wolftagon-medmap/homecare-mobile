import 'package:equatable/equatable.dart';
import 'package:m2health/features/chatbot/domain/entities/message.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Loading a previous conversation from the backend.
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// Fatal, conversation-level error (e.g. failed to load a conversation).
class ChatFatalError extends ChatState {
  final String message;
  const ChatFatalError(this.message);

  @override
  List<Object?> get props => [message];
}

/// The active chat. [conversationId] is null until the first message creates it.
class ChatLoaded extends ChatState {
  final int? conversationId;
  final List<Message> messages;
  final bool isSending;

  /// Non-null when the last send failed; the user can retry.
  final String? sendError;

  const ChatLoaded({
    this.conversationId,
    this.messages = const [],
    this.isSending = false,
    this.sendError,
  });

  ChatLoaded copyWith({
    int? conversationId,
    List<Message>? messages,
    bool? isSending,
    String? sendError,
    bool clearSendError = false,
  }) {
    return ChatLoaded(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      sendError: clearSendError ? null : (sendError ?? this.sendError),
    );
  }

  @override
  List<Object?> get props => [conversationId, messages, isSending, sendError];
}
