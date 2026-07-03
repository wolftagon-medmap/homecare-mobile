import 'package:m2health/features/intake_booking/domain/entities/block.dart';

/// The intake booking port. Kept vendor-free (no Dio types) so the cubit depends
/// only on domain shapes.
abstract class IntakeRepository {
  Future<String> startSession();
  Future<List<Block>> fetchHistory(String sessionId);

  Future<void> sendText({required String sessionId, required String text});
  Future<void> sendReply({required String sessionId, required String replyId});
  Future<void> sendLocation({
    required String sessionId,
    required double lat,
    required double lng,
    required String address,
  });

  /// Live blocks over SSE, replayed after [lastEventId]. Cancel by cancelling the
  /// subscription.
  Stream<Block> streamBlocks(String sessionId, {int? lastEventId});
}
