import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_block.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_session_summary.dart';
import 'package:m2health/features/chatbot/domain/repositories/assistant_repository.dart';

class SentText {
  final String sessionId;
  final String text;

  const SentText(this.sessionId, this.text);
}

class SentReply {
  final String sessionId;
  final String replyId;
  final String label;

  const SentReply(this.sessionId, this.replyId, this.label);
}

class FakeAssistantRepository implements AssistantRepository {
  FakeAssistantRepository({
    this.sessionId = 'session-1',
    List<AssistantBlock> history = const [],
  }) : historyBlocks = history;

  final String sessionId;
  List<AssistantBlock> historyBlocks;
  List<AssistantSessionSummary> sessionList = [];
  bool failStart = false;
  bool failHistory = false;
  bool failNextSend = false;
  bool failSessions = false;
  bool failDelete = false;

  final List<SentText> sentTexts = [];
  final List<SentReply> sentReplies = [];
  final List<String> deletedSessions = [];
  final List<bool> startFresh = [];
  final List<int?> streamCursors = [];
  final List<String> historyRequests = [];

  StreamController<AssistantBlock> controller =
      StreamController<AssistantBlock>.broadcast();

  void push(AssistantBlock block) => controller.add(block);

  Future<void> closeStream() => controller.close();

  void reopenStream() {
    controller = StreamController<AssistantBlock>.broadcast();
  }

  @override
  Future<Either<Failure, String>> startSession({bool fresh = false}) async {
    startFresh.add(fresh);
    if (failStart) return const Left(ServerFailure('start failed'));
    return Right(sessionId);
  }

  @override
  Future<Either<Failure, List<AssistantBlock>>> history(
    String sessionId,
  ) async {
    historyRequests.add(sessionId);
    if (failHistory) return const Left(ServerFailure('history failed'));
    return Right(historyBlocks);
  }

  @override
  Future<Either<Failure, Unit>> sendText(String sessionId, String text) async {
    sentTexts.add(SentText(sessionId, text));
    return _sendResult();
  }

  @override
  Future<Either<Failure, Unit>> sendReply(
    String sessionId, {
    required String replyId,
    required String label,
  }) async {
    sentReplies.add(SentReply(sessionId, replyId, label));
    return _sendResult();
  }

  Either<Failure, Unit> _sendResult() {
    if (failNextSend) {
      failNextSend = false;
      return const Left(ServerFailure('send failed'));
    }
    return const Right(unit);
  }

  @override
  Stream<AssistantBlock> stream(String sessionId, {int? lastEventId}) {
    streamCursors.add(lastEventId);
    return controller.stream;
  }

  @override
  Future<Either<Failure, List<AssistantSessionSummary>>> sessions() async {
    if (failSessions) return const Left(ServerFailure('sessions failed'));
    return Right(sessionList);
  }

  @override
  Future<Either<Failure, Unit>> deleteSession(String sessionId) async {
    deletedSessions.add(sessionId);
    if (failDelete) return const Left(ServerFailure('delete failed'));
    sessionList = sessionList.where((s) => s.id != sessionId).toList();
    return const Right(unit);
  }
}
