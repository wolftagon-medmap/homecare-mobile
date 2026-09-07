import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/pricing/data/datasources/estimate_revision_datasource.dart';
import 'package:m2health/features/pricing/data/fixtures/estimate_revision_fixture.dart';
import 'package:m2health/features/pricing/data/models/estimate_revision_model.dart';
import 'package:m2health/features/pricing/domain/entities/estimate.dart';
import 'package:m2health/features/pricing/domain/entities/estimate_revision.dart';

void main() {
  group('the revision fixture round-trips through fromJson', () {
    test('every scripted revision parses', () {
      for (final rows in kEstimateRevisionFixture.values) {
        for (final row in rows) {
          final revision = EstimateRevisionModel.fromJson(row);
          expect(revision.estimate.lines, isNotEmpty);
          expect(revision.proposedTotal, greaterThan(0));
        }
      }
    });

    test('a line total matches its own arithmetic', () {
      final revision = EstimateRevisionModel.fromJson(
        kEstimateRevisionFixture[2]!.single,
      );
      final line = revision.estimate.lines.single;

      expect(line.quantity, 4);
      expect(line.amount, line.unitPrice * line.quantity);
      expect(revision.proposedTotal, 120);
    });

    test('the demo covers both an open and a settled revision', () {
      expect(
        EstimateRevisionModel.fromJson(kEstimateRevisionFixture[1]!.single)
            .awaitingPatient,
        isTrue,
      );
      expect(
        EstimateRevisionModel.fromJson(kEstimateRevisionFixture[2]!.single)
            .status,
        EstimateRevisionStatus.approved,
      );
    });

    test('an add-on line is tagged as one', () {
      final revision = EstimateRevisionModel.fromJson(
        kEstimateRevisionFixture[1]!.single,
      );

      expect(revision.estimate.addOnLines, hasLength(1));
      expect(revision.estimate.baseLines, hasLength(1));
      expect(revision.estimate.lines.last.kind, EstimateLineKind.addOn);
    });

    test('the difference against the previous estimate is the delta', () {
      final revision = EstimateRevisionModel.fromJson(
        kEstimateRevisionFixture[1]!.single,
      );

      expect(revision.previousTotal, 30);
      expect(revision.difference, 15);
    });
  });

  group('the local data source', () {
    test('a care task with no revision returns none', () async {
      final source = EstimateRevisionLocalDataSource();
      expect(await source.forCareTask(999), isEmpty);
    });

    test('approving moves the record and it stays moved', () async {
      final source = EstimateRevisionLocalDataSource();
      final open = (await source.forCareTask(1)).single;
      expect(open.awaitingPatient, isTrue);

      final approved = await source.approve(open.id);
      expect(approved.status, EstimateRevisionStatus.approved);
      expect(approved.respondedAt, isNotNull);

      final reloaded = (await source.forCareTask(1)).single;
      expect(reloaded.status, EstimateRevisionStatus.approved);
    });

    test('declining is recorded the same way', () async {
      final source = EstimateRevisionLocalDataSource();
      final open = (await source.forCareTask(1)).single;

      final rejected = await source.reject(open.id);
      expect(rejected.status, EstimateRevisionStatus.rejected);
      expect(rejected.awaitingPatient, isFalse);
    });

    test('two sources do not share answers', () async {
      final first = EstimateRevisionLocalDataSource();
      final second = EstimateRevisionLocalDataSource();
      final open = (await first.forCareTask(1)).single;
      await first.approve(open.id);

      expect((await second.forCareTask(1)).single.awaitingPatient, isTrue);
    });
  });
}
