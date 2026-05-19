import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant }

enum MessageStatus { pending, complete }

class Message extends Equatable {
  final int? id;
  final MessageRole role;
  final String content;
  final MessageStatus status;

  const Message({
    this.id,
    required this.role,
    required this.content,
    this.status = MessageStatus.complete,
  });

  bool get isUser => role == MessageRole.user;

  bool get isPending => status == MessageStatus.pending;

  @override
  List<Object?> get props => [id, role, content, status];
}
