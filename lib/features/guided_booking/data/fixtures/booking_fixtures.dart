const List<Map<String, dynamic>> kVisitAddressesFixture = [
  {
    'id': 1,
    'latitude': 1.3521,
    'longitude': 103.8198,
    'google_place_id': 'fixture-home',
    'name': 'Home',
    'formatted_address': '12 Marina Boulevard, #08-03, Singapore 018982',
    'short_formatted_address': '12 Marina Boulevard',
    'label': 'Home',
    'is_default': true,
  },
  {
    'id': 2,
    'latitude': 1.3048,
    'longitude': 103.8318,
    'google_place_id': 'fixture-parents',
    'name': "Parents' House",
    'formatted_address': '450 Orchard Road, #12-01, Singapore 238878',
    'short_formatted_address': '450 Orchard Road',
    'label': "Parents' House",
    'is_default': false,
  },
  {
    'id': 3,
    'latitude': 1.4360,
    'longitude': 103.7860,
    'google_place_id': 'fixture-office',
    'name': 'Office',
    'formatted_address': '9 Woodlands Avenue 9, #03-11, Singapore 738964',
    'short_formatted_address': '9 Woodlands Avenue 9',
    'label': 'Office',
    'is_default': false,
  },
];

/// Ids and names are @pricing's six demo professionals (101-106). Changing an
/// id here silently breaks the price join, which fails as a missing pill rather
/// than an error.
const List<Map<String, dynamic>> kProfessionalsFixture = [
  {
    'id': 101,
    'name': 'Aisyah Rahman',
    'avatar': null,
    'job_title': 'Senior Registered Nurse',
    'rating': 4.9,
    'review_count': 128,
    'years_of_experience': 11,
    'categories': ['nursing', 'screening', 'diabetes_screening'],
    'served_address_ids': [1, 2],
  },
  {
    'id': 102,
    'name': 'Daniel Tan',
    'avatar': null,
    'job_title': 'Registered Nurse',
    'rating': 4.7,
    'review_count': 86,
    'years_of_experience': 8,
    'categories': ['nursing', 'diabetes_screening'],
    'served_address_ids': [1, 2, 3],
  },
  {
    'id': 103,
    'name': 'Priya Menon',
    'avatar': null,
    'job_title': 'Clinical Pharmacist',
    'rating': 4.8,
    'review_count': 64,
    'years_of_experience': 6,
    'categories': ['pharmacy', 'nutrition'],
    'served_address_ids': [1, 2],
  },
  {
    'id': 104,
    'name': 'Marcus Lee',
    'avatar': null,
    'job_title': 'Physiotherapist',
    'rating': 5.0,
    'review_count': 41,
    'years_of_experience': 14,
    'categories': ['physiotherapy', 'psychology'],
    'served_address_ids': [1, 2],
  },
  {
    'id': 105,
    'name': 'Siti Nurhaliza',
    'avatar': null,
    'job_title': 'Dietitian',
    'rating': 4.6,
    'review_count': 52,
    'years_of_experience': 5,
    'categories': ['nutrition', 'psychology', 'optometry'],
    'served_address_ids': [2],
  },
  {
    'id': 106,
    'name': 'Wei Chen',
    'avatar': null,
    'job_title': 'Optometrist',
    'rating': 4.8,
    'review_count': 73,
    'years_of_experience': 9,
    'categories': ['optometry', 'screening', 'diabetes_screening', 'pharmacy'],
    'served_address_ids': [1, 2],
  },
];

const List<Map<String, dynamic>> kAvailabilityFixture = [
  {
    'date': '2026-09-08',
    'slots': [
      {
        'start_time': '2026-09-08T09:00:00',
        'end_time': '2026-09-08T10:00:00',
        'is_available': true,
      },
      {
        'start_time': '2026-09-08T10:30:00',
        'end_time': '2026-09-08T11:30:00',
        'is_available': true,
      },
      {
        'start_time': '2026-09-08T14:00:00',
        'end_time': '2026-09-08T15:00:00',
        'is_available': false,
      },
      {
        'start_time': '2026-09-08T16:00:00',
        'end_time': '2026-09-08T17:00:00',
        'is_available': true,
      },
    ],
  },
  {
    'date': '2026-09-09',
    'slots': [
      {
        'start_time': '2026-09-09T09:30:00',
        'end_time': '2026-09-09T10:30:00',
        'is_available': true,
      },
      {
        'start_time': '2026-09-09T13:00:00',
        'end_time': '2026-09-09T14:00:00',
        'is_available': true,
      },
    ],
  },
  {
    'date': '2026-09-10',
    'slots': <Map<String, dynamic>>[],
  },
  {
    'date': '2026-09-11',
    'slots': [
      {
        'start_time': '2026-09-11T08:00:00',
        'end_time': '2026-09-11T09:00:00',
        'is_available': true,
      },
      {
        'start_time': '2026-09-11T11:00:00',
        'end_time': '2026-09-11T12:00:00',
        'is_available': true,
      },
      {
        'start_time': '2026-09-11T15:30:00',
        'end_time': '2026-09-11T16:30:00',
        'is_available': true,
      },
    ],
  },
  {
    'date': '2026-09-12',
    'slots': [
      {
        'start_time': '2026-09-12T10:00:00',
        'end_time': '2026-09-12T11:00:00',
        'is_available': true,
      },
      {
        'start_time': '2026-09-12T14:30:00',
        'end_time': '2026-09-12T15:30:00',
        'is_available': true,
      },
    ],
  },
];

const Map<String, dynamic> kSubmittedRequestFixture = {
  'id': 9001,
  'status': 'pending',
  'submitted_at': '2026-09-03T10:24:00',
  'professional_name': 'Aisyah Rahman',
  'preferred_at': '2026-09-08T09:00:00',
  'proposed_at': null,
};

const List<Map<String, dynamic>> kRequestStatusFixtures = [
  {
    'id': 9001,
    'status': 'pending',
    'submitted_at': '2026-09-03T10:24:00',
    'professional_name': 'Aisyah Rahman',
    'preferred_at': '2026-09-08T09:00:00',
    'proposed_at': null,
  },
  {
    'id': 9002,
    'status': 'accepted',
    'submitted_at': '2026-09-02T15:10:00',
    'professional_name': 'Daniel Tan',
    'preferred_at': '2026-09-09T09:30:00',
    'proposed_at': null,
  },
  {
    'id': 9003,
    'status': 'time_proposed',
    'submitted_at': '2026-09-02T09:05:00',
    'professional_name': 'Priya Menon',
    'preferred_at': '2026-09-08T10:30:00',
    'proposed_at': '2026-09-08T16:00:00',
  },
  {
    'id': 9004,
    'status': 'cancelled',
    'submitted_at': '2026-09-01T11:40:00',
    'professional_name': 'Marcus Lee',
    'preferred_at': '2026-09-05T13:00:00',
    'proposed_at': null,
  },
];
