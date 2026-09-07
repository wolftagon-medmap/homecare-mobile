import '../../domain/entities/thread_event.dart';

abstract class ThreadStream {
  Stream<ThreadEvent> get events;

  Future<void> connect();

  Future<void> disconnect();
}

class ThreadStreamLocal implements ThreadStream {
  @override
  Stream<ThreadEvent> get events => const Stream<ThreadEvent>.empty();

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}
}
