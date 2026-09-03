import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/appointment/data/fixtures/inbox_demo_fixture.dart';
import 'package:m2health/features/appointment/data/models/patient_care_task_detail.dart';
import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';

/// `unmatched` is the one pending state that waits on the patient rather than
/// on a professional, and both surfaces branch on it to offer the way out. If
/// the status string ever drifts, those branches silently go back to being a
/// dead end — which is exactly the bug this fixes.
void main() {
  test('the demo inbox is ordered latest proposed visit first', () {
    final items =
        kPatientInboxDemoFixture().map(PatientInboxItem.fromJson).toList();
    final times = [
      for (final item in items)
        if (item.scheduledStart != null) item.scheduledStart!,
    ];

    // Mirrors the order the server sends, so the demo is not a different app.
    expect(times, hasLength(items.length));
    for (var i = 1; i < times.length; i++) {
      expect(times[i].isAfter(times[i - 1]), isFalse);
    }
  });

  test('the demo inbox still carries an unmatched booking', () {
    final items =
        kPatientInboxDemoFixture().map(PatientInboxItem.fromJson).toList();

    final unmatched = items.where((i) => i.isUnmatched).toList();
    expect(unmatched, hasLength(1));
    expect(unmatched.single.careTaskId, isNotNull,
        reason: 'the retry needs a care task to act on');
  });

  test('every other pending booking is waiting on someone else', () {
    final items =
        kPatientInboxDemoFixture().map(PatientInboxItem.fromJson).toList();

    for (final item in items.where((i) => !i.isUnmatched)) {
      expect(item.status, isNot('unmatched'));
    }
  });

  test('the detail agrees with the card about what unmatched means', () {
    final detail = PatientCareTaskDetail.fromJson(const {
      'careTaskId': 42,
      'status': 'unmatched',
      'statusLabel': 'No professional available',
      'serviceLabel': 'Home Nursing',
    });

    expect(detail.isUnmatched, isTrue);
  });
}
