import '../../domain/entities/thread_event.dart';

abstract class ThreadStream {
  Stream<ThreadEvent> get events;

  Future<void> connect();

  Future<void> disconnect();
}
