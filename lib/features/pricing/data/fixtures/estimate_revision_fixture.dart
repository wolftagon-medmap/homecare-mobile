/// A scripted revision per state, so the messaging feature can show a complete
/// exchange rather than an empty card. Keyed by care task id.
///
/// Prices come from the same catalogue as [kPriceTableFixture]: pressure ulcer
/// care at Aisyah Rahman's rate, plus two flat add-ons the assessment turned up.
const Map<int, List<Map<String, dynamic>>> kEstimateRevisionFixture =
    <int, List<Map<String, dynamic>>>{
  // Awaiting the patient — the card renders Approve / Decline.
  1: [
    {
      'id': 9001,
      'care_task_id': 1,
      'professional_id': 101,
      'status': 'proposed',
      'previous_total': 30.0,
      'note': 'The wound needs a dressing change and a glucose check as well.',
      'created_at': '2026-09-02T09:15:00.000Z',
      'responded_at': null,
      'lines': [
        {
          'code': 'nursing.specialized.pressure_ulcer_care',
          'label': 'Pressure Ulcer Care',
          'unit_price': 30.0,
          'quantity': 1,
          'amount': 30.0,
          'kind': 'base',
        },
        {
          'code': 'nursing.basic.blood_glucose_check',
          'label': 'Blood Glucose Check',
          'unit_price': 15.0,
          'quantity': 1,
          'amount': 15.0,
          'kind': 'add_on',
        },
      ],
    },
  ],
  // Already approved — the card renders as settled.
  2: [
    {
      'id': 9002,
      'care_task_id': 2,
      'professional_id': 105,
      'status': 'approved',
      'previous_total': 50.0,
      'note': 'Four hours rather than two, as discussed.',
      'created_at': '2026-09-01T14:02:00.000Z',
      'responded_at': '2026-09-01T14:20:00.000Z',
      'lines': [
        {
          'code': 'homecare_elderly.hourly_rate',
          'label': 'Homecare Hourly Rate',
          'unit_price': 30.0,
          'quantity': 4,
          'amount': 120.0,
          'kind': 'base',
        },
      ],
    },
  ],
};
