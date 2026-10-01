import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session_summary.dart';

abstract class AssistantRepository {
  Future<Either<Failure, String>> startSession({bool fresh = false});

  Future<Either<Failure, List<AssistantBlock>>> history(String sessionId);

  Future<Either<Failure, Unit>> sendText(String sessionId, String text);

  Future<Either<Failure, Unit>> sendReply(
    String sessionId, {
    required String replyId,
    required String label,
  });

  Stream<AssistantBlock> stream(String sessionId, {int? lastEventId});

  Future<Either<Failure, List<AssistantSessionSummary>>> sessions();

  Future<Either<Failure, Unit>> deleteSession(String sessionId);
}
