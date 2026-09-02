import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/messaging/data/datasources/messaging_local_datasource.dart';
import 'package:m2health/features/messaging/data/repositories/messaging_repository_impl.dart';
import 'package:m2health/features/messaging/domain/entities/chat_message.dart';
import 'package:m2health/features/messaging/domain/entities/time_proposal.dart';
import 'package:m2health/features/messaging/presentation/bloc/thread_cubit.dart';
import 'package:m2health/features/messaging/presentation/bloc/thread_index_cubit.dart';
import 'package:m2health/features/messaging/domain/entities/message_thread.dart';

/// The demo has to survive being tapped through, not just rendered. These run
/// the local data source for real — no mocks — because what is being tested is
/// exactly that the scripted conversation responds.
void main() {
  ThreadCubit cubitFor(int threadId) => ThreadCubit(
      MessagingRepositoryImpl(MessagingLocalDataSource()), threadId);

  group('sending', () {
    test('a sent message appears in the thread', () async {
      final cubit = cubitFor(1);
      await cubit.load();
      final before = cubit.state.messages.length;

      await cubit.send('Thank you, see you tomorrow.');

      expect(cubit.state.messages, hasLength(before + 1));
      expect(cubit.state.messages.last.body, 'Thank you, see you tomorrow.');
      expect(cubit.state.sending, isFalse);
    });

    test('an empty message is ignored', () async {
      final cubit = cubitFor(1);
      await cubit.load();
      final before = cubit.state.messages.length;

      await cubit.send('   ');

      expect(cubit.state.messages, hasLength(before));
    });
  });

  group('accepting a proposal', () {
    test('flips the card and posts a system line', () async {
      final cubit = cubitFor(2);
      await cubit.load();

      final proposal = cubit.state.messages
          .firstWhere((m) => m.kind == MessageKind.timeProposal)
          .timeProposal!;
      expect(proposal.status, TimeProposalStatus.pending);

      await cubit.acceptProposal(proposal.proposalId);

      final after = cubit.state.messages
          .firstWhere((m) => m.kind == MessageKind.timeProposal)
          .timeProposal!;
      expect(after.status, TimeProposalStatus.accepted);
      expect(after.isOpen, isFalse);
      expect(cubit.state.messages.last.kind, MessageKind.system);
      expect(cubit.state.error, isNull);
    });
  });

  group('choosing another time', () {
    test('declines the card and records the time the patient asked for',
        () async {
      final cubit = cubitFor(2);
      await cubit.load();
      final proposal = cubit.state.messages
          .firstWhere((m) => m.kind == MessageKind.timeProposal)
          .timeProposal!;

      await cubit.chooseAnotherTime(
        proposal.proposalId,
        preferred: DateTime.now().add(const Duration(days: 2)),
      );

      final after = cubit.state.messages
          .firstWhere((m) => m.kind == MessageKind.timeProposal)
          .timeProposal!;
      expect(after.status, TimeProposalStatus.declined);
      expect(cubit.state.messages.last.kind, MessageKind.system);
    });
  });

  group('the professional proposing a time', () {
    test('adds an open card, and a second proposal withdraws the first',
        () async {
      final cubit = cubitFor(1);
      await cubit.load();

      final start = DateTime.now().add(const Duration(days: 1));
      await cubit.proposeTime(
        careTaskId: 5001,
        start: start,
        end: start.add(const Duration(hours: 1)),
        reason: 'Earlier suits my round better.',
      );

      var proposals = cubit.state.messages
          .where((m) => m.kind == MessageKind.timeProposal)
          .toList();
      expect(proposals, hasLength(1));
      expect(proposals.single.timeProposal!.isOpen, isTrue);

      final later = start.add(const Duration(hours: 3));
      await cubit.proposeTime(
        careTaskId: 5001,
        start: later,
        end: later.add(const Duration(hours: 1)),
      );

      proposals = cubit.state.messages
          .where((m) => m.kind == MessageKind.timeProposal)
          .toList();
      expect(proposals, hasLength(2));
      // Never two live proposals at once — the old one stands down only after
      // the replacement exists.
      expect(
        proposals.where((p) => p.timeProposal!.isOpen),
        hasLength(1),
      );
      expect(
          proposals.first.timeProposal!.status, TimeProposalStatus.withdrawn);
    });
  });

  group('approving an estimate', () {
    test('marks it approved and says so in the thread', () async {
      final cubit = cubitFor(4);
      await cubit.load();
      final revision = cubit.state.messages
          .firstWhere((m) => m.kind == MessageKind.estimateRevision)
          .estimateRevision!;

      await cubit.approveEstimate(revision.revisionId);

      final after = cubit.state.messages
          .firstWhere((m) => m.kind == MessageKind.estimateRevision)
          .estimateRevision!;
      expect(after.isPending, isFalse);
      expect(cubit.state.messages.last.kind, MessageKind.system);
      expect(cubit.state.messages.last.body, contains('45.00'));
    });
  });

  group('the thread index', () {
    test('resolves a care-task ref and a stale ref alike', () async {
      final cubit =
          ThreadIndexCubit(MessagingRepositoryImpl(MessagingLocalDataSource()));
      await cubit.load();

      expect(cubit.state.loaded, isTrue);
      expect(cubit.state.resolve(const ThreadRef.forCareTask(5001)), isNotNull);
      expect(
          cubit.state.resolve(const ThreadRef.forAppointment(7004)), isNotNull);
      // No thread means no button, which is what keeps a card from navigating
      // to a screen that is not there.
      expect(cubit.state.resolve(const ThreadRef.forCareTask(999999)), isNull);
    });

    test('counts unread across every thread', () async {
      final cubit =
          ThreadIndexCubit(MessagingRepositoryImpl(MessagingLocalDataSource()));
      await cubit.load();

      expect(cubit.state.totalUnread, 4);
    });
  });

  group('reading a thread', () {
    test('clears its unread count', () async {
      final source = MessagingLocalDataSource();
      final repository = MessagingRepositoryImpl(source);
      final index = ThreadIndexCubit(repository);
      await index.load();
      expect(index.state.resolve(const ThreadRef.forCareTask(5001))!.unread, 2);

      await ThreadCubit(repository, 1).load();
      await index.refresh();

      expect(index.state.resolve(const ThreadRef.forCareTask(5001))!.unread, 0);
    });
  });

  test('generated ids never collide with scripted ones', () async {
    final cubit = cubitFor(1);
    await cubit.load();
    await cubit.send('hello');

    expect(
      cubit.state.messages.last.id,
      greaterThan(MessagingLocalDataSource.highestFixtureId()),
    );
  });
}
