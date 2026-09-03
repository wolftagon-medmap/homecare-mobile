import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/messaging/thread_index_cubit.dart';
import 'package:m2health/core/messaging/thread_index_source.dart';
import 'package:m2health/core/messaging/thread_ref.dart';
import 'package:m2health/features/messaging/data/datasources/messaging_local_datasource.dart';
import 'package:m2health/features/messaging/data/datasources/thread_stream.dart';
import 'package:m2health/features/messaging/data/repositories/messaging_repository_impl.dart';
import 'package:m2health/features/messaging/data/thread_index_adapter.dart';
import 'package:m2health/features/messaging/domain/entities/chat_message.dart';
import 'package:m2health/features/messaging/domain/entities/estimate_revision.dart';
import 'package:m2health/features/messaging/domain/entities/message_thread.dart';
import 'package:m2health/features/messaging/domain/entities/time_proposal.dart';
import 'package:m2health/features/messaging/domain/entities/thread_event.dart';
import 'package:m2health/features/messaging/domain/repositories/messaging_repository.dart';
import 'package:m2health/features/messaging/presentation/bloc/thread_activity_hub.dart';
import 'package:m2health/features/messaging/presentation/bloc/thread_cubit.dart';
import 'package:m2health/features/messaging/presentation/bloc/thread_list_cubit.dart';

class _FakeStream implements ThreadStream {
  final StreamController<ThreadEvent> _controller =
      StreamController<ThreadEvent>.broadcast();

  int connects = 0;
  int disconnects = 0;

  void push(ThreadEvent event) => _controller.add(event);

  @override
  Stream<ThreadEvent> get events => _controller.stream;

  @override
  Future<void> connect() async => connects++;

  @override
  Future<void> disconnect() async => disconnects++;
}

class _CountingRepository implements MessagingRepository {
  final MessagingRepository _inner;

  _CountingRepository(this._inner);

  int threadLoads = 0;

  @override
  Future<Either<Failure, List<MessageThread>>> loadThreads() {
    threadLoads++;
    return _inner.loadThreads();
  }

  @override
  Future<Either<Failure, ChatMessagePage>> loadMessages(int threadId) =>
      _inner.loadMessages(threadId);

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(int threadId, String body) =>
      _inner.sendMessage(threadId, body);

  @override
  Future<Either<Failure, int>> markRead(int threadId, int lastMessageId) =>
      _inner.markRead(threadId, lastMessageId);

  @override
  Future<Either<Failure, int>> unreadCount() => _inner.unreadCount();

  @override
  Future<Either<Failure, TimeProposal>> proposeTime({
    required int threadId,
    required int careTaskId,
    required DateTime start,
    required DateTime end,
    String? reason,
  }) =>
      _inner.proposeTime(
        threadId: threadId,
        careTaskId: careTaskId,
        start: start,
        end: end,
        reason: reason,
      );

  @override
  Future<Either<Failure, TimeProposal>> acceptProposal(
          int threadId, int proposalId) =>
      _inner.acceptProposal(threadId, proposalId);

  @override
  Future<Either<Failure, TimeProposal>> chooseAnotherTime({
    required int threadId,
    required int proposalId,
    DateTime? preferred,
  }) =>
      _inner.chooseAnotherTime(
        threadId: threadId,
        proposalId: proposalId,
        preferred: preferred,
      );

  @override
  Future<Either<Failure, EstimateRevision>> approveEstimate(
          int threadId, int revisionId) =>
      _inner.approveEstimate(threadId, revisionId);
}

class _CountingIndexSource implements ThreadIndexSource {
  final ThreadIndexSource _inner;

  _CountingIndexSource(this._inner);

  int loads = 0;

  @override
  Future<List<ThreadEntry>> loadThreadIndex() {
    loads++;
    return _inner.loadThreadIndex();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MessagingRepositoryImpl repository() =>
      MessagingRepositoryImpl(MessagingLocalDataSource());

  // The local data source deliberately fakes 220ms of latency, so a reload is
  // not observable any sooner than that.
  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 400));

  group('frame parsing', () {
    test('reads an activity frame carrying a message id', () {
      final event = ThreadEvent.parseFrame(
          '{"type":"activity","threadId":12,"messageId":481}');

      expect(event, isNotNull);
      expect(event!.threadId, 12);
      expect(event.messageId, 481);
    });

    test('reads a card refresh, which carries no message id', () {
      final event = ThreadEvent.parseFrame(
          '{"type":"activity","threadId":12,"messageId":null}');

      expect(event, isNotNull);
      expect(event!.threadId, 12);
      expect(event.messageId, isNull);
    });

    test('ignores the ready handshake, unknown types and malformed json', () {
      expect(ThreadEvent.parseFrame('{"type":"ready","threadIds":[12,13]}'),
          isNull);
      expect(ThreadEvent.parseFrame('{"type":"typing","threadId":12}'), isNull);
      expect(ThreadEvent.parseFrame('not json at all'), isNull);
      expect(ThreadEvent.parseFrame('[]'), isNull);
      expect(ThreadEvent.parseFrame('{"type":"activity"}'), isNull);
    });
  });

  group('ThreadCubit on a frame', () {
    test('reloads for its own thread and leaves other threads alone', () async {
      final repo = repository();
      final stream = _FakeStream();
      final mine = ThreadCubit(repo, 1, activity: stream.events);
      await mine.load();
      final before = mine.state.messages.length;

      // Written through a second cubit on the SAME store, so a frame is the
      // only thing that could tell `mine` about it.
      await ThreadCubit(repo, 1).send('Arrived over the socket.');

      stream.push(const ThreadEvent(threadId: 2));
      await settle();
      expect(mine.state.messages, hasLength(before));

      stream.push(const ThreadEvent(threadId: 1, messageId: 999));
      await settle();
      expect(mine.state.messages, hasLength(before + 1));
      expect(mine.state.messages.last.body, 'Arrived over the socket.');
    });

    test('reloading never shows the spinner', () async {
      final stream = _FakeStream();
      final cubit = ThreadCubit(repository(), 1, activity: stream.events);
      await cubit.load();

      final loadings = <bool>[];
      final sub = cubit.stream.listen((s) => loadings.add(s.loading));
      stream.push(const ThreadEvent(threadId: 1));
      await settle();
      await sub.cancel();

      expect(loadings, isNot(contains(true)));
    });
  });

  group('ThreadListCubit on a frame', () {
    test('reloads without dropping back to the loading state', () async {
      final repo = _CountingRepository(repository());
      final stream = _FakeStream();
      final cubit = ThreadListCubit(repo, activity: stream.events);
      await cubit.load();
      expect(cubit.state, isA<ThreadListLoaded>());
      expect(repo.threadLoads, 1);

      final states = <ThreadListState>[];
      final sub = cubit.stream.listen(states.add);
      stream.push(const ThreadEvent(threadId: 1));
      await settle();
      await sub.cancel();

      expect(repo.threadLoads, 2);
      // The list is already on screen; a live reload must never blank it.
      expect(states.whereType<ThreadListLoading>(), isEmpty);
      expect(cubit.state, isA<ThreadListLoaded>());
    });
  });

  group('ThreadActivityHub', () {
    test('fans one upstream frame out to several listeners', () async {
      final stream = _FakeStream();
      final hub = ThreadActivityHub(
          stream, ThreadIndexCubit(ThreadIndexAdapter(repository())));
      await hub.start();

      final first = <int>[];
      final second = <int>[];
      final a = hub.events.listen((e) => first.add(e.threadId));
      final b = hub.events.listen((e) => second.add(e.threadId));

      stream.push(const ThreadEvent(threadId: 7));
      await settle();
      await a.cancel();
      await b.cancel();
      await hub.stop();

      expect(first, [7]);
      expect(second, [7]);
      expect(stream.connects, 1);
      expect(stream.disconnects, 1);
    });

    test('a burst of frames costs one index reload, not one each', () async {
      final source = _CountingIndexSource(ThreadIndexAdapter(repository()));
      final stream = _FakeStream();
      final hub = ThreadActivityHub(stream, ThreadIndexCubit(source));
      await hub.start();
      source.loads = 0;

      await Future(() {
        for (var i = 0; i < 12; i++) {
          stream.push(ThreadEvent(threadId: 1, messageId: i));
        }
      });
      await settle();
      expect(source.loads, 0, reason: 'debounced, so nothing has fired yet');

      await Future<void>.delayed(
          ThreadActivityHub.indexDebounce + const Duration(milliseconds: 600));
      await hub.stop();

      expect(source.loads, 1);
    });

    test('the index reload actually clears the badge', () async {
      final repo = repository();
      final index = ThreadIndexCubit(ThreadIndexAdapter(repo));
      await index.load();
      expect(index.state.resolve(const ThreadRef.forCareTask(5001))!.unread, 2);

      final stream = _FakeStream();
      final hub = ThreadActivityHub(stream, index);
      await hub.start();
      await ThreadCubit(repo, 1).load();

      stream.push(const ThreadEvent(threadId: 1));
      await Future<void>.delayed(
          ThreadActivityHub.indexDebounce + const Duration(milliseconds: 600));
      await hub.stop();

      expect(index.state.resolve(const ThreadRef.forCareTask(5001))!.unread, 0);
    });
  });

  group('the local stream', () {
    test('is inert, so the app behaves exactly as it does with the flag off',
        () async {
      final local = ThreadStreamLocal();
      await local.connect();

      expect(await local.events.isEmpty, isTrue);

      await local.disconnect();
    });
  });
}
