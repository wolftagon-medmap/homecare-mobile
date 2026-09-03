import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';

import '../entities/chat_message.dart';
import '../entities/estimate_revision.dart';
import '../entities/message_thread.dart';
import '../entities/time_proposal.dart';

abstract class MessagingRepository {
  Future<Either<Failure, List<MessageThread>>> loadThreads();

  Future<Either<Failure, ChatMessagePage>> loadMessages(int threadId);

  Future<Either<Failure, ChatMessage>> sendMessage(int threadId, String body);

  Future<Either<Failure, int>> markRead(int threadId, int lastMessageId);

  Future<Either<Failure, int>> unreadCount();

  /// The professional offers a different slot. Holds it before anything else
  /// moves — see the backend service for why that order matters.
  Future<Either<Failure, TimeProposal>> proposeTime({
    required int threadId,
    required int careTaskId,
    required DateTime start,
    required DateTime end,
    String? reason,
  });

  Future<Either<Failure, TimeProposal>> acceptProposal(
      int threadId, int proposalId);

  Future<Either<Failure, TimeProposal>> chooseAnotherTime({
    required int threadId,
    required int proposalId,
    DateTime? preferred,
  });

  Future<Either<Failure, EstimateRevision>> approveEstimate(
      int threadId, int revisionId);
}
