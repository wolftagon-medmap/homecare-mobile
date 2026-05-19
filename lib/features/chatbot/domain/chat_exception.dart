/// Domain-level failure raised by the chat repository so the presentation
/// layer can decide whether to offer a retry affordance.
class ChatException implements Exception {
  final String message;
  final bool retryable;

  const ChatException(this.message, {this.retryable = true});

  @override
  String toString() => 'ChatException: $message';
}
