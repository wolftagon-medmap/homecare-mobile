// Scripted conversations for the demo. Wire-shaped `Map`/`List` literals only —
// they go through the same `fromJson` the remote path uses (C1), so the backend
// swap costs nothing.
//
// People, service codes and prices are transcribed from the pricing fixture
// table (professionals 101-106) so the whole demo tells one story: the nurse in
// this conversation is the nurse on the professional card and in the estimate.
//
// Timestamps are relative to app start. A demo that hardcodes dates looks stale
// the moment it is shown a day later.

/// The signed-in patient, for the demo.
const int kDemoPatientUserId = 900;

/// Aisyah Rahman (professional 101, nursing) as a user id.
const int kDemoNurseUserId = 901;

/// Daniel Tan (professional 102, nursing).
const int kDemoNurse2UserId = 902;

/// Priya Menon (professional 103, pharmacy).
const int kDemoPharmacistUserId = 903;

String _at(Duration ago) =>
    DateTime.now().subtract(ago).toUtc().toIso8601String();

String _ahead(Duration from) =>
    DateTime.now().add(from).toUtc().toIso8601String();

/// Tomorrow at [hour]:00 local, as an ISO string — so a proposed slot always
/// reads as a real near-future time however long the branch sits unmerged.
String _tomorrowAt(int hour) {
  final now = DateTime.now();
  final day =
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  return day.add(Duration(hours: hour)).toUtc().toIso8601String();
}

List<Map<String, dynamic>> kThreadListFixture() => [
      {
        'id': 1,
        'careTaskId': 5001,
        'appointmentId': null,
        'status': 'open',
        'serviceLabel': 'Home Nursing',
        'counterpart': {
          'userId': kDemoNurseUserId,
          'name': 'Aisyah Rahman',
          'avatar': null,
          'role': 'professional',
        },
        'lastMessage': {
          'kind': 'text',
          'body':
              'Perfect, that tells me what I need. Let me check my afternoon.',
          'authorUserId': kDemoNurseUserId,
          'createdAt': _at(const Duration(minutes: 4)),
        },
        'context': {
          'issueLabels': ['Wound care'],
          'location': '18 Spottiswoode Park Rd, Singapore 088642',
          'estimatedPrice': 24.0,
        },
        'unread': 2,
        'lastMessageAt': _at(const Duration(minutes: 4)),
      },
      {
        'id': 2,
        'careTaskId': 5002,
        'appointmentId': null,
        'status': 'open',
        'serviceLabel': 'Home Nursing',
        'counterpart': {
          'userId': kDemoNurse2UserId,
          'name': 'Daniel Tan',
          'avatar': null,
          'role': 'professional',
        },
        'lastMessage': {
          'kind': 'time_proposal',
          'body': null,
          'authorUserId': kDemoNurse2UserId,
          'createdAt': _at(const Duration(minutes: 12)),
        },
        'context': {
          'issueLabels': ['Injection', 'Vital signs'],
          'location': '1E Kent Ridge Rd, Singapore 119228',
          'estimatedPrice': 30.0,
        },
        'unread': 1,
        'lastMessageAt': _at(const Duration(minutes: 12)),
      },
      {
        'id': 3,
        'careTaskId': 5003,
        'appointmentId': 7003,
        'status': 'open',
        'serviceLabel': 'Pharmacist Review',
        'counterpart': {
          'userId': kDemoPharmacistUserId,
          'name': 'Priya Menon',
          'avatar': null,
          'role': 'professional',
        },
        'lastMessage': {
          'kind': 'system',
          'body': 'New time agreed: tomorrow, 14:00-15:00.',
          'authorUserId': null,
          'createdAt': _at(const Duration(hours: 3)),
        },
        'context': {
          'issueLabels': ['Medication side effects'],
          'location': '18 Spottiswoode Park Rd, Singapore 088642',
          'estimatedPrice': 13.0,
        },
        'unread': 0,
        'lastMessageAt': _at(const Duration(hours: 3)),
      },
      {
        'id': 4,
        'careTaskId': 5004,
        'appointmentId': 7004,
        'status': 'open',
        'serviceLabel': 'Home Nursing',
        'counterpart': {
          'userId': kDemoNurseUserId,
          'name': 'Aisyah Rahman',
          'avatar': null,
          'role': 'professional',
        },
        'lastMessage': {
          'kind': 'estimate_revision',
          'body': null,
          'authorUserId': kDemoNurseUserId,
          'createdAt': _at(const Duration(minutes: 26)),
        },
        'context': {
          'issueLabels': ['Wound care'],
          'location': '30 Kelantan Ln, Singapore 208652',
          'estimatedPrice': 24.0,
        },
        'unread': 1,
        'lastMessageAt': _at(const Duration(minutes: 26)),
      },
    ];

/// Thread 1 — `pending`. The nurse has not accepted yet, and is asking the two
/// questions that would otherwise have to sit on the intake form. This is the
/// exhibit for why the form is short.
List<Map<String, dynamic>> _thread1() => [
      {
        'id': 101,
        'threadId': 1,
        'kind': 'system',
        'body': 'You can message Aisyah while she reviews your request.',
        'authorUserId': null,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 22)),
      },
      {
        'id': 102,
        'threadId': 1,
        'kind': 'text',
        'body':
            'Hi, I saw your request for pressure ulcer care. Before I accept — how long has the wound been there?',
        'authorUserId': kDemoNurseUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 18)),
      },
      {
        'id': 103,
        'threadId': 1,
        'kind': 'text',
        'body':
            'About three weeks now. It was dressed at the clinic last Tuesday.',
        'authorUserId': kDemoPatientUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 14)),
      },
      {
        'id': 104,
        'threadId': 1,
        'kind': 'text',
        'body':
            'Is there a lift in the building? I carry a fair amount of kit.',
        'authorUserId': kDemoNurseUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 9)),
      },
      {
        'id': 105,
        'threadId': 1,
        'kind': 'text',
        'body': 'Yes, lift goes to the 8th floor. Unit 8-12.',
        'authorUserId': kDemoPatientUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 6)),
      },
      {
        'id': 106,
        'threadId': 1,
        'kind': 'text',
        'body':
            'Perfect, that tells me what I need. Let me check my afternoon.',
        'authorUserId': kDemoNurseUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 4)),
      },
    ];

/// Thread 2 — `time_proposed`. The card is live and the patient has not answered.
List<Map<String, dynamic>> _thread2() => [
      {
        'id': 201,
        'threadId': 2,
        'kind': 'system',
        'body': 'You can message Daniel while he reviews your request.',
        'authorUserId': null,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 40)),
      },
      {
        'id': 202,
        'threadId': 2,
        'kind': 'text',
        'body':
            'Morning. I can definitely take this, but 9am tomorrow is tight — I have a visit in Woodlands right before.',
        'authorUserId': kDemoNurse2UserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 20)),
      },
      {
        'id': 203,
        'threadId': 2,
        'kind': 'text',
        'body': 'No problem, we are flexible. What suits you?',
        'authorUserId': kDemoPatientUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 16)),
      },
      {
        'id': 204,
        'threadId': 2,
        'kind': 'time_proposal',
        'body': null,
        'authorUserId': kDemoNurse2UserId,
        'payload': {
          'proposalId': 3001,
          'careTaskId': 5002,
          'status': 'pending',
          'originalStart': _tomorrowAt(9),
          'originalEnd': _tomorrowAt(10),
          'proposedStart': _tomorrowAt(11),
          'proposedEnd': _tomorrowAt(12),
          'reason':
              'Coming from a visit in Woodlands, 11am gives me a clear run.',
          'expiresAt': _ahead(const Duration(minutes: 18)),
          'proposedByUserId': kDemoNurse2UserId,
        },
        'createdAt': _at(const Duration(minutes: 12)),
      },
    ];

/// Thread 3 — `accepted`. The card is terminal and a system line records it.
List<Map<String, dynamic>> _thread3() => [
      {
        'id': 301,
        'threadId': 3,
        'kind': 'text',
        'body':
            'Hello — I have your medication list. Could we push to the afternoon so I can review it properly first?',
        'authorUserId': kDemoPharmacistUserId,
        'payload': null,
        'createdAt': _at(const Duration(hours: 5)),
      },
      {
        'id': 302,
        'threadId': 3,
        'kind': 'time_proposal',
        'body': null,
        'authorUserId': kDemoPharmacistUserId,
        'payload': {
          'proposalId': 3002,
          'careTaskId': 5003,
          'status': 'accepted',
          'originalStart': _tomorrowAt(10),
          'originalEnd': _tomorrowAt(11),
          'proposedStart': _tomorrowAt(14),
          'proposedEnd': _tomorrowAt(15),
          'reason': 'Gives me time to go through the full list beforehand.',
          'expiresAt': null,
          'proposedByUserId': kDemoPharmacistUserId,
        },
        'createdAt': _at(const Duration(hours: 4)),
      },
      {
        'id': 303,
        'threadId': 3,
        'kind': 'system',
        'body': 'New time agreed: tomorrow, 14:00-15:00.',
        'authorUserId': null,
        'payload': null,
        'createdAt': _at(const Duration(hours: 3)),
      },
      {
        'id': 304,
        'threadId': 3,
        'kind': 'text',
        'body': 'That works, thank you. See you then.',
        'authorUserId': kDemoPatientUserId,
        'payload': null,
        'createdAt': _at(const Duration(hours: 3)),
      },
    ];

/// Thread 4 — `estimate_revised`. Confirmed visit; the nurse has assessed over
/// chat and proposes adding one add-on.
///
/// The numbers come straight from the pricing fixture table and are not
/// calculated here: professional 101's rate for service 13 (Pressure Ulcer Care)
/// is 30.00 against a 25.00 floor, and add-on 1 (Blood Glucose Check) is 15.00.
List<Map<String, dynamic>> _thread4() => [
      {
        'id': 401,
        'threadId': 4,
        'kind': 'system',
        'body': 'Visit confirmed for tomorrow, 15:00-16:00.',
        'authorUserId': null,
        'payload': null,
        'createdAt': _at(const Duration(hours: 2)),
      },
      {
        'id': 402,
        'threadId': 4,
        'kind': 'text',
        'body':
            'Thanks for the photos. The wound looks fine, but your father mentioned feeling faint in the mornings — I would like to check his glucose while I am there.',
        'authorUserId': kDemoNurseUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 34)),
      },
      {
        'id': 403,
        'threadId': 4,
        'kind': 'text',
        'body': 'Yes please, that has been worrying us. Does it cost extra?',
        'authorUserId': kDemoPatientUserId,
        'payload': null,
        'createdAt': _at(const Duration(minutes: 30)),
      },
      {
        'id': 404,
        'threadId': 4,
        'kind': 'estimate_revision',
        'body': null,
        'authorUserId': kDemoNurseUserId,
        'payload': {
          'revisionId': 4001,
          'careTaskId': 5004,
          'status': 'pending',
          'currency': r'$',
          'currentTotal': 30.0,
          'proposedTotal': 45.0,
          'lines': [
            {
              'code': 'nursing.specialized.pressure_ulcer_care',
              'label': 'Pressure Ulcer Care',
              'amount': 30.0,
              'change': 'unchanged',
            },
            {
              'code': 'nursing.basic.blood_glucose_check',
              'label': 'Blood Glucose Check',
              'amount': 15.0,
              'change': 'added',
            },
          ],
          'note':
              'Only if you are happy with it — nothing is charged until the visit.',
        },
        'createdAt': _at(const Duration(minutes: 26)),
      },
    ];

/// Every scripted conversation, keyed by thread id.
Map<int, List<Map<String, dynamic>>> kThreadMessagesFixture() => {
      1: _thread1(),
      2: _thread2(),
      3: _thread3(),
      4: _thread4(),
    };
