import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/features/messaging/domain/entities/estimate_revision.dart';
import 'package:m2health/features/messaging/domain/entities/time_proposal.dart';
import 'package:m2health/features/messaging/presentation/widgets/estimate_revision_card.dart';
import 'package:m2health/features/messaging/presentation/widgets/time_proposal_card.dart';

/// The rule both cards live by: buttons appear only when the record is open
/// *and* the viewer is the one who answers it. A professional must never be
/// able to accept their own proposal.
void main() {
  // Both cards use A0's StatusPill and PricePill, which read the shared
  // namespace, so they need a TranslationProvider above them — same as the app.
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: child)),
          ),
        ),
      );

  TimeProposal proposal({
    TimeProposalStatus status = TimeProposalStatus.pending,
    Duration expiresIn = const Duration(minutes: 20),
  }) {
    final start = DateTime.now().add(const Duration(days: 1));
    return TimeProposal(
      proposalId: 1,
      careTaskId: 5002,
      status: status,
      originalStart: start,
      originalEnd: start.add(const Duration(hours: 1)),
      proposedStart: start.add(const Duration(hours: 2)),
      proposedEnd: start.add(const Duration(hours: 3)),
      reason: 'Coming from another visit.',
      expiresAt: DateTime.now().add(expiresIn),
      proposedByUserId: 902,
    );
  }

  group('TimeProposalCard', () {
    testWidgets('an open proposal offers both answers to the patient',
        (tester) async {
      await pump(
        tester,
        TimeProposalCard(proposal: proposal(), canRespond: true),
      );

      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Choose Another'), findsOneWidget);
      expect(find.text('Alternative time proposed'), findsOneWidget);
      expect(find.textContaining('held for'), findsOneWidget);
    });

    testWidgets('the professional who raised it gets no buttons',
        (tester) async {
      await pump(
        tester,
        TimeProposalCard(proposal: proposal(), canRespond: false),
      );

      expect(find.text('Accept'), findsNothing);
      expect(find.text('Choose Another'), findsNothing);
      expect(find.text('Alternative time proposed'), findsOneWidget);
    });

    testWidgets('an accepted proposal is terminal, buttons gone',
        (tester) async {
      await pump(
        tester,
        TimeProposalCard(
          proposal: proposal(status: TimeProposalStatus.accepted),
          canRespond: true,
        ),
      );

      expect(find.text('Accept'), findsNothing);
      expect(find.text('Accepted'), findsOneWidget);
    });

    testWidgets('an expired TTL closes the card even while status says pending',
        (tester) async {
      await pump(
        tester,
        TimeProposalCard(
          proposal: proposal(expiresIn: const Duration(minutes: -1)),
          canRespond: true,
        ),
      );

      // The hold has lapsed, so accepting it would promise a slot that is gone.
      expect(find.text('Accept'), findsNothing);
      expect(find.text('Expired'), findsOneWidget);
    });

    testWidgets('accepting calls back once', (tester) async {
      var taps = 0;
      await pump(
        tester,
        TimeProposalCard(
          proposal: proposal(),
          canRespond: true,
          onAccept: () => taps++,
        ),
      );

      await tester.tap(find.text('Accept'));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('a busy card cannot be double-tapped', (tester) async {
      var taps = 0;
      await pump(
        tester,
        TimeProposalCard(
          proposal: proposal(),
          canRespond: true,
          busy: true,
          onAccept: () => taps++,
        ),
      );

      await tester.tap(find.text('Accept'));
      await tester.pump();

      expect(taps, 0);
    });
  });

  EstimateRevision revision({
    EstimateRevisionStatus status = EstimateRevisionStatus.pending,
  }) =>
      EstimateRevision(
        revisionId: 4001,
        careTaskId: 5004,
        status: status,
        currency: r'$',
        currentTotal: 30,
        proposedTotal: 45,
        lines: const [
          EstimateLine(
            code: 'nursing.specialized.pressure_ulcer_care',
            label: 'Pressure Ulcer Care',
            amount: 30,
            change: EstimateLineChange.unchanged,
          ),
          EstimateLine(
            code: 'nursing.basic.blood_glucose_check',
            label: 'Blood Glucose Check',
            amount: 15,
            change: EstimateLineChange.added,
          ),
        ],
        note: 'Nothing is charged until the visit.',
      );

  group('EstimateRevisionCard', () {
    testWidgets('shows every line and the new total to the patient',
        (tester) async {
      await pump(
        tester,
        EstimateRevisionCard(revision: revision(), canApprove: true),
      );

      expect(find.text('Pressure Ulcer Care'), findsOneWidget);
      expect(find.text('Blood Glucose Check'), findsOneWidget);
      expect(find.text(r'$45'), findsOneWidget);
      expect(find.text('Approve'), findsOneWidget);
    });

    testWidgets('states the delta against the current total', (tester) async {
      await pump(
        tester,
        EstimateRevisionCard(revision: revision(), canApprove: true),
      );

      expect(find.text(r'up $15.00 from $30.00'), findsOneWidget);
    });

    testWidgets('renders the payload totals even when the lines disagree',
        (tester) async {
      // Pricing owns the arithmetic. If its total and its lines ever disagree,
      // the card must show the total it was given, not a sum of its own.
      const inconsistent = EstimateRevision(
        revisionId: 1,
        careTaskId: 1,
        status: EstimateRevisionStatus.pending,
        currency: r'$',
        currentTotal: 30,
        proposedTotal: 99,
        lines: [
          EstimateLine(
            code: 'x',
            label: 'One line',
            amount: 10,
            change: EstimateLineChange.unchanged,
          ),
        ],
        note: null,
      );

      await pump(
        tester,
        const EstimateRevisionCard(revision: inconsistent, canApprove: true),
      );

      expect(find.text(r'$99'), findsOneWidget);
    });

    testWidgets('the professional who proposed it cannot approve it',
        (tester) async {
      await pump(
        tester,
        EstimateRevisionCard(revision: revision(), canApprove: false),
      );

      expect(find.text('Approve'), findsNothing);
    });

    testWidgets('an approved revision shows its status and no button',
        (tester) async {
      await pump(
        tester,
        EstimateRevisionCard(
          revision: revision(status: EstimateRevisionStatus.approved),
          canApprove: true,
        ),
      );

      expect(find.text('Approve'), findsNothing);
      expect(find.text('Approved'), findsOneWidget);
    });
  });
}
