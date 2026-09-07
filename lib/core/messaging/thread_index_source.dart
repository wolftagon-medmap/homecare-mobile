import 'thread_ref.dart';

/// Where the thread index comes from.
///
/// `lib/core` owns the contract; `features/messaging` owns the implementation.
/// That inversion is the whole point — it lets an appointment card ask "is there
/// a conversation for this?" without importing the messaging feature.
abstract class ThreadIndexSource {
  Future<List<ThreadEntry>> loadThreadIndex();
}
