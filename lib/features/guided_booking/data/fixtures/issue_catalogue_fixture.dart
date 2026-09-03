const Map<String, Map<String, dynamic>> kIssueCatalogueFixtures = {
  'pharmacy': kPharmacyIssueCatalogue,
  'physiotherapy': kPhysiotherapyIssueCatalogue,
  'psychology': kPsychologyIssueCatalogue,
  'nutrition': kDietitianIssueCatalogue,
  'optometry': kOptometryIssueCatalogue,
  'nursing': kNursingIssueCatalogue,
  'screening': kScreeningIssueCatalogue,
  'diabetes_screening': kDiabetesScreeningIssueCatalogue,
};

const Map<String, dynamic> kPharmacyIssueCatalogue = {
  'category': 'pharmacy',
  'title': 'Pharmacist Review',
  'pricing_model': 'per_item',
  'issues': <Map<String, dynamic>>[],
  'sub_categories': [
    {
      'code': 'medication_support',
      'service_code':
          'pharmacy.medication_review_counseling.drug_therapy_adjustment',
      'label': 'Medication Support',
      'description':
          'A pharmacist reviews everything you take, explains it, and helps you '
              'manage it safely.',
      'image': 'assets/icons/ilu_pharmacist.png',
      'background': '#1AF79E1B',
      'issues': [
        {'code': 'med_questions', 'label': 'Questions about my medication'},
        {'code': 'med_side_effects', 'label': 'Medication side effects'},
        {'code': 'med_multiple', 'label': 'Managing multiple medications'},
        {
          'code': 'med_adherence',
          'label': 'Difficulty remembering to take my medication',
        },
        {
          'code': 'med_prescription_help',
          'label': 'Help understanding my prescription',
        },
        {
          'code': 'med_interactions',
          'label': 'Concerns about drug interactions',
        },
        {'code': 'med_other', 'label': "Other / I'm not sure"},
      ],
    },
    {
      'code': 'quit_smoking',
      'service_code': 'pharmacy.smoking_cessation.initial_counseling',
      'label': 'Quit Smoking',
      'description':
          'Structured support to stop smoking, built around your habits and '
              'what you have already tried.',
      'image': 'assets/icons/ilu_lung.png',
      'background': '#30FF9A9A',
      'legacy_flow': 'smoking_cessation',
      'issues': <Map<String, dynamic>>[],
    },
  ],
};

const Map<String, dynamic> kPhysiotherapyIssueCatalogue = {
  'category': 'physiotherapy',
  'title': 'Physiotherapy',
  'pricing_model': 'per_package',
  'issues': [
    {'code': 'physio_back_pain', 'label': 'Back pain'},
    {'code': 'physio_neck_pain', 'label': 'Neck pain'},
    {'code': 'physio_shoulder_pain', 'label': 'Shoulder pain'},
    {'code': 'physio_knee_pain', 'label': 'Knee pain'},
    {'code': 'physio_joint_muscle_pain', 'label': 'Joint or muscle pain'},
    {'code': 'physio_sports_injury', 'label': 'Sports injury'},
    {'code': 'physio_post_surgery', 'label': 'Post-surgery rehabilitation'},
    {'code': 'physio_mobility', 'label': 'Mobility or walking difficulties'},
    {'code': 'physio_balance', 'label': 'Balance issues / fall prevention'},
    {'code': 'physio_other', 'label': 'Other / Not sure'},
  ],
  'sub_categories': [
    {
      'code': 'musculoskeletal',
      'service_code': 'physiotherapy.musculoskeletal.60_minutes',
      'label': 'Musculoskeletal Physiotherapy',
      'description':
          'Rehabilitation for muscle, joint and bone conditions, including '
              'injury recovery and post-surgery care.',
      'image': 'assets/illustration/physiotherapy_musculoskeletal.png',
      'background': '#1AF79E1B',
      'issues': <Map<String, dynamic>>[],
    },
    {
      'code': 'neurological',
      'service_code': 'physiotherapy.neurological.60_minutes',
      'label': 'Neurological Physiotherapy',
      'description':
          'Rehabilitation for conditions affecting the nervous system, such as '
              'stroke recovery and movement disorders.',
      'image': 'assets/illustration/physiotherapy_neurological.png',
      'background': '#33B28CFF',
      'issues': <Map<String, dynamic>>[],
    },
  ],
};

const Map<String, dynamic> kPsychologyIssueCatalogue = {
  'category': 'psychology',
  'title': 'Psychology',
  'pricing_model': 'per_package',
  'issues': [
    {'code': 'psy_stress', 'label': 'Stress'},
    {'code': 'psy_anxiety', 'label': 'Anxiety or excessive worrying'},
    {'code': 'psy_low_mood', 'label': 'Low mood'},
    {'code': 'psy_sleep', 'label': 'Sleep difficulties'},
    {'code': 'psy_relationships', 'label': 'Relationship or family issues'},
    {'code': 'psy_work_stress', 'label': 'Work-related stress'},
    {'code': 'psy_caregiver_stress', 'label': 'Caregiver stress'},
    {'code': 'psy_life_changes', 'label': 'Coping with life changes'},
    {'code': 'psy_grief', 'label': 'Grief or loss'},
    {
      'code': 'psy_other',
      'label': 'Other / Prefer to discuss with psychologist',
    },
  ],
  'sub_categories': [
    {
      'code': 'psychology_consultation',
      'service_code': 'psychology.consultation',
      'label': 'Psychology Consultation',
      'description':
          'Talk to a licensed psychologist about stress, anxiety, relationships, '
              'and your overall mental well-being.',
      'image': 'assets/icons/ic_psychologist.png',
      'background': '#33B28CFF',
      'issues': <Map<String, dynamic>>[],
    },
  ],
};

const Map<String, dynamic> kDietitianIssueCatalogue = {
  'category': 'nutrition',
  'title': 'Dietitian',
  'pricing_model': 'per_package',
  'service_code': 'nutrition.assessment',
  'issues': [
    {'code': 'diet_weight', 'label': 'Weight management'},
    {'code': 'diet_diabetes', 'label': 'Diabetes management'},
    {'code': 'diet_cholesterol', 'label': 'High cholesterol'},
    {'code': 'diet_blood_pressure', 'label': 'High blood pressure'},
    {'code': 'diet_general_nutrition', 'label': 'Improving general nutrition'},
    {'code': 'diet_digestive', 'label': 'Digestive issues'},
    {'code': 'diet_healthy_ageing', 'label': 'Healthy ageing nutrition'},
    {'code': 'diet_poor_appetite', 'label': 'Poor appetite'},
    {'code': 'diet_allergies', 'label': 'Food allergies or intolerances'},
    {'code': 'diet_other', 'label': 'Other / Not sure'},
  ],
  'sub_categories': <Map<String, dynamic>>[],
};

const Map<String, dynamic> kOptometryIssueCatalogue = {
  'category': 'optometry',
  'title': 'Optometrist',
  'pricing_model': 'per_package',
  'issues': [
    {'code': 'opt_blurred_vision', 'label': 'Blurred vision'},
    {'code': 'opt_near_objects', 'label': 'Difficulty seeing near objects'},
    {
      'code': 'opt_distant_objects',
      'label': 'Difficulty seeing distant objects'
    },
    {'code': 'opt_eye_strain', 'label': 'Eye strain'},
    {'code': 'opt_dry_eyes', 'label': 'Dry or uncomfortable eyes'},
    {'code': 'opt_headaches', 'label': 'Vision-related headaches'},
    {'code': 'opt_general_checkup', 'label': 'General eye check-up'},
    {
      'code': 'opt_prescription_review',
      'label': 'Glasses or prescription review'
    },
    {'code': 'opt_other', 'label': 'Other / Not sure'},
  ],
  'sub_categories': [
    {
      'code': 'eye_care_consultation',
      'service_code': 'optometry.consultation',
      'label': 'Eye Care Consultation',
      'description':
          'A licensed optometrist checks your vision and eye health, and reviews '
              'your prescription.',
      'image': 'assets/icons/ic_psychologist.png',
      'background': '#33B28CFF',
      'issues': <Map<String, dynamic>>[],
    },
  ],
};

const Map<String, dynamic> kNursingIssueCatalogue = {
  'category': 'nursing',
  'title': 'Home Nursing',
  'pricing_model': 'per_item',
  'issues': [
    {'code': 'nurse_wound_care', 'label': 'Wound care'},
    {'code': 'nurse_medication_admin', 'label': 'Medication administration'},
    {'code': 'nurse_injection', 'label': 'Injection services'},
    {
      'code': 'nurse_post_hospitalisation',
      'label': 'Post-hospitalisation care'
    },
    {'code': 'nurse_catheter_care', 'label': 'Catheter care'},
    {'code': 'nurse_stoma_care', 'label': 'Stoma care'},
    {'code': 'nurse_health_monitoring', 'label': 'Health monitoring'},
    {'code': 'nurse_procedures', 'label': 'Nursing procedures'},
    {'code': 'nurse_elderly_support', 'label': 'Elderly care support'},
    {'code': 'nurse_other', 'label': 'Other / Not sure'},
  ],
  'sub_categories': [
    {
      'code': 'primary_nurse',
      'service_code': 'nursing.basic.ngt_feeding',
      'label': 'Primary Nursing',
      'description':
          'General nursing care at home — monitoring, medication, wound '
              'dressing and daily clinical support.',
      'image': 'assets/icons/ilu_nurse.png',
      'background': '#549AE1FF',
      'issues': <Map<String, dynamic>>[],
    },
    {
      'code': 'specialized_nurse',
      'service_code': 'nursing.specialized.stomy_wound_care',
      'label': 'Specialized Nursing',
      'description':
          'Advanced procedures that need a specialist nurse, such as catheter, '
              'stoma and complex wound care.',
      'image': 'assets/icons/ilu_nurse_special.png',
      'background': '#33B28CFF',
      'issues': <Map<String, dynamic>>[],
    },
  ],
};

const Map<String, dynamic> kScreeningIssueCatalogue = {
  'category': 'screening',
  'title': 'Home Health Screening',
  'pricing_model': 'per_item',
  'issues': [
    {'code': 'screen_general_health', 'label': 'General health'},
    {'code': 'screen_diabetes', 'label': 'Diabetes'},
    {'code': 'screen_blood_pressure', 'label': 'Blood pressure'},
    {'code': 'screen_cholesterol', 'label': 'Cholesterol'},
    {'code': 'screen_mens_health', 'label': "Men's health"},
    {'code': 'screen_womens_health', 'label': "Women's health"},
    {'code': 'screen_senior_health', 'label': 'Senior health'},
    {'code': 'screen_work', 'label': 'Health screening for work'},
  ],
  'sub_categories': [
    {
      'code': 'at_home_diagnostic',
      'service_code': 'screening.basic_screening.urinalysis',
      'label': 'At-home diagnostic tests',
      'description':
          'Collect your samples at home with a self-collection kit; a certified '
              'lab processes them and a clinician walks you through the results.',
      'image': 'assets/icons/ilu_nurse.png',
      'background': '#549AE1FF',
      'issues': <Map<String, dynamic>>[],
    },
    {
      'code': 'point_of_care',
      'service_code': 'screening.basic_screening.liver_profile',
      'label': 'Point-of-care tests',
      'description':
          'Rapid tests taken at home that produce results on the spot, without '
              'a lab or a technician present.',
      'image': 'assets/icons/ilu_nurse_special.png',
      'background': '#33B28CFF',
      'issues': <Map<String, dynamic>>[],
    },
  ],
};

const Map<String, dynamic> kDiabetesScreeningIssueCatalogue = {
  'category': 'diabetes_screening',
  'title': 'Diabetes Screening',
  'pricing_model': 'per_item',
  'pricing_category': 'screening',
  'service_code': 'screening.basic_screening.urinalysis',
  'issues': [
    {
      'code': 'diabetes_eye_screening',
      'label': 'Eye Screening',
      'description':
          'Retinal Photography to check for diabetes-related changes in the '
              'back of the eye.',
    },
    {
      'code': 'diabetes_foot_screening',
      'label': 'Foot Screening',
      'description':
          'Diabetic Foot Screening to check for diabetes-related foot and nerve '
              'complications.',
    },
    {
      'code': 'diabetes_both_screening',
      'label': 'Both Eye & Foot Screening',
      // AUTHORED — the PDF gives this option no description.
      'description':
          'Retinal photography and diabetic foot screening in one visit.',
    },
  ],
  'sub_categories': <Map<String, dynamic>>[],
};
