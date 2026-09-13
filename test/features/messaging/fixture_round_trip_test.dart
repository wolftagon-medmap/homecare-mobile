import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/appointment/data/fixtures/inbox_demo_fixture.dart';
import 'package:m2health/features/messaging/data/fixtures/thread_fixtures.dart';
import 'package:m2health/features/messaging/data/models/chat_message_model.dart';
import 'package:m2health/features/messaging/data/models/message_thread_model.dart';
import 'package:m2health/features/appointment/data/models/inbox_item.dart';
import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';
import 'package:m2health/features/messaging/domain/entities/chat_message.dart';
import 'package:m2health/features/messaging/domain/entities/estimate_revision.dart';
import 'package:m2health/features/messaging/domain/entities/time_proposal.dart';

/// C1 is the rule the backend swap depends on: every fixture must parse through
/// the same `fromJson` the remote path uses. This is the test that enforces it —
/// if a fixture ever drifts from the wire shape, it fails here rather than on
/// the day the flag flips.
void main() {
  group('thread fixtures round-trip through fromJson', () {
    test('every thread summary parses', () {
      final threads =
          kThreadListFixture().map(MessageThreadModel.fromJson).toList();

      expect(threads, hasLength(4));
      for (final thread in threads) {
        final entity = thread.toEntity();
        expect(entity.id, greaterThan(0));
        expect(entity.counterpart, isNotNull);
        expect(entity.serviceLabel, isNotEmpty);
        // The chat opens on this, so a thread that cannot say what it is about
        // is a blank screen.
        expect(entity.context.isEmpty, isFalse);
        expect(entity.context.issueLabels, isNotEmpty);
        expect(entity.context.location, isNotNull);
      }
    });

    test('every message in every thread parses', () {
      final scripts = kThreadMessagesFixture();

      expect(scripts.keys, containsAll(<int>[1, 2, 3, 4]));
      for (final entry in scripts.entries) {
        expect(entry.value, isNotEmpty, reason: 'thread ${entry.key} is empty');
        for (final row in entry.value) {
          final message = ChatMessageModel.fromJson(row).toEntity();
          expect(message.id, greaterThan(0));
          expect(message.threadId, entry.key);
        }
      }
    });

    test('toJson round-trips back to the same entity', () {
      final row = kThreadMessagesFixture()[4]!
          .firstWhere((m) => m['kind'] == 'estimate_revision');

      final once = ChatMessageModel.fromJson(row);
      final twice = ChatMessageModel.fromJson(once.toJson());

      expect(twice.toEntity(), once.toEntity());
    });
  });

  group('the scripted states each render what they promise', () {
    test('thread 1 is a plain conversation with no card', () {
      final messages = _entities(1);

      expect(messages.any((m) => m.kind == MessageKind.timeProposal), isFalse);
      expect(
          messages.any((m) => m.kind == MessageKind.estimateRevision), isFalse);
      // Both sides speak — the exhibit is a real exchange, not a monologue.
      expect(
          messages.map((m) => m.authorUserId).whereType<int>().toSet().length,
          2);
    });

    test('thread 2 carries an open proposal with time left on it', () {
      final proposal = _entities(2)
          .firstWhere((m) => m.kind == MessageKind.timeProposal)
          .timeProposal!;

      expect(proposal.status, TimeProposalStatus.pending);
      expect(proposal.isOpen, isTrue);
      expect(proposal.hasExpired, isFalse);
      expect(proposal.timeLeft, isNotNull);
      expect(proposal.originalStart, isNotNull);
      expect(proposal.proposedStart.isAfter(proposal.originalStart!), isTrue);
    });

    test('thread 3 is accepted and terminal', () {
      final messages = _entities(3);
      final proposal = messages
          .firstWhere((m) => m.kind == MessageKind.timeProposal)
          .timeProposal!;

      expect(proposal.status, TimeProposalStatus.accepted);
      expect(proposal.isOpen, isFalse);
      expect(messages.any((m) => m.kind == MessageKind.system), isTrue);
    });

    test('thread 4 has a pending estimate revision that adds one line', () {
      final revision = _entities(4)
          .firstWhere((m) => m.kind == MessageKind.estimateRevision)
          .estimateRevision!;

      expect(revision.status, EstimateRevisionStatus.pending);
      expect(revision.isPending, isTrue);
      expect(revision.lines, hasLength(2));
      expect(
        revision.lines.where((l) => l.change == EstimateLineChange.added),
        hasLength(1),
      );
    });

    test('the revision totals are the pricing table\'s, not this feature\'s',
        () {
      final revision = _entities(4)
          .firstWhere((m) => m.kind == MessageKind.estimateRevision)
          .estimateRevision!;

      // Professional 101's rate for service 13, plus add-on 1. These numbers
      // come from the pricing fixture table and nothing here recomputes them —
      // the card must render the payload's totals even if the lines disagree.
      expect(revision.currentTotal, 30.0);
      expect(revision.proposedTotal, 45.0);
      expect(revision.delta, 15.0);
    });
  });

  group('inbox demo fixtures parse through the shipped inbox contracts', () {
    test('patient rows parse, and one is awaiting an answer on a new time', () {
      final items =
          kPatientInboxDemoFixture().map(PatientInboxItem.fromJson).toList();

      expect(items, isNotEmpty);
      final proposed = items.where((i) => i.status == 'time_proposed').toList();
      expect(proposed, hasLength(1));
      expect(proposed.single.statusLabel, 'Alternative time proposed');
      expect(proposed.single.provider?.name, isNotNull);
      expect(proposed.single.careTaskId, isNotNull);
      expect(proposed.single.issueLabels, isNotEmpty);
    });

    test('one row is waiting on the patient because nobody took it', () {
      final unmatched = kPatientInboxDemoFixture()
          .map(PatientInboxItem.fromJson)
          .where((i) => i.status == 'unmatched')
          .toList();

      expect(unmatched, hasLength(1));
      expect(unmatched.single.provider, isNull);
      expect(unmatched.single.careTaskId, isNotNull);
    });

    test('the provider offer carries its issue labels', () {
      final item = kProviderInboxDemoFixture().map(InboxItem.fromJson).single;

      expect(item.summary.issueLabels, isNotEmpty);
    });

    test('the provider offer carries a propose_time action', () {
      final item = kProviderInboxDemoFixture().map(InboxItem.fromJson).single;

      expect(item.actionOfKind('propose_time'), isNotNull);
      expect(item.actionOfKind('accept'), isNotNull);
      expect(item.careTaskId, greaterThan(0));
    });
  });
}

List<ChatMessage> _entities(int threadId) => kThreadMessagesFixture()[threadId]!
    .map((row) => ChatMessageModel.fromJson(row).toEntity())
    .toList();
