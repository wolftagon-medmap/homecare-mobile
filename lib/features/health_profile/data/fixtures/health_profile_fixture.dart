/// Wording is transcribed verbatim from `m2Health App Suggestions.pdf` pp.6-8
/// and must not be paraphrased. Mirrors the backend's
/// `app/modules/health_profile/config/health_profile_sections.ts`.
const kHealthProfileSectionsFixture = <Map<String, dynamic>>[
  {
    'code': 'my_health',
    'title': 'My Health',
    'description':
        'Conditions we should know about, and anything you want to add.',
    'opens_route': null,
    'questions': [
      {
        'code': 'conditions',
        'text': 'Do you have any of the following conditions?',
        'type': 'multi_choice',
        'allows_custom': true,
        'custom_label': 'Add another condition',
        'options': [
          {'code': 'high_blood_pressure', 'label': 'High Blood Pressure'},
          {'code': 'high_cholesterol', 'label': 'High Cholesterol'},
          {'code': 'diabetes', 'label': 'Diabetes'},
          {'code': 'kidney_disease', 'label': 'Kidney Disease'},
          {'code': 'heart_disease', 'label': 'Heart Disease'},
          {
            'code': 'no_known_conditions',
            'label': "I don't have any known conditions",
            'exclusive': true,
          },
          {'code': 'not_sure', 'label': "I'm not sure", 'exclusive': true},
        ],
      },
      {
        'code': 'notes',
        'text': "Anything else you'd like to add?",
        'type': 'long_text',
        'hint': 'Optional. You can also attach reports.',
        'allows_attachments': true,
      },
    ],
  },
  {
    'code': 'my_lifestyle',
    'title': 'My Lifestyle',
    'description': 'Smoking, exercise and diet.',
    'opens_route': null,
    'questions': [
      {
        'code': 'smoke_or_vape',
        'text': 'Do you currently smoke or vape?',
        'type': 'single_choice',
        'options': [
          {'code': 'no', 'label': 'No'},
          {'code': 'occasionally', 'label': 'Occasionally'},
          {'code': 'daily', 'label': 'Daily'},
          {'code': 'previously_stopped', 'label': 'Previously, but stopped'},
          {'code': 'prefer_not_to_say', 'label': 'Prefer not to say'},
        ],
      },
      {
        'code': 'cigarettes_per_day',
        'text': 'How many cigarettes do you typically smoke per day?',
        'type': 'single_choice',
        'enable_when': {
          'question': 'smoke_or_vape',
          'not_in': ['no', 'prefer_not_to_say'],
        },
        'options': [
          {'code': '1_5', 'label': '1–5 sticks'},
          {'code': '6_10', 'label': '6–10 sticks'},
          {'code': '11_20', 'label': '11–20 sticks'},
          {'code': 'more_than_20', 'label': 'More than 20 sticks'},
          {'code': 'prefer_not_to_say', 'label': 'Prefer not to say'},
        ],
      },
      {
        'code': 'activity_level',
        'text': 'How active are you in a typical week?',
        'type': 'single_choice',
        'group': 'Exercise',
        'options': [
          {'code': 'mostly_inactive', 'label': 'Mostly inactive'},
          {'code': 'light_activity', 'label': 'Light activity'},
          {'code': 'moderate_exercise', 'label': 'Moderate exercise'},
          {'code': 'very_active', 'label': 'Very active'},
          {'code': 'not_sure', 'label': "I'm not sure"},
        ],
      },
      {
        'code': 'activities',
        'text': 'What activities do you usually do?',
        'type': 'chip_multi_choice',
        'allows_custom': true,
        'custom_label': 'Other',
        'options': [
          {'code': 'walking', 'label': 'Walking'},
          {'code': 'gym', 'label': 'Gym'},
          {'code': 'running', 'label': 'Running'},
          {'code': 'swimming', 'label': 'Swimming'},
          {'code': 'cycling', 'label': 'Cycling'},
        ],
      },
      {
        'code': 'diet',
        'text': 'How would you describe your usual diet?',
        'type': 'single_choice',
        'allows_custom': true,
        'custom_label': 'Others',
        'options': [
          {'code': 'mostly_balanced', 'label': 'Mostly balanced'},
          {'code': 'could_be_healthier', 'label': 'Could be healthier'},
          {'code': 'often_eat_outside', 'label': 'Often eat outside'},
          {'code': 'not_sure', 'label': "I'm not sure"},
        ],
      },
    ],
  },
  {
    'code': 'family_history',
    'title': 'Family Health History',
    'description': 'Conditions that run in your immediate family.',
    'opens_route': null,
    'questions': [
      {
        'code': 'family_conditions',
        'text': 'Does anyone in your immediate family have:',
        'type': 'multi_choice',
        'options': [
          {'code': 'diabetes', 'label': 'Diabetes'},
          {'code': 'high_blood_pressure', 'label': 'High blood pressure'},
          {'code': 'high_cholesterol', 'label': 'High cholesterol'},
          {'code': 'heart_disease', 'label': 'Heart disease'},
          {'code': 'stroke', 'label': 'Stroke'},
          {'code': 'cancer', 'label': 'Cancer'},
          {'code': 'kidney_disease', 'label': 'Kidney disease'},
          {'code': 'not_sure', 'label': "I'm not sure", 'exclusive': true},
          {
            'code': 'none_known',
            'label': 'None that I know of',
            'exclusive': true
          },
        ],
      },
      {
        'code': 'notes',
        'text': "Anything else you'd like to add?",
        'type': 'long_text',
        'hint': 'Optional.',
      },
    ],
  },
  {
    'code': 'mental_wellbeing',
    'title': 'Mental Wellbeing',
    'description': 'Mood, stress and sleep.',
    'opens_route': 'mental_state',
    'questions': <Map<String, dynamic>>[],
  },
];
