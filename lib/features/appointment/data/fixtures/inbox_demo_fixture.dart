// Inbox rows for the demo.
//
// Both inbox tabs read the live backend today. With `Feature.timeProposal`
// local these rows are merged in, and a failed call falls back to them instead
// of the red error state — otherwise the Pending tab is empty or broken unless
// someone is signed into a populated server, and the counter-propose story has
// nowhere to happen.
//
// Wire-shaped, parsed by the same `fromJson` the server response uses (C1).
// The moment the flag flips, none of this is reachable.
//
// It lives with the inbox rather than with messaging because these are
// `InboxItem` and `PatientInboxItem` rows — this feature's own contracts.

String _ahead(Duration from) =>
    DateTime.now().add(from).toUtc().toIso8601String();

String _tomorrowAt(int hour) {
  final now = DateTime.now();
  final day =
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  return day.add(Duration(hours: hour)).toUtc().toIso8601String();
}

/// Patient side: the "Alternative time proposed" card, matching thread 2
/// (Daniel Tan, care task 5002) so the inbox and the conversation agree.
List<Map<String, dynamic>> kPatientInboxDemoFixture() => [
      {
        'origin': 'care_task',
        'key': 'task:5002',
        'appointmentId': null,
        'careTaskId': 5002,
        'patientName': 'Ahmad Zulkifli',
        'serviceLabel': 'Home Nursing',
        'status': 'time_proposed',
        'statusLabel': 'Alternative proposed',
        'scheduledStart': _tomorrowAt(9),
        'scheduledEnd': _tomorrowAt(10),
        'provider': {
          'id': 102,
          'name': 'Daniel Tan',
          'avatar': null,
          'jobTitle': 'Registered Nurse',
        },
        'estimatedPrice': 30.0,
        'chiefComplaint': 'Pressure ulcer dressing, lower back',
        'proposal': {
          'proposalId': 3001,
          'proposedStart': _tomorrowAt(11),
          'proposedEnd': _tomorrowAt(12),
          'expiresAt': _ahead(const Duration(minutes: 18)),
          'reason':
              'Coming from a visit in Woodlands, 11am gives me a clear run.',
        },
      },
      {
        'origin': 'care_task',
        'key': 'task:5001',
        'appointmentId': null,
        'careTaskId': 5001,
        'patientName': 'Ahmad Zulkifli',
        'serviceLabel': 'Home Nursing',
        'status': 'matched',
        'statusLabel': 'Pending approval',
        'scheduledStart': _tomorrowAt(15),
        'scheduledEnd': _tomorrowAt(16),
        'provider': {
          'id': 101,
          'name': 'Aisyah Rahman',
          'avatar': null,
          'jobTitle': 'Registered Nurse',
        },
        'estimatedPrice': 30.0,
        'chiefComplaint': 'Pressure ulcer dressing, lower back',
      },
    ];

/// Professional side: an open offer carrying the `propose_time` action, so
/// "Suggest another time" has something to sit on.
List<Map<String, dynamic>> kProviderInboxDemoFixture() => [
      {
        'origin': 'v2_offer',
        'key': 'offer:5001',
        'title': 'Ahmad Zulkifli',
        'serviceLabel': 'Home Nursing',
        'summary': {
          'service':
              'Pressure ulcer dressing, lower back. Wound present ~3 weeks.',
          'patientLabel': 'Male, 74',
          'location': 'Blk 210 Ang Mo Kio Ave 3, #08-12',
          'risk': 'low',
        },
        'scheduledStart': _tomorrowAt(15),
        'scheduledEnd': _tomorrowAt(16),
        'estimatedIncome': 24.0,
        'expiresAt': _ahead(const Duration(minutes: 22)),
        'actions': [
          {
            'kind': 'accept',
            'entity': 'offer',
            'entityId': 5001,
            'requiresReason': false,
          },
          {
            'kind': 'propose_time',
            'entity': 'offer',
            'entityId': 5001,
            'requiresReason': false,
          },
          {
            'kind': 'decline',
            'entity': 'offer',
            'entityId': 5001,
            'requiresReason': false,
          },
        ],
      },
    ];
