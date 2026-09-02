import 'dart:math' as math;

import '../fixtures/thread_fixtures.dart';
import '../models/chat_message_model.dart';
import '../models/estimate_revision_model.dart';
import '../models/message_thread_model.dart';
import '../models/time_proposal_model.dart';
import 'messaging_datasource.dart';

/// The demo conversation. Deliberately **stateful**: sending appends, accepting
/// flips the card and posts the system line, choosing another time posts a fresh
/// proposal. A read-only fixture would let the client tap a button and watch
/// nothing happen.
///
/// State lives for the life of the process, so a cold start replays the script
/// from the top — which is what you want between two run-throughs.
class MessagingLocalDataSource implements MessagingDataSource {
  final Map<int, List<Map<String, dynamic>>> _messages =
      kThreadMessagesFixture();
  final List<Map<String, dynamic>> _threads = kThreadListFixture();

  /// Fixture ids are small; new ones start well clear of them.
  int _nextId = 9000;

  static const _latency = Duration(milliseconds: 220);

  @override
  Future<List<MessageThreadModel>> fetchThreads() async {
    await Future<void>.delayed(_latency);
    return _threads.map(MessageThreadModel.fromJson).toList();
  }

  @override
  Future<List<ChatMessageModel>> fetchMessages(int threadId) async {
    await Future<void>.delayed(_latency);
    return (_messages[threadId] ?? const [])
        .map(ChatMessageModel.fromJson)
        .toList();
  }

  @override
  Future<ChatMessageModel> sendMessage(int threadId, String body) async {
    await Future<void>.delayed(_latency);
    final row = <String, dynamic>{
      'id': _nextId++,
      'threadId': threadId,
      'kind': 'text',
      'body': body,
      'authorUserId': kDemoPatientUserId,
      'payload': null,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
    _append(threadId, row);
    return ChatMessageModel.fromJson(row);
  }

  @override
  Future<int> markRead(int threadId, int lastMessageId) async {
    final thread = _threadRow(threadId);
    if (thread != null) thread['unread'] = 0;
    return unreadCount();
  }

  @override
  Future<int> unreadCount() async {
    var total = 0;
    for (final thread in _threads) {
      total += (thread['unread'] as num?)?.toInt() ?? 0;
    }
    return total;
  }

  @override
  Future<TimeProposalModel> proposeTime({
    required int threadId,
    required int careTaskId,
    required DateTime start,
    required DateTime end,
    String? reason,
  }) async {
    await Future<void>.delayed(_latency);

    // Any proposal still open on this thread stands down — but only now that
    // the replacement exists, which is the same order the backend uses.
    final previous = _latestPayload(threadId, 'time_proposal');
    final original = previous == null
        ? null
        : {
            'start': previous['proposedStart'],
            'end': previous['proposedEnd'],
          };
    _withdrawOpenProposals(threadId);

    final authorUserId = _counterpartOf(threadId) ?? kDemoNurseUserId;
    final payload = <String, dynamic>{
      'proposalId': _nextId++,
      'careTaskId': careTaskId,
      'status': 'pending',
      'originalStart': original?['start'],
      'originalEnd': original?['end'],
      'proposedStart': start.toUtc().toIso8601String(),
      'proposedEnd': end.toUtc().toIso8601String(),
      'reason': reason,
      'expiresAt': DateTime.now()
          .add(const Duration(minutes: 30))
          .toUtc()
          .toIso8601String(),
      'proposedByUserId': authorUserId,
    };
    _append(threadId, {
      'id': _nextId++,
      'threadId': threadId,
      'kind': 'time_proposal',
      'body': null,
      'authorUserId': authorUserId,
      'payload': payload,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    });
    return TimeProposalModel.fromJson(payload);
  }

  @override
  Future<TimeProposalModel> acceptProposal(int threadId, int proposalId) async {
    await Future<void>.delayed(_latency);
    final payload = _setProposalStatus(threadId, proposalId, 'accepted');
    _appendSystemLine(
      threadId,
      'New time agreed: ${_windowLabel(payload)}.',
    );
    return TimeProposalModel.fromJson(payload);
  }

  @override
  Future<TimeProposalModel> chooseAnotherTime({
    required int threadId,
    required int proposalId,
    DateTime? preferred,
  }) async {
    await Future<void>.delayed(_latency);
    final payload = _setProposalStatus(threadId, proposalId, 'declined');
    _appendSystemLine(
      threadId,
      preferred == null
          ? 'You asked for a different time.'
          : 'You asked for ${_dayLabel(preferred)} at ${_timeLabel(preferred)} instead.',
    );
    return TimeProposalModel.fromJson(payload);
  }

  @override
  Future<EstimateRevisionModel> approveEstimate(
      int threadId, int revisionId) async {
    await Future<void>.delayed(_latency);
    final rows = _messages[threadId] ?? const [];
    Map<String, dynamic> payload = const {};

    for (final row in rows) {
      if (row['kind'] != 'estimate_revision') continue;
      final candidate = row['payload'] as Map<String, dynamic>?;
      if (candidate == null || candidate['revisionId'] != revisionId) continue;
      candidate['status'] = 'approved';
      payload = candidate;
    }

    if (payload.isNotEmpty) {
      final total = (payload['proposedTotal'] as num?)?.toDouble() ?? 0;
      _appendSystemLine(
        threadId,
        'You approved the revised estimate. New total ${payload['currency']}'
        '${total.toStringAsFixed(2)}.',
      );
    }
    return EstimateRevisionModel.fromJson(payload);
  }

  void _append(int threadId, Map<String, dynamic> row) {
    (_messages[threadId] ??= []).add(row);
    final thread = _threadRow(threadId);
    if (thread == null) return;
    thread['lastMessage'] = {
      'kind': row['kind'],
      'body': row['body'],
      'authorUserId': row['authorUserId'],
      'createdAt': row['createdAt'],
    };
    thread['lastMessageAt'] = row['createdAt'];
  }

  void _appendSystemLine(int threadId, String body) => _append(threadId, {
        'id': _nextId++,
        'threadId': threadId,
        'kind': 'system',
        'body': body,
        'authorUserId': null,
        'payload': null,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });

  Map<String, dynamic>? _threadRow(int threadId) {
    for (final thread in _threads) {
      if (thread['id'] == threadId) return thread;
    }
    return null;
  }

  int? _counterpartOf(int threadId) =>
      (_threadRow(threadId)?['counterpart'] as Map<String, dynamic>?)?['userId']
          as int?;

  Map<String, dynamic>? _latestPayload(int threadId, String kind) {
    for (final row in (_messages[threadId] ?? const []).reversed) {
      if (row['kind'] == kind) return row['payload'] as Map<String, dynamic>?;
    }
    return null;
  }

  void _withdrawOpenProposals(int threadId) {
    for (final row in _messages[threadId] ?? const <Map<String, dynamic>>[]) {
      if (row['kind'] != 'time_proposal') continue;
      final payload = row['payload'] as Map<String, dynamic>?;
      if (payload?['status'] == 'pending') payload!['status'] = 'withdrawn';
    }
  }

  Map<String, dynamic> _setProposalStatus(
      int threadId, int proposalId, String status) {
    for (final row in _messages[threadId] ?? const <Map<String, dynamic>>[]) {
      if (row['kind'] != 'time_proposal') continue;
      final payload = row['payload'] as Map<String, dynamic>?;
      if (payload == null || payload['proposalId'] != proposalId) continue;
      payload['status'] = status;
      return payload;
    }
    return const {};
  }

  String _windowLabel(Map<String, dynamic> payload) {
    final start = DateTime.tryParse(payload['proposedStart'] as String? ?? '');
    final end = DateTime.tryParse(payload['proposedEnd'] as String? ?? '');
    if (start == null) return 'the new time';
    final local = start.toLocal();
    final tail = end == null ? '' : '-${_timeLabel(end.toLocal())}';
    return '${_dayLabel(local)}, ${_timeLabel(local)}$tail';
  }

  String _dayLabel(DateTime at) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(at.year, at.month, at.day);
    final diff = day.difference(today).inDays;
    if (diff == 0) return 'today';
    if (diff == 1) return 'tomorrow';
    return '${at.day}/${at.month}';
  }

  String _timeLabel(DateTime at) =>
      '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';

  /// Exposed for the tests: the largest fixture id, so an assertion can prove
  /// generated ids never collide with scripted ones.
  static int highestFixtureId() {
    var highest = 0;
    for (final rows in kThreadMessagesFixture().values) {
      for (final row in rows) {
        highest = math.max(highest, (row['id'] as num?)?.toInt() ?? 0);
      }
    }
    return highest;
  }
}
