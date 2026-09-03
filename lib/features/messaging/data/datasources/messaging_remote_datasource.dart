import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';

import '../models/chat_message_model.dart';
import '../models/estimate_revision_model.dart';
import '../models/message_thread_model.dart';
import '../models/time_proposal_model.dart';
import 'messaging_datasource.dart';

/// Plain HTTP against the messaging module. Live delivery is a socket concern
/// and deliberately not wired here — a message that arrives over the socket is
/// still fetched through these same routes, so the app is correct without one.
class MessagingRemoteDataSource implements MessagingDataSource {
  final Dio _dio;

  MessagingRemoteDataSource(this._dio);

  Future<Options> _authOptions() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  @override
  Future<List<MessageThreadModel>> fetchThreads() async {
    final response = await _dio.get(
      '${Const.URL_API_V2}/threads',
      options: await _authOptions(),
    );
    return (response.data['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(MessageThreadModel.fromJson)
        .toList();
  }

  @override
  Future<ChatMessagePageModel> fetchMessages(int threadId) async {
    final response = await _dio.get(
      '${Const.URL_API_V2}/threads/$threadId/messages',
      options: await _authOptions(),
    );
    return ChatMessagePageModel.fromJson(
        Map<String, dynamic>.from(response.data as Map));
  }

  @override
  Future<ChatMessageModel> sendMessage(int threadId, String body) async {
    final response = await _dio.post(
      '${Const.URL_API_V2}/threads/$threadId/messages',
      data: {'kind': 'text', 'body': body},
      options: await _authOptions(),
    );
    return ChatMessageModel.fromJson(
        response.data['message'] as Map<String, dynamic>);
  }

  @override
  Future<int> markRead(int threadId, int lastMessageId) async {
    final response = await _dio.post(
      '${Const.URL_API_V2}/threads/$threadId/read',
      data: {'lastMessageId': lastMessageId},
      options: await _authOptions(),
    );
    return (response.data['unread'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<int> unreadCount() async {
    final response = await _dio.get(
      '${Const.URL_API_V2}/threads/unread-count',
      options: await _authOptions(),
    );
    return (response.data['unread'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<TimeProposalModel> proposeTime({
    required int threadId,
    required int careTaskId,
    required DateTime start,
    required DateTime end,
    String? reason,
  }) async {
    final response = await _dio.post(
      '${Const.URL_API_V2}/care-tasks/$careTaskId/propose-time',
      data: {
        'proposedStart': start.toUtc().toIso8601String(),
        'proposedEnd': end.toUtc().toIso8601String(),
        'reason': reason,
      },
      options: await _authOptions(),
    );
    return TimeProposalModel.fromJson(
        response.data['proposal'] as Map<String, dynamic>);
  }

  @override
  Future<TimeProposalModel> acceptProposal(int threadId, int proposalId) async {
    final response = await _dio.post(
      '${Const.URL_API_V2}/time-proposals/$proposalId/accept',
      options: await _authOptions(),
    );
    return TimeProposalModel.fromJson(
        response.data['proposal'] as Map<String, dynamic>);
  }

  @override
  Future<TimeProposalModel> chooseAnotherTime({
    required int threadId,
    required int proposalId,
    DateTime? preferred,
  }) async {
    final response = await _dio.post(
      '${Const.URL_API_V2}/time-proposals/$proposalId/choose-another',
      data: {
        if (preferred != null)
          'preferredDate':
              '${preferred.year}-${_two(preferred.month)}-${_two(preferred.day)}',
        if (preferred != null)
          'preferredTime': '${_two(preferred.hour)}:${_two(preferred.minute)}',
      },
      options: await _authOptions(),
    );
    return TimeProposalModel.fromJson(
        response.data['proposal'] as Map<String, dynamic>);
  }

  /// Approving a revised estimate is the pricing module's endpoint — this
  /// feature renders the card and never owns the money.
  @override
  Future<EstimateRevisionModel> approveEstimate(
      int threadId, int revisionId) async {
    final response = await _dio.post(
      '${Const.URL_API_V2}/estimate-revisions/$revisionId/approve',
      options: await _authOptions(),
    );
    return EstimateRevisionModel.fromJson(
        response.data['revision'] as Map<String, dynamic>);
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
