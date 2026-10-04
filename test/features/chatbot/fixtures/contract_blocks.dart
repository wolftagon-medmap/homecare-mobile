const Map<String, dynamic> userTextJson = {
  'id': 11,
  'kind': 'user_text',
  'text': "I've been feeling dizzy",
};

const Map<String, dynamic> assistantTextJson = {
  'id': 12,
  'kind': 'assistant_text',
  'text': 'Thanks! Here is what I understand so far.',
  'origin': 'ai',
};

const Map<String, dynamic> staffTextJson = {
  'id': 13,
  'kind': 'staff_text',
  'text': 'A nurse will call you shortly.',
  'authorUserId': 42,
};

const Map<String, dynamic> confirmRequestJson = {
  'id': 14,
  'kind': 'confirm_request',
  'text': 'Cancel your appointment on Monday?',
  'confirmId': 'confirm:abc',
  'cancelId': 'decline:abc',
};

const Map<String, dynamic> topicGridJson = {
  'id': 1,
  'kind': 'topic_grid',
  'title': 'What can I help you with today?',
  'topics': [
    {
      'replyId': 'topic:symptom',
      'label': 'I have a symptom',
      'icon': 'symptom',
      'tone': 'teal',
    },
    {
      'replyId': 'topic:medication',
      'label': 'I have a medication question',
      'icon': 'medication',
      'tone': 'red',
    },
    {
      'replyId': 'topic:concern',
      'label': 'I have a health concern',
      'icon': 'concern',
      'tone': 'purple',
    },
    {
      'replyId': 'topic:lifestyle',
      'label': 'I want to improve my lifestyle',
      'icon': 'lifestyle',
      'tone': 'green',
    },
    {
      'replyId': 'topic:stress',
      'label': "I'm feeling stressed or worried",
      'icon': 'stress',
      'tone': 'pink',
    },
    {
      'replyId': 'topic:results',
      'label': 'I want to understand my health results',
      'icon': 'results',
      'tone': 'blue',
    },
    {
      'replyId': 'topic:someone',
      'label': "I'm asking for someone else",
      'icon': 'someone',
      'tone': 'amber',
    },
    {
      'replyId': 'topic:other',
      'label': 'Something else',
      'icon': 'other',
      'tone': 'grey',
    },
  ],
};

const Map<String, dynamic> singleQuestionJson = {
  'id': 20,
  'kind': 'question',
  'questionId': 'q1',
  'text': 'When do you usually feel dizzy?',
  'mode': 'single',
  'hint': 'Please choose one.',
  'options': [
    {'index': 0, 'label': 'When standing up'},
    {'index': 1, 'label': 'When walking'},
    {'index': 2, 'label': "I'm not sure"},
  ],
  'continueLabel': null,
  'exclusiveIndex': null,
};

const Map<String, dynamic> multiQuestionJson = {
  'id': 21,
  'kind': 'question',
  'questionId': 'q2',
  'text': 'Which of these do you also notice?',
  'mode': 'multi',
  'hint': 'You can choose more than one.',
  'options': [
    {'index': 0, 'label': 'Headache'},
    {'index': 1, 'label': 'Nausea'},
    {'index': 2, 'label': 'Blurred vision'},
    {'index': 3, 'label': 'None of these'},
  ],
  'continueLabel': 'Continue',
  'exclusiveIndex': 3,
};

const Map<String, dynamic> summaryJson = {
  'id': 30,
  'kind': 'summary',
  'title': 'Your Summary',
  'rows': [
    {
      'icon': 'issue',
      'label': 'Main issue',
      'value': 'Dizziness for about 3 days',
    },
    {
      'icon': 'answer',
      'label': 'When do you usually feel dizzy?',
      'value': 'When standing up',
    },
  ],
  'footnote': "Please review and let me know if I've missed anything.",
  'editLabel': 'Edit Answers',
  'confirmLabel': 'Looks good',
  'editReplyId': 'summary:edit',
  'confirmReplyId': 'summary:ok',
};

const Map<String, dynamic> guidanceJson = {
  'id': 31,
  'kind': 'guidance',
  'title': 'General guidance',
  'body': 'Dizziness can have many causes ...',
  'disclaimer':
      'This is general information, not a diagnosis. If your symptoms are severe or getting worse, seek medical care.',
  'suggestionsTitle': 'You may also consider:',
  'suggestions': [
    {
      'replyId': 'svc:0',
      'title': 'Medication Support',
      'subtitle': 'Review your medications with a pharmacist.',
      'icon': 'pharmacy',
      'tone': 'red',
      'booking': {
        'category': 'pharmacy',
        'subCategory': 'medication_support',
        'issueCodes': ['med_side_effects'],
        'remarks': 'Dizziness for about 3 days. When standing up.',
      },
    },
  ],
};

const Map<String, dynamic> nextStepJson = {
  'id': 32,
  'kind': 'next_step',
  'actions': [
    {
      'replyId': 'next:explore',
      'action': 'explore_services',
      'title': 'Explore M2Health Services',
      'subtitle': 'Find the right service for you',
      'icon': 'services',
      'tone': 'red',
    },
    {
      'replyId': 'next:save',
      'action': 'reply',
      'title': 'Save My Summary',
      'subtitle': 'Save and come back later',
      'icon': 'save',
      'tone': 'green',
    },
    {
      'replyId': 'next:new',
      'action': 'new_conversation',
      'title': 'Ask Another Question',
      'subtitle': 'I still have more questions',
      'icon': 'ask',
      'tone': 'blue',
    },
  ],
};
