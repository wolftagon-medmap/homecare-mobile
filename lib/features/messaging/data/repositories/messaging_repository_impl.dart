import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/estimate_revision.dart';
import '../../domain/entities/message_thread.dart';
import '../../domain/entities/time_proposal.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../datasources/messaging_datasource.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final MessagingDataSource _source;

  MessagingRepositoryImpl(this._source);

  @override
  Future<Either<Failure, List<MessageThread>>> loadThreads() => _guard(
        'loadThreads',
        () async =>
            (await _source.fetchThreads()).map((m) => m.toEntity()).toList(),
      );

  @override
  Future<Either<Failure, List<ChatMessage>>> loadMessages(int threadId) =>
      _guard(
        'loadMessages',
        () async => (await _source.fetchMessages(threadId))
            .map((m) => m.toEntity())
            .toList(),
      );

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(int threadId, String body) =>
      _guard(
        'sendMessage',
        () async => (await _source.sendMessage(threadId, body)).toEntity(),
      );

  @override
  Future<Either<Failure, int>> markRead(int threadId, int lastMessageId) =>
      _guard('markRead', () => _source.markRead(threadId, lastMessageId));

  @override
  Future<Either<Failure, int>> unreadCount() =>
      _guard('unreadCount', () => _source.unreadCount());

  @override
  Future<Either<Failure, TimeProposal>> proposeTime({
    required int threadId,
    required int careTaskId,
    required DateTime start,
    required DateTime end,
    String? reason,
  }) =>
      _guard(
        'proposeTime',
        () async => (await _source.proposeTime(
          threadId: threadId,
          careTaskId: careTaskId,
          start: start,
          end: end,
          reason: reason,
        ))
            .toEntity(),
      );

  @override
  Future<Either<Failure, TimeProposal>> acceptProposal(
          int threadId, int proposalId) =>
      _guard(
        'acceptProposal',
        () async =>
            (await _source.acceptProposal(threadId, proposalId)).toEntity(),
      );

  @override
  Future<Either<Failure, TimeProposal>> chooseAnotherTime({
    required int threadId,
    required int proposalId,
    DateTime? preferred,
  }) =>
      _guard(
        'chooseAnotherTime',
        () async => (await _source.chooseAnotherTime(
          threadId: threadId,
          proposalId: proposalId,
          preferred: preferred,
        ))
            .toEntity(),
      );

  @override
  Future<Either<Failure, EstimateRevision>> approveEstimate(
          int threadId, int revisionId) =>
      _guard(
        'approveEstimate',
        () async =>
            (await _source.approveEstimate(threadId, revisionId)).toEntity(),
      );

  /// One place that turns a thrown thing into a `Failure`, so no cubit has to.
  Future<Either<Failure, T>> _guard<T>(
      String op, Future<T> Function() run) async {
    try {
      return Right(await run());
    } on DioException catch (e, stackTrace) {
      log('messaging $op failed',
          name: 'messaging.repo', error: e, stackTrace: stackTrace);
      return Left(_failureFrom(e));
    } catch (e, stackTrace) {
      log('messaging $op failed',
          name: 'messaging.repo', error: e, stackTrace: stackTrace);
      return const Left(
          ServerFailure('Something went wrong. Please try again.'));
    }
  }

  Failure _failureFrom(DioException e) {
    final status = e.response?.statusCode;
    // The server's own message is the useful one here: "That slot is no longer
    // free" beats anything this layer could invent.
    final message = e.response?.data is Map
        ? (e.response!.data['error'] as String?) ?? 'Request failed'
        : 'Request failed';

    return switch (status) {
      401 || 403 => UnauthorizedFailure(message),
      404 => NotFoundFailure(message),
      400 || 409 => BadRequestFailure(message),
      null => const NetworkFailure(
          'No connection. Check your network and try again.'),
      _ => ServerFailure(message),
    };
  }
}
