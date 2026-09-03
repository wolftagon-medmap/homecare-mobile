import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/data/datasources/assistant_script_datasource.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_script.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  final AssistantScriptDataSource source;

  AssistantRepositoryImpl({required this.source});

  AssistantScript? _cached;

  @override
  Future<Either<Failure, AssistantScript>> script() async {
    final cached = _cached;
    if (cached != null) return Right(cached);
    try {
      return Right(_cached = await source.fetch());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
