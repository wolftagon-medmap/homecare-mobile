import '../models/chat_message_model.dart';
import '../models/estimate_revision_model.dart';
import '../models/message_thread_model.dart';
import '../models/time_proposal_model.dart';

/// One interface, two implementations. Which one is registered is decided by
/// `AppFlags` in `injection.dart` — flipping the flag is the whole backend
/// cutover.
abstract class MessagingDataSource {
  Future<List<MessageThreadModel>> fetchThreads();

  Future<ChatMessagePageModel> fetchMessages(int threadId);

  Future<ChatMessageModel> sendMessage(int threadId, String body);

  Future<int> markRead(int threadId, int lastMessageId);

  Future<int> unreadCount();

  Future<TimeProposalModel> proposeTime({
    required int threadId,
    required int careTaskId,
    required DateTime start,
    required DateTime end,
    String? reason,
  });

  Future<TimeProposalModel> acceptProposal(int threadId, int proposalId);

  Future<TimeProposalModel> chooseAnotherTime({
    required int threadId,
    required int proposalId,
    DateTime? preferred,
  });

  Future<EstimateRevisionModel> approveEstimate(int threadId, int revisionId);
}
