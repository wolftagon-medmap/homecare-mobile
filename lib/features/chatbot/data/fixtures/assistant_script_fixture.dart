const kNextStepActionsFixture = <Map<String, dynamic>>[
  {
    'reply_id': 'next_doctor',
    'title': 'Chat with a Doctor',
    'subtitle': 'Get professional medical advice',
    'icon': 'doctor',
    'tone': 'teal',
    'reply': 'I will pass this summary on when you book. You can message the '
        'professional from the appointment once it is confirmed.',
  },
  {
    'reply_id': 'next_services',
    'title': 'Explore M2Health Services',
    'subtitle': 'Find the right service for you',
    'icon': 'services',
    'tone': 'red',
    'route': '/intake-booking',
  },
  {
    'reply_id': 'next_save',
    'title': 'Save My Summary',
    'subtitle': 'Save and come back later',
    'icon': 'save',
    'tone': 'green',
    'reply': 'Saved to this conversation.',
  },
  {
    'reply_id': 'next_ask',
    'title': 'Ask Another Question',
    'subtitle': 'I still have more questions',
    'icon': 'ask',
    'tone': 'blue',
    'restart': true,
  },
];

const kShortNextStepActionsFixture = <Map<String, dynamic>>[
  {
    'reply_id': 'next_services',
    'title': 'Explore M2Health Services',
    'subtitle': 'Find the right service for you',
    'icon': 'services',
    'tone': 'red',
    'route': '/intake-booking',
  },
  {
    'reply_id': 'next_doctor',
    'title': 'Chat with a Doctor',
    'subtitle': 'Get professional medical advice',
    'icon': 'doctor',
    'tone': 'teal',
    'reply': 'I will pass this on when you book. You can message the '
        'professional from the appointment once it is confirmed.',
  },
  {
    'reply_id': 'next_ask',
    'title': 'Ask Another Question',
    'subtitle': 'I still have more questions',
    'icon': 'ask',
    'tone': 'blue',
    'restart': true,
  },
];

const kAssistantScriptFixture = <String, dynamic>{
  'script_id': 'assistant_triage_v1',
  'entry_step': 'welcome',
  'off_topic_reply':
      "Let's finish these few questions first — then I'll summarise "
          'everything you have told me.',
  'steps': [
    {
      'id': 'welcome',
      'text_next': 'symptom_pick',
      'fallback_next': 'handoff',
      'transitions': {
        'topic_symptom': 'symptom_pick',
        'topic_medication': 'handoff',
        'topic_concern': 'handoff',
        'topic_lifestyle': 'handoff',
        'topic_stress': 'handoff',
        'topic_results': 'handoff',
        'topic_someone': 'handoff',
        'topic_other': 'handoff',
      },
      'blocks': [
        {
          'kind': 'topic_grid',
          'title': 'What can I help you with today?',
          'topics': [
            {
              'reply_id': 'topic_symptom',
              'label': 'I have a symptom',
              'icon': 'symptom',
              'tone': 'teal',
            },
            {
              'reply_id': 'topic_medication',
              'label': 'I have a medication question',
              'icon': 'medication',
              'tone': 'red',
            },
            {
              'reply_id': 'topic_concern',
              'label': 'I have a health concern',
              'icon': 'concern',
              'tone': 'purple',
            },
            {
              'reply_id': 'topic_lifestyle',
              'label': 'I want to improve my lifestyle',
              'icon': 'lifestyle',
              'tone': 'green',
            },
            {
              'reply_id': 'topic_stress',
              'label': "I'm feeling stressed or worried",
              'icon': 'stress',
              'tone': 'pink',
            },
            {
              'reply_id': 'topic_results',
              'label': 'I want to understand my health results',
              'icon': 'results',
              'tone': 'blue',
            },
            {
              'reply_id': 'topic_someone',
              'label': "I'm asking for someone else",
              'icon': 'someone',
              'tone': 'amber',
            },
            {
              'reply_id': 'topic_other',
              'label': 'Something else',
              'icon': 'other',
              'tone': 'grey',
            },
          ],
        },
      ],
    },
    {
      'id': 'symptom_pick',
      'answer_key': 'symptom',
      'fallback_next': 'handoff',
      'text_reply':
          'Pick the closest match above and I will ask a few quick questions.',
      'transitions': {
        'sym_dizzy': 'ask_onset',
        'sym_headache': 'handoff',
        'sym_chest': 'safety',
        'sym_other': 'handoff',
      },
      'blocks': [
        {
          'kind': 'assistant_text',
          'text': "I'm sorry to hear that. Which of these is closest to what "
              'you are feeling?',
        },
        {
          'kind': 'single_choice',
          'prompt': 'What is bothering you?',
          'hint': 'Please choose one.',
          'options': [
            {
              'reply_id': 'sym_dizzy',
              'label': 'Dizziness',
              'echo': "I've been feeling dizzy for the past few days.",
              'summary': 'Dizziness for about 3 days',
            },
            {
              'reply_id': 'sym_headache',
              'label': 'Headache',
              'echo': "I've had a headache for the past few days.",
              'summary': 'Headache',
            },
            {
              'reply_id': 'sym_chest',
              'label': 'Chest pain or shortness of breath',
              'echo': 'I have chest pain and shortness of breath.',
              'summary': 'Chest pain or shortness of breath',
            },
            {
              'reply_id': 'sym_other',
              'label': 'Something else',
              'echo': 'It is something else.',
              'summary': 'Other symptom',
            },
          ],
        },
      ],
    },
    {
      'id': 'ask_onset',
      'answer_key': 'onset',
      'fallback_next': 'ask_symptoms',
      'transitions': {
        'onset_standing': 'ask_symptoms',
        'onset_walking': 'ask_symptoms',
        'onset_turning': 'ask_symptoms',
        'onset_random': 'ask_symptoms',
        'onset_always': 'ask_symptoms',
        'onset_unsure': 'ask_symptoms',
      },
      'blocks': [
        {
          'kind': 'assistant_text',
          'text': "I'm sorry you've been feeling dizzy. Let me ask you a few "
              'quick questions so I can better understand.',
        },
        {
          'kind': 'single_choice',
          'prompt': 'When do you usually feel dizzy?',
          'hint': 'Please choose one.',
          'options': [
            {'reply_id': 'onset_standing', 'label': 'When standing up'},
            {'reply_id': 'onset_walking', 'label': 'When walking'},
            {'reply_id': 'onset_turning', 'label': 'When turning my head'},
            {'reply_id': 'onset_random', 'label': 'It happens randomly'},
            {'reply_id': 'onset_always', 'label': 'Almost all the time'},
            {
              'reply_id': 'onset_unsure',
              'label': "I'm not sure",
              'summary': 'Not sure',
            },
          ],
        },
      ],
    },
    {
      'id': 'ask_symptoms',
      'answer_key': 'symptoms',
      'fallback_next': 'ask_medication',
      'blocks': [
        {
          'kind': 'multi_choice',
          'prompt': 'Do you have any of these symptoms?',
          'hint': 'You can choose more than one.',
          'continue_label': 'Continue',
          'exclusive_option_id': 'sx_none',
          'options': [
            {'reply_id': 'sx_nausea', 'label': 'Nausea'},
            {'reply_id': 'sx_headache', 'label': 'Headache'},
            {'reply_id': 'sx_blurred', 'label': 'Blurred vision'},
            {'reply_id': 'sx_palpitations', 'label': 'Heart palpitations'},
            {'reply_id': 'sx_chest', 'label': 'Chest pain'},
            {'reply_id': 'sx_breath', 'label': 'Shortness of breath'},
            {'reply_id': 'sx_none', 'label': 'None of the above'},
          ],
        },
      ],
    },
    {
      'id': 'ask_medication',
      'answer_key': 'history',
      'fallback_next': 'ask_for_who',
      'transitions': {
        'med_bp': 'ask_for_who',
        'med_other': 'ask_for_who',
        'med_none': 'ask_for_who',
        'med_unsure': 'ask_for_who',
      },
      'blocks': [
        {
          'kind': 'single_choice',
          'prompt': 'Are you taking any regular medication?',
          'hint': 'Please choose one.',
          'options': [
            {
              'reply_id': 'med_bp',
              'label': 'Yes — blood pressure medication',
              'echo': 'I take blood pressure medication.',
              'summary': 'Taking blood pressure medication',
            },
            {
              'reply_id': 'med_other',
              'label': 'Yes — something else',
              'summary': 'Taking regular medication',
            },
            {
              'reply_id': 'med_none',
              'label': 'No',
              'summary': 'No regular medication',
            },
            {
              'reply_id': 'med_unsure',
              'label': "I'm not sure",
              'summary': 'Not sure',
            },
          ],
        },
      ],
    },
    {
      'id': 'ask_for_who',
      'answer_key': 'for',
      'fallback_next': 'summary',
      'transitions': {'for_self': 'summary', 'for_other': 'summary'},
      'blocks': [
        {
          'kind': 'single_choice',
          'prompt': 'Who is this for?',
          'hint': 'Please choose one.',
          'options': [
            {
              'reply_id': 'for_self',
              'label': 'Myself',
              'echo': 'It is for myself.',
            },
            {
              'reply_id': 'for_other',
              'label': 'Someone I care for',
              'echo': 'It is for someone I care for.',
            },
          ],
        },
      ],
    },
    {
      'id': 'summary',
      'fallback_next': 'guidance',
      'text_reply':
          'Tap Edit Answers if something is wrong, or Looks good to carry on.',
      'transitions': {'summary_ok': 'guidance', 'summary_edit': 'symptom_pick'},
      'blocks': [
        {
          'kind': 'assistant_text',
          'text': "Thanks! Here's what I understand so far.",
        },
        {
          'kind': 'summary',
          'title': 'Your Summary',
          'footnote': "Please review and let me know if I've missed anything.",
          'edit_label': 'Edit Answers',
          'confirm_label': 'Looks good',
          'edit_reply_id': 'summary_edit',
          'confirm_reply_id': 'summary_ok',
          'rows': [
            {'icon': 'issue', 'label': 'Main issue', 'from_step': 'symptom'},
            {'icon': 'when', 'label': 'When it happens', 'from_step': 'onset'},
            {
              'icon': 'symptoms',
              'label': 'Other symptoms',
              'from_step': 'symptoms',
            },
            {
              'icon': 'history',
              'label': 'Medical history',
              'from_step': 'history',
            },
            {'icon': 'for', 'label': 'For', 'from_step': 'for'},
          ],
        },
      ],
    },
    {
      'id': 'guidance',
      'text_reply':
          'Choose one of the options above and I will take you there.',
      'blocks': [
        {
          'kind': 'assistant_text',
          'text': "Based on what you've shared, here are some possible next "
              'steps.',
        },
        {
          'kind': 'guidance',
          'title': 'General guidance',
          'body': 'Dizziness may be related to blood pressure changes or '
              'dehydration. Please monitor your symptoms and seek urgent care '
              'if you feel faint, have chest pain or shortness of breath.',
          'suggestions_title': 'You may also consider:',
          'suggestions': [
            {
              'reply_id': 'svc_pharmacy',
              'title': 'Pharmacist Review',
              'subtitle': 'Review your medications with a pharmacist.',
              'icon': 'pharmacy',
              'tone': 'red',
              'route': '/intake-booking',
            },
            {
              'reply_id': 'svc_screening',
              'title': 'Health Screening',
              'subtitle': 'Check your blood pressure and overall health.',
              'icon': 'screening',
              'tone': 'green',
              'route': '/intake-booking',
            },
            {
              'reply_id': 'svc_doctor',
              'title': 'Chat with a Doctor',
              'subtitle': 'Speak with a doctor for further assessment.',
              'icon': 'doctor',
              'tone': 'teal',
              'route': '/intake-booking',
            },
          ],
        },
        {
          'kind': 'assistant_text',
          'text': 'What would you like to do next?',
        },
        {'kind': 'next_step', 'actions': kNextStepActionsFixture},
      ],
    },
    {
      'id': 'handoff',
      'text_reply':
          'Choose one of the options above and I will take you there.',
      'blocks': [
        {
          'kind': 'assistant_text',
          'text': 'I can help you find the right care for that. Here is the '
              'quickest way to get you to the right person.',
        },
        {'kind': 'next_step', 'actions': kShortNextStepActionsFixture},
      ],
    },
    {
      'id': 'safety',
      'text_reply': 'Please seek urgent medical care now.',
      'blocks': [
        {
          'kind': 'assistant_text',
          'text': 'Chest pain and shortness of breath can be serious. Please '
              'seek urgent medical care now — do not wait for an appointment.',
        },
        {
          'kind': 'assistant_text',
          'text': 'Once you are safe, I can help you arrange follow-up care.',
        },
        {'kind': 'next_step', 'actions': kShortNextStepActionsFixture},
      ],
    },
  ],
};
