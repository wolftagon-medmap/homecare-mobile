import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/data/datasources/assistant_remote_datasource.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session_summary.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  final AssistantRemoteDataSource _source;

  AssistantRepositoryImpl(this._source);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? e.type.name));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> startSession({bool fresh = false}) =>
      _guard(() => _source.startSession(fresh: fresh));

  @override
  Future<Either<Failure, List<AssistantBlock>>> history(String sessionId) =>
      _guard(() => _source.fetchHistory(sessionId));

  @override
  Future<Either<Failure, Unit>> sendText(String sessionId, String text) =>
      _guard(() async {
        await _source.send(sessionId: sessionId, text: text);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> sendReply(
    String sessionId, {
    required String replyId,
    required String label,
  }) =>
      _guard(() async {
        await _source.send(sessionId: sessionId, replyId: replyId, text: label);
        return unit;
      });

  @override
  Stream<AssistantBlock> stream(String sessionId, {int? lastEventId}) =>
      _source.streamBlocks(sessionId, lastEventId: lastEventId);

  @override
  Future<Either<Failure, List<AssistantSessionSummary>>> sessions() =>
      _guard(_source.listSessions);

  @override
  Future<Either<Failure, Unit>> deleteSession(String sessionId) =>
      _guard(() async {
        await _source.deleteSession(sessionId);
        return unit;
      });
}
