// Wire-shaped inbox rows, parsed by the same `fromJson` the server response
// uses (C1). With `Feature.timeProposal` local these are the only rows either
// inbox shows; the moment the flag flips, none of this is reachable.

String _at(Duration ago) =>
    DateTime.now().subtract(ago).toUtc().toIso8601String();

String _ahead(Duration from) =>
    DateTime.now().add(from).toUtc().toIso8601String();

String _tomorrowAt(int hour) {
  final now = DateTime.now();
  final day =
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  return day.add(Duration(hours: hour)).toUtc().toIso8601String();
}

/// Patient side. The `time_proposed` row matches thread 2 (Daniel Tan, care
/// task 5002) so the card and the conversation agree — the card states the
/// professional is waiting; the thread carries the reason and the decision.
/// The `unmatched` row is the other state the patient has to answer: nobody
/// took it, and it is waiting on them rather than cancelled.
List<Map<String, dynamic>> kPatientInboxDemoFixture() => [
      {
        'createdAt': _at(const Duration(minutes: 12)),
        'key': 'task:5001',
        'careTaskId': 5001,
        'patientName': 'Ahmad Zulkifli',
        'serviceLabel': 'Home Nursing',
        'status': 'matched',
        'statusLabel': 'Awaiting confirmation',
        'scheduledStart': _tomorrowAt(15),
        'scheduledEnd': _tomorrowAt(16),
        'provider': {
          'id': 101,
          'name': 'Aisyah Rahman',
          'avatar': null,
          'jobTitle': 'Registered Nurse',
        },
        'estimatedPrice': 30.0,
        'remarks': 'Pressure ulcer dressing, lower back',
        'issueLabels': ['Wound care', 'Dressing change'],
      },
      {
        'createdAt': _at(const Duration(hours: 3)),
        'key': 'task:5002',
        'careTaskId': 5002,
        'patientName': 'Ahmad Zulkifli',
        'serviceLabel': 'Home Nursing',
        'status': 'time_proposed',
        'statusLabel': 'Alternative time proposed',
        'scheduledStart': _tomorrowAt(9),
        'scheduledEnd': _tomorrowAt(10),
        'provider': {
          'id': 102,
          'name': 'Daniel Tan',
          'avatar': null,
          'jobTitle': 'Registered Nurse',
        },
        'estimatedPrice': 30.0,
        'remarks': 'Pressure ulcer dressing, lower back',
        'issueLabels': ['Wound care', 'Dressing change'],
      },
      {
        'createdAt': _at(const Duration(days: 2)),
        'key': 'task:5003',
        'careTaskId': 5003,
        'patientName': 'Ahmad Zulkifli',
        'serviceLabel': 'Physiotherapy',
        'status': 'unmatched',
        'statusLabel': 'No professional available',
        'scheduledStart': _tomorrowAt(8),
        'scheduledEnd': _tomorrowAt(9),
        'provider': null,
        'estimatedPrice': 45.0,
        'remarks': 'Post-op knee mobility, week 2',
        'issueLabels': ['Post-surgery rehab'],
      },
    ];

/// Professional side: an open offer carrying the `propose_time` action, so
/// "Suggest another time" has something to sit on.
List<Map<String, dynamic>> kProviderInboxDemoFixture() => [
      {
        'key': 'offer:5001',
        'careTaskId': 5001,
        'title': 'Ahmad Zulkifli',
        'serviceLabel': 'Home Nursing',
        'summary': {
          'service':
              'Pressure ulcer dressing, lower back. Wound present ~3 weeks.',
          'issueLabels': ['Wound care', 'Dressing change'],
          'patientLabel': 'Male, 74',
          'location': 'Blk 210 Ang Mo Kio Ave 3, #08-12',
          'risk': 'low',
        },
        'scheduledStart': _tomorrowAt(15),
        'scheduledEnd': _tomorrowAt(16),
        'estimatedIncome': 24.0,
        'expiresAt': _ahead(const Duration(minutes: 22)),
        'actions': [
          {'kind': 'accept', 'requiresReason': false},
          {'kind': 'propose_time', 'requiresReason': false},
          {'kind': 'decline', 'requiresReason': false},
        ],
      },
    ];
