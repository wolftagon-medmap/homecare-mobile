import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';

abstract class AssistantSessionRepository {
  Future<Either<Failure, List<AssistantSession>>> sessions();

  Future<Either<Failure, Unit>> save(AssistantSession session);

  Future<Either<Failure, Unit>> delete(String id);
}
