import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/data/datasources/assistant_session_store.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_session_repository.dart';

class AssistantSessionRepositoryImpl implements AssistantSessionRepository {
  final AssistantSessionStore store;

  AssistantSessionRepositoryImpl({required this.store});

  @override
  Future<Either<Failure, List<AssistantSession>>> sessions() =>
      _guard(() => store.list());

  @override
  Future<Either<Failure, Unit>> save(AssistantSession session) =>
      _guard(() async {
        await store.save(session);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> delete(String id) => _guard(() async {
        await store.delete(id);
        return unit;
      });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
