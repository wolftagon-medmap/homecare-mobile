import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant }

class Message extends Equatable {
  final int? id;
  final MessageRole role;
  final String content;

  const Message({
    this.id,
    required this.role,
    required this.content,
  });

  bool get isUser => role == MessageRole.user;

  @override
  List<Object?> get props => [id, role, content];
}
