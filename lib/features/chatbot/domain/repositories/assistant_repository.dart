import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_script.dart';

abstract class AssistantRepository {
  Future<Either<Failure, AssistantScript>> script();
}
