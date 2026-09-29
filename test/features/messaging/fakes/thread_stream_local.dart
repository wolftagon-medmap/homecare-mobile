import 'package:m2health/features/messaging/data/datasources/thread_stream.dart';
import 'package:m2health/features/messaging/domain/entities/thread_event.dart';

class ThreadStreamLocal implements ThreadStream {
  @override
  Stream<ThreadEvent> get events => const Stream<ThreadEvent>.empty();

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}
}
