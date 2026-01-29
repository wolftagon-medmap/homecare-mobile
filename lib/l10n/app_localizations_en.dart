// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_delete => 'Delete';

  @override
  String common_error(String message) {
    return 'Error: $message';
  }

  @override
  String get common_no => 'No';

  @override
  String get common_no_data => 'No data available';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_status => 'Status';

  @override
  String get common_description => 'Description';

  @override
  String get common_yes => 'Yes';

  @override
  String get common_complete => 'Complete';

  @override
  String get common_save => 'Save';

  @override
  String get common_saving => 'Saving...';

  @override
  String get common_modify => 'Modify';

  @override
  String get common_remove => 'Remove';

  @override
  String get common_updated_success => 'Updated successfully';

  @override
  String get common_delete_success => 'Deleted successfully';

  @override
  String get name => 'Name';

  @override
  String get full_name => 'Full Name';

  @override
  String get age => 'Age';

  @override
  String age_years_old(int age) {
    return '$age years old';
  }

  @override
  String get gender => 'Gender';

  @override
  String get contact_number => 'Contact Number';

  @override
  String get address => 'Address';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get none => 'None';

  @override
  String created_on(String date) {
    return 'Created on: $date';
  }

  @override
  String get last_updated => 'Last updated';

  @override
  String get tab_home => 'Home';

  @override
  String get services => 'Services';

  @override
  String get allied_services => 'Allied Health';

  @override
  String get pharmacist_services => 'iRX Pharmacist Service';

  @override
  String get nursing_service => 'Home Nursing';

  @override
  String get diabetic_care_service => 'Diabetic Care';

  @override
  String get home_screening_service => 'Home Health Screening';

  @override
  String get precision_nutrition_service => 'Precision Nutrition';

  @override
  String get homecare_for_elderly_service => 'Home Care for Elderly';

  @override
  String get physiotherapy_service => 'Physiotherapy';

  @override
  String get remote_patient_monitoring_service => 'Remote Patient Monitoring';

  @override
  String get second_opinion_service => '2nd Opinion for Medical Image';

  @override
  String get health_risk_assessment_service => 'Health Risk Assessment';

  @override
  String get dietitian_service => 'Dietitian Service';

  @override
  String get sleep_and_mental_health_service => 'Sleep & Mental Health';

  @override
  String dashboard_greeting(String displayName) {
    return 'Live Longer & Live Healthier, $displayName!';
  }

  @override
  String get dashboard_chat_ai_placeholder =>
      'Chat With AI doctor for all your health questions';

  @override
  String get appointment => 'Appointment';

  @override
  String get appointment_list_title => 'My Appointment';

  @override
  String get appointment_status_upcoming => 'Upcoming';

  @override
  String get appointment_status_pending => 'Pending';

  @override
  String get appointment_status_waiting_approval => 'Waiting Approval';

  @override
  String get appointment_status_accepted => 'Accepted';

  @override
  String get appointment_status_completed => 'Completed';

  @override
  String get appointment_status_cancelled => 'Cancelled';

  @override
  String get appointment_status_missed => 'Missed';

  @override
  String appointment_list_empty(String appointment_status) {
    return 'No $appointment_status appointments found.';
  }

  @override
  String get appointment_cancel_booking_btn => 'Cancel Booking';

  @override
  String get appointment_reschedule_btn => 'Reschedule';

  @override
  String get appointment_book_again_btn => 'Book Again';

  @override
  String get appointment_rating_btn => 'Rate';

  @override
  String get appointment_decline_btn => 'Decline';

  @override
  String get appointment_accept_btn => 'Accept';

  @override
  String get appointment_mark_complete_btn => 'Mark as Complete';

  @override
  String get appointment_screening_confirm_sample_btn =>
      'Confirm Sample Collected';

  @override
  String get appointment_screening_upload_report_btn => 'Upload Report';

  @override
  String get appointment_arrange_video_consultation =>
      'Arrange Video Consultation';

  @override
  String get appointment_pay_btn => 'Pay';

  @override
  String get appointment_detail_title => 'Appointment Detail';

  @override
  String get appointment_detail_schedule_title => 'Appointment Schedule';

  @override
  String get appointment_detail_patient_title => 'Patient Information';

  @override
  String get appointment_detail_lab_test_title => 'Lab Test Information';

  @override
  String appointment_detail_report(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reports',
      one: 'Report',
      zero: 'No Reports',
    );
    return '$_temp0';
  }

  @override
  String get appointment_detail_requested_homecare_task =>
      'Requested Homecare Tasks';

  @override
  String get appointment_detail_requested_homecare_task_empty =>
      'No specific homecare tasks requested.';

  @override
  String get appointment_detail_patient_problem_title => 'Patient Problems';

  @override
  String get appointment_detail_patient_problem_empty =>
      'No specific problem details provided.';

  @override
  String get appointment_detail_payment_title => 'Payment Information';

  @override
  String get appointment_detail_estimated_budget => 'Estimated Budget';

  @override
  String get appointment_detail_payment_details => 'Payment Details';

  @override
  String get appointment_detail_payment_date => 'Payment Date';

  @override
  String get appointment_detail_payment_method => 'Payment Method';

  @override
  String get appointment_detail_order_completed_date => 'Order Completed';

  @override
  String appointment_detail_total_amount(String amount) {
    return 'Total: $amount';
  }

  @override
  String get appointment_detail_total_label => 'Total';

  @override
  String get appointment_detail_service_requested => 'Services Requested';

  @override
  String get appointment_summary => 'Summary:';

  @override
  String get appointment_update_success_message =>
      'Appointment updated successfully';

  @override
  String get appointment_accept_success_message =>
      'Appointment accepted successfully';

  @override
  String get appointment_decline_success_message =>
      'Appointment declined successfully';

  @override
  String get appointment_complete_success_message =>
      'Appointment completed successfully';

  @override
  String get appointment_confirm_sample_success_message =>
      'Sample collection confirmed successfully';

  @override
  String get appointment_mark_report_ready_success_message =>
      'Report marked as ready';

  @override
  String get appointment_cancel_dialog_content =>
      'Are you sure to cancel this appointment?';

  @override
  String get appointment_cancel_dialog_subtitle =>
      'You can rebook it later from the canceled appointment menu.';

  @override
  String get appointment_complete_dialog_title => 'Complete Appointment';

  @override
  String get appointment_complete_dialog_content =>
      'Mark this appointment as completed?';

  @override
  String get appointment_accept_dialog_title => 'Accept Appointment';

  @override
  String get appointment_accept_dialog_content =>
      'Are you sure you want to accept this appointment?';

  @override
  String get appointment_decline_dialog_title =>
      'Are you sure you want to decline this appointment?';

  @override
  String get appointment_decline_dialog_subtitle =>
      'This action cannot be undone.';

  @override
  String get screening_report_upload_title => 'Upload Lab Reports';

  @override
  String get screening_report_upload_instruction =>
      'Please upload all necessary lab reports before marking them as ready.';

  @override
  String screening_report_uploaded_section(int count) {
    return 'Uploaded Reports ($count)';
  }

  @override
  String get screening_report_empty => 'No reports uploaded yet';

  @override
  String get screening_report_upload_btn => 'Upload New Report';

  @override
  String get screening_report_mark_ready_btn => 'Mark Reports as Ready';

  @override
  String get screening_report_finalize_dialog_title => 'Finalize Reports?';

  @override
  String get screening_report_finalize_dialog_content =>
      'Once marked as ready, reports will be sent to the patient and you cannot modify them anymore.';

  @override
  String get screening_report_finalized_message => 'Reports Finalized';

  @override
  String get screening_report_delete_dialog_title => 'Delete Report?';

  @override
  String get screening_report_delete_dialog_content =>
      'Are you sure you want to delete this report?';

  @override
  String get screening_report_upload_success => 'Report uploaded successfully';

  @override
  String get screening_report_delete_success => 'Report deleted successfully';

  @override
  String get screening_report_finalize_success => 'Reports marked as ready';

  @override
  String get profile_patient_title => 'My Health Profile';

  @override
  String get profile_professional_title => 'My Profile';

  @override
  String get profile_not_found => 'No profile data found';

  @override
  String get profile_professional_verified_label => 'Verified';

  @override
  String get profile_professional_unverified_label => 'Unverified';

  @override
  String profile_verified_since_date(String date) {
    return 'Since: $date';
  }

  @override
  String get profile_patient_info_section => 'Profile Information';

  @override
  String get profile_patient_basic_info => 'Basic Information';

  @override
  String get profile_patient_medical_history_n_risk_factor =>
      'Medical History & Risk Factors';

  @override
  String get profile_patient_lifestyle_n_selfcare => 'Lifestyle & Self Care';

  @override
  String get profile_patient_physical_sign => 'Physical Sign';

  @override
  String get profile_patient_mental_state => 'Mental State';

  @override
  String get profile_patient_health_record_section => 'Health Records';

  @override
  String get profile_patient_medical_record => 'Medical Records';

  @override
  String get profile_patient_pharmacogenomics => 'Pharmacogenomics Profile';

  @override
  String get profile_patient_wellness_genomics => 'Wellness Genomics Profile';

  @override
  String get profile_all_my_appointments => 'All My Appointments';

  @override
  String get profile_professional_panel_section => 'Professional Panel';

  @override
  String get profile_professional_edit_profile => 'Edit Professional Profile';

  @override
  String get profile_professional_my_services => 'My Services';

  @override
  String get profile_professional_my_schedule => 'My Schedule';

  @override
  String get profile_admin_panel_section => 'Admin Panel';

  @override
  String get profile_admin_manage_services => 'Manage Services';

  @override
  String get profile_admin_manage_health_screening_services =>
      'Manage Health Screening Services';

  @override
  String get profile_admin_verify_professional => 'Verify Professionals';

  @override
  String get profile_admin_homecare_config => 'Homecare Configuration';

  @override
  String get settings => 'Settings';

  @override
  String get settings_app_language => 'App Language';

  @override
  String get auth_logout => 'Logout';

  @override
  String get profile_info_title => 'Profile Information';

  @override
  String get profile_info_profile_image => 'Profile Image';

  @override
  String get profile_info_remove_image => 'Remove Image';

  @override
  String get profile_info_home_address => 'Home Address';

  @override
  String get profile_info_select_map_location_hint =>
      'Tap to select location on map';

  @override
  String get profile_info_drug_allergies => 'Drug Allergies';

  @override
  String get risk_factor_title => 'Medical History & Risk Factors';

  @override
  String get medical_record_title => 'Medical Records';

  @override
  String get medical_record_empty => 'No medical records found.';

  @override
  String get medical_record_confirm_delete_dialog_title =>
      'Delete Medical Record?';

  @override
  String get medical_record_confirm_delete_dialog_content =>
      'Are you sure you want to delete this medical record?';

  @override
  String get medical_record_patient_status => 'Patient Status';

  @override
  String get medical_record_disease_name => 'Disease Name';

  @override
  String get medical_record_disease_history => 'Disease History';

  @override
  String get medical_record_special_consideration => 'Special Consideration';

  @override
  String get medical_record_records_file => 'Records File';

  @override
  String get medical_record_download_file_btn => 'Download File';

  @override
  String get medical_record_view_file_btn => 'View File';

  @override
  String get diabetic_retinal_photography =>
      'Diabetic Retinal\nPhotography (DRP)';

  @override
  String get diabetic_retinal_photography_desc =>
      'A common eye disease among diabetic\npatients. Blood capillaries may bleed\nand damage the retina, potentially\nleading to blindness. Regular\ndiabetic retinal photography\ncan detect and monitor your eyes.';

  @override
  String get diabetic_foot_screening => 'Diabetic Foot Screening\n (DFS)';

  @override
  String get diabetic_foot_screening_desc =>
      'Conducted by trained nurses, who will\nalso educate on proper footcare and\ngood sugar control. Referrals to\nfootcare specialists will be made\nwhere appropriate.';

  @override
  String get diabetic_care_title => 'Diabetic Care';

  @override
  String get common_book_now => 'Book Now';

  @override
  String get diabetes_form_submit_failed => 'Failed to submit form.';

  @override
  String get common_error_title => 'Error';

  @override
  String get diabetes_form_load_failed => 'Failed to load form data.';

  @override
  String get common_next => 'Next';

  @override
  String get common_submit => 'Submit';

  @override
  String get diabetes_form_title => 'Diabetes Form';

  @override
  String get diabetes_history_title => 'Diabetes History';

  @override
  String get diabetes_type_label => 'Type of Diabetes';

  @override
  String get common_not_specified => 'Not specified';

  @override
  String get year_of_diagnosis_label => 'Year of Diagnosis';

  @override
  String get last_hba1c_label => 'Last HbA1c';

  @override
  String get current_treatment_label => 'Current Treatment';

  @override
  String get risk_factors_title => 'Medical History & Risk Factors';

  @override
  String get hypertension_label => 'High Blood Pressure';

  @override
  String get dyslipidemia_label => 'High Cholesterol';

  @override
  String get cardiovascular_disease_label => 'Heart Disease';

  @override
  String get eye_disease_label => 'Eye Disease (Retinopathy)';

  @override
  String get neuropathy_label => 'Nerve Damage';

  @override
  String get kidney_disease_label => 'Kidney Disease';

  @override
  String get family_history_label => 'Family History';

  @override
  String get smoking_label => 'Smoking';

  @override
  String get lifestyle_self_care_title => 'Lifestyle & Self-Care';

  @override
  String get recent_hypoglycemia_label => 'Recent Hypoglycemia';

  @override
  String get physical_activity_label => 'Physical Activity';

  @override
  String get diet_quality_label => 'Diet Quality';

  @override
  String get physical_signs_title => 'Physical Signs';

  @override
  String get physical_signs_if_have_title => 'Physical Signs (If Have)';

  @override
  String get eyes_last_exam_label => 'Eyes (Last Exam)';

  @override
  String get eyes_findings_label => 'Eyes (Findings)';

  @override
  String get kidneys_egfr_label => 'Kidneys (eGFR)';

  @override
  String get kidneys_urine_acr_label => 'Kidneys (Urine ACR)';

  @override
  String get feet_skin_label => 'Feet (Skin)';

  @override
  String get feet_deformity_label => 'Feet (Deformity)';

  @override
  String get common_edit_information => 'Edit Information';

  @override
  String get diabetes_type_question => 'Type of Diabetes:';

  @override
  String get diabetes_type_1 => 'Type 1';

  @override
  String get diabetes_type_2 => 'Type 2';

  @override
  String get diabetes_type_gestational => 'Gestational';

  @override
  String get common_other => 'Other';

  @override
  String get enter_diabetes_type_hint => 'Please enter your type of diabetes';

  @override
  String get specify_diabetes_type_error =>
      'Please specify your type of diabetes.';

  @override
  String get year_of_diagnosis_question => 'Year of Diagnosis:';

  @override
  String get year_hint => 'e.g 2021';

  @override
  String get invalid_year_error => 'Invalid year.';

  @override
  String get last_hba1c_question => 'Last HbA1c:';

  @override
  String get invalid_value_error => 'Invalid value.';

  @override
  String get current_treatment_question => 'Current Treatment:';

  @override
  String get treatment_diet_exercise => 'Diet & Exercise';

  @override
  String get treatment_oral_medications => 'Oral Medications';

  @override
  String get list_medications_hint => 'List medications...';

  @override
  String get list_medications_error => 'Please list your oral medications.';

  @override
  String get treatment_insulin => 'Insulin';

  @override
  String get insulin_type_dose_hint => 'Type & dose';

  @override
  String get insulin_type_dose_error =>
      'Please specify your insulin type & dose.';

  @override
  String get answer_all_questions_error =>
      'Please answer all questions on this page.';

  @override
  String get recent_hypoglycemia_question => 'Recent Hypoglycemia:';

  @override
  String get hypoglycemia_none => 'None';

  @override
  String get hypoglycemia_mild => 'Mild';

  @override
  String get hypoglycemia_severe => 'Severe';

  @override
  String get physical_activity_question => 'Physical Activity:';

  @override
  String get activity_regular => 'Regular';

  @override
  String get activity_occasional => 'Occasional';

  @override
  String get activity_sedentary => 'Sedentary';

  @override
  String get diet_quality_question => 'Diet Quality:';

  @override
  String get diet_healthy => 'Healthy';

  @override
  String get diet_needs_improvement => 'Needs Improvement';

  @override
  String get eyes_label => 'Eyes:';

  @override
  String get last_exam_date_label => 'Last Exam Date';

  @override
  String get invalid_date_format_error => 'Invalid format (Use YYYY-MM-DD)';

  @override
  String get invalid_date_error => 'Invalid date.';

  @override
  String get findings_label => 'Findings';

  @override
  String get kidneys_label => 'Kidneys:';

  @override
  String get feet_label => 'Feet:';

  @override
  String get skin_label => 'Skin:';

  @override
  String get skin_normal => 'Normal';

  @override
  String get skin_dry => 'Dry';

  @override
  String get skin_ulcer => 'Ulcer';

  @override
  String get skin_infection => 'Infection';

  @override
  String get deformity_label => 'Deformity:';

  @override
  String get deformity_none => 'None';

  @override
  String get deformity_bunions => 'Bunions';

  @override
  String get deformity_claw_toes => 'Claw toes';

  @override
  String get smoking_current => 'Current';

  @override
  String get smoking_former => 'Former';

  @override
  String get smoking_never => 'Never';

  @override
  String get family_history_diabetes_label => 'Family History of Diabetes';

  @override
  String get common_none => 'None';

  @override
  String get common_upload_tap => 'Tap to upload your report';

  @override
  String get common_ready => 'Ready';

  @override
  String get common_full_report_file => 'Full Report File';

  @override
  String get common_ok => 'OK';

  @override
  String get common_coming_soon => 'Coming Soon';

  @override
  String get common_feature_available_soon =>
      'This feature will be available soon!';

  @override
  String get mental_state_title => 'Mental State';

  @override
  String get mental_state_current_section => 'Mental State (Current)';

  @override
  String get mental_state_overall_mood => 'Overall Mood:';

  @override
  String get mental_state_anxiety_level => 'Anxiety Level:';

  @override
  String get mental_state_stress_level => 'Stress Level:';

  @override
  String get mental_state_energy_level => 'Energy Level:';

  @override
  String get mental_state_focus_level => 'Focus Level:';

  @override
  String get mental_state_sleep_quality => 'Sleep Quality:';

  @override
  String get mental_state_notes_label => 'Notes/Events affecting your mood:';

  @override
  String get mental_state_notes_hint => 'Additional notes';

  @override
  String get pharmacogenomics_profile_title => 'Pharmagenomic Profile';

  @override
  String get pharmacogenomics_delete_report_title => 'Delete Report';

  @override
  String get pharmacogenomics_delete_report_content =>
      'Are you sure you want to delete this report file?';

  @override
  String get wellness_genomics_profile_title => 'Wellness Genomics Profile';

  @override
  String get settings_language_title => 'App Languages Setting';

  @override
  String get language_en => 'English (en)';

  @override
  String get language_zh => 'Chinese (zh)';

  @override
  String get language_id => 'Indonesian (id)';

  @override
  String get auth_sign_in_title => 'Login Here';

  @override
  String get auth_welcome_back => 'Welcome Back you\'ve\nbeen missed';

  @override
  String get auth_email_hint => 'Email';

  @override
  String get auth_password_hint => 'Password';

  @override
  String get auth_forgot_password_btn => 'Forgot Password?';

  @override
  String get auth_sign_in_btn => 'Sign In';

  @override
  String get auth_create_account => 'Create new account';

  @override
  String get auth_continue_with => 'Or continue with';

  @override
  String get auth_error_title => 'Error';

  @override
  String get auth_fill_email_password_error =>
      'Please fill in both Email and Password.';

  @override
  String get auth_fill_all_fields_error =>
      'Please fill in all fields correctly.';

  @override
  String get auth_select_role_error => 'Please select a user type';

  @override
  String get auth_select_role_first_error => 'Please select a user type first';

  @override
  String get auth_passwords_do_not_match => 'Passwords do not match';

  @override
  String get auth_enter_valid_email => 'Please enter a valid email';

  @override
  String get auth_enter_email => 'Please enter your email';

  @override
  String get auth_enter_password => 'Please enter a password';

  @override
  String get auth_password_length_error =>
      'Password must be at least 6 characters';

  @override
  String get auth_enter_username => 'Please enter a username';

  @override
  String get auth_confirm_password_hint => 'Confirm Password';

  @override
  String get auth_username_hint => 'Username';

  @override
  String get auth_select_user_type_hint => 'Select User Type';

  @override
  String get auth_role_patient => 'Patient';

  @override
  String get auth_role_nurse => 'Nurse';

  @override
  String get auth_role_pharmacist => 'Pharmacist';

  @override
  String get auth_role_radiologist => 'Radiologist';

  @override
  String get auth_role_caregiver => 'Caregiver/Helper';

  @override
  String get auth_role_physiotherapist => 'Physiotherapist';

  @override
  String get auth_sign_up_title => 'Create Account';

  @override
  String get auth_sign_up_subtitle =>
      'Create an account so you can explore all the\nexisting jobs';

  @override
  String get auth_sign_up_btn => 'Sign Up';

  @override
  String get auth_already_have_account => 'Already have an account';

  @override
  String get auth_registration_successful_title => 'Registration Successful';

  @override
  String get auth_registration_successful_content =>
      'Please check your email for verification.';

  @override
  String get auth_complete_registration_title => 'Complete Registration';

  @override
  String get auth_complete_registration_content =>
      'Welcome!\nPlease select your account type to continue.';

  @override
  String get auth_forgot_password_title => 'Forgot Password?';

  @override
  String get auth_forgot_password_subtitle =>
      'Don\'t worry! Please enter the email address linked with your account.';

  @override
  String get auth_enter_email_hint => 'Enter your email';

  @override
  String get auth_send_code_btn => 'Send Code';

  @override
  String get auth_otp_sent_success => 'OTP sent successfully';

  @override
  String get auth_otp_verification_title => 'Enter Verification Code';

  @override
  String auth_otp_verification_subtitle(String email) {
    return 'Enter the code that we have sent to your email $email';
  }

  @override
  String get auth_verify_btn => 'Verify';

  @override
  String get auth_resend_code => 'Didn\'t receive the code? Resend';

  @override
  String auth_resend_in_seconds(int seconds) {
    return 'Resend in $seconds seconds';
  }

  @override
  String get auth_code_resent => 'Code resent!';

  @override
  String get auth_pin_incorrect => 'Pin is incorrect';

  @override
  String get auth_reset_password_title => 'Reset Password';

  @override
  String get auth_reset_password_subtitle => 'Please enter your new password';

  @override
  String get auth_new_password_hint => 'New Password';

  @override
  String get auth_confirm_password_error => 'Please confirm your password';

  @override
  String get auth_reset_password_btn => 'Reset Password';

  @override
  String get auth_reset_password_success_title => 'Password Reset Successful!';

  @override
  String get auth_reset_password_success_content =>
      'You have successfully reset your password. Please use your new password when logging in.';

  @override
  String get auth_back_to_login_btn => 'Back to Login';

  @override
  String get booking_nursing_primary_title => 'Primary Nursing';

  @override
  String get booking_nursing_primary_desc =>
      'Monitor and administer\nnursing procedures from\nbody checking, Medication,\ntube feed and suctioning to\ninjections and wound care.';

  @override
  String get booking_nursing_specialized_title =>
      'Specialized Nursing Services';

  @override
  String get booking_nursing_specialized_desc =>
      'Focus on recovery and leave\nthe complex nursing care in\nthe hands of our experienced\nnurse Care Pros';

  @override
  String get booking_nursing_page_title => 'Home Nursing';

  @override
  String get booking_pharmacy_page_title => 'iRX Pharmacist Service';

  @override
  String get booking_pharmacy_medication_counseling_title =>
      'Medication Counseling\nand Education';

  @override
  String get booking_pharmacy_medication_counseling_desc =>
      'Medication counseling and education guide\npatients on proper use, side effects, and\nadherence to prescriptions,\nenhancing safety and\nimproving health outcomes.';

  @override
  String get booking_pharmacy_therapy_review_title =>
      'Comprehensive Therapy\nReview';

  @override
  String get booking_pharmacy_therapy_review_desc =>
      'Comprehensive review of your medication\nand lifestyle to optimize treatment\noutcomes and minimize potential side\neffects';

  @override
  String get booking_pharmacy_health_coaching_title => 'Health Coaching';

  @override
  String get booking_pharmacy_health_coaching_desc =>
      'Personalized guidance and support to help\nindividuals achieve their health goals, manage\nchronic conditions, and improve overall well-\nbeing, with specialized programs for weight\nmanagement, diabetes management, high\nblood pressure management, and high\ncholesterol management';

  @override
  String get booking_pharmacy_smoking_cessation_title => 'Smoking Cessation';

  @override
  String get booking_pharmacy_smoking_cessation_desc =>
      'Smoking cessation involves quitting\nsmoking through strategies like\ncounseling, medications, and support\nprograms to improve health and\nreduce the risk of smoking-related\ndiseases.';

  @override
  String get booking_issue_list_title_nursing => 'Nurse Services Case';

  @override
  String get booking_issue_list_title_pharmacy => 'Pharmacist Services Case';

  @override
  String get booking_issue_list_title_radiology => 'Radiologist Services Case';

  @override
  String get booking_issue_list_title_default => 'Service Case';

  @override
  String get booking_tell_us_concern => 'Tell Us Your Concern';

  @override
  String get booking_issue_empty =>
      'There are no issues added yet.\n Please add one or more issues so\nyou can proceed to the next step.';

  @override
  String get booking_add_issue_btn => 'Add an Issue';

  @override
  String get booking_next_btn => 'Next';

  @override
  String get booking_issue_delete_dialog_title => 'Delete Issue';

  @override
  String get booking_issue_delete_dialog_content =>
      'Are you sure you want to delete this issue?';

  @override
  String get booking_issue_form_add_title => 'Add an Issue';

  @override
  String get booking_issue_form_edit_title => 'Edit Issue';

  @override
  String get booking_issue_form_instruction => 'Tell us your concerns';

  @override
  String get booking_issue_form_title_hint => 'Issue Title';

  @override
  String get booking_issue_form_desc_hint =>
      'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.';

  @override
  String get booking_issue_form_images_label => 'Images';

  @override
  String get booking_issue_form_update_btn => 'Update';

  @override
  String get booking_issue_form_add_btn => 'Add';

  @override
  String get booking_issue_form_required_error =>
      'Issue title and description are required.';

  @override
  String get booking_issue_form_success_update => 'Issue updated successfully';

  @override
  String get booking_issue_form_success_add => 'Issue added successfully';

  @override
  String get booking_health_status_title => 'Personal Case Detail';

  @override
  String get booking_health_status_mobility_label =>
      'Select your mobility status';

  @override
  String get booking_health_status_record_label =>
      'Select a related health record';

  @override
  String get booking_health_status_record_hint => 'Please select a record';

  @override
  String get booking_health_status_no_records =>
      'No medical records available.';

  @override
  String get booking_addon_nursing_title => 'Nursing Procedures';

  @override
  String get booking_addon_specialized_nursing_title =>
      'Specialized Nursing Procedures';

  @override
  String get booking_addon_pharmacy_title => 'Pharmacy Services';

  @override
  String get booking_addon_radiology_title => 'Radiology Services';

  @override
  String get booking_addon_default_title => 'Add On Services';

  @override
  String get booking_addon_empty => 'No add-on services available.';

  @override
  String get booking_estimated_budget => 'Estimated Budget';

  @override
  String get booking_book_appointment_btn => 'Book Appointment';

  @override
  String get booking_professional_search_nurse => 'Search Nurse';

  @override
  String get booking_professional_search_pharmacist => 'Search Pharmacist';

  @override
  String get booking_professional_search_radiologist => 'Search Radiologist';

  @override
  String get booking_professional_search_caregiver =>
      'Search Caregiver/Helper/Worker';

  @override
  String get booking_professional_search_default => 'Search Professional';

  @override
  String booking_professional_filter_text(int count) {
    return 'Filtering by $count selected services';
  }

  @override
  String get booking_professional_empty =>
      'No professionals found matching your criteria.';

  @override
  String get booking_professional_appointment_btn => 'Appointment';

  @override
  String get booking_professional_detail_nurse => 'Nurse Details';

  @override
  String get booking_professional_detail_pharmacist => 'Pharmacist Details';

  @override
  String get booking_professional_detail_radiologist => 'Radiologist Details';

  @override
  String get booking_professional_detail_default => 'Professional Details';

  @override
  String get booking_professional_patients_label => 'Patients';

  @override
  String get booking_professional_experience_label => 'Experience';

  @override
  String get booking_professional_rating_label => 'Rating';

  @override
  String get booking_professional_about_me => 'About Me';

  @override
  String get booking_professional_working_info => 'Working Information';

  @override
  String get booking_professional_certificate => 'Professional Certificate';

  @override
  String get booking_professional_no_certificate => 'No certificate available.';

  @override
  String booking_professional_id_number(String number) {
    return 'ID Number: $number';
  }

  @override
  String booking_professional_issued_on(String date) {
    return 'Issued: $date';
  }

  @override
  String get booking_professional_reviews => 'Reviews';

  @override
  String get booking_professional_see_all => 'See All';

  @override
  String get booking_professional_no_reviews => 'No reviews available yet.';

  @override
  String get booking_professional_schedule_btn => 'Schedule Appointment';

  @override
  String get booking_schedule_title => 'Select Schedule';

  @override
  String get booking_schedule_select_date => 'Select Date';

  @override
  String get booking_schedule_select_hour => 'Select Hour';

  @override
  String get booking_schedule_no_slots => 'No available slots for this day.';

  @override
  String get booking_schedule_submit_btn => 'Submit';

  @override
  String get booking_schedule_submitting => 'Submitting...';

  @override
  String get booking_schedule_reschedule_success =>
      'Appointment rescheduled successfully';

  @override
  String get booking_schedule_reschedule_failed => 'Rescheduling failed.';

  @override
  String get booking_appointment_created_success =>
      'Appointment created successfully';

  @override
  String get booking_appointment_created_failed =>
      'Failed to create appointment';

  @override
  String get chat_pharma_title => 'AI Pharmacist';

  @override
  String get chat_pharma_online => 'Online';

  @override
  String get chat_pharma_privacy => '(HIPAA Privacy)';

  @override
  String get chat_pharma_need_help => 'Need Help? ';

  @override
  String get chat_pharma_request_help => 'Request help from the Pharmacist';

  @override
  String get chat_pharma_input_hint => 'Write your message';

  @override
  String get common_unknown_location => 'Unknown Location';

  @override
  String get booking_personal_issue_concern => 'Concern / Question';

  @override
  String booking_personal_issue_updated_on(String date) {
    return 'Updated on: $date';
  }

  @override
  String get booking_personal_issue_images => 'Images';

  @override
  String get booking_mobility_bedbound => 'Bedbound';

  @override
  String get booking_mobility_wheelchair_bound => 'Wheelchair';

  @override
  String get booking_mobility_walking_aid => 'With Walking Aid';

  @override
  String get booking_mobility_mobile_without_aid =>
      'Independent without Walking Aid';

  @override
  String get home_health_screening_title => 'Home Health Screening';

  @override
  String get home_health_at_home_diagnostic => 'At-home diagnostic tests';

  @override
  String get home_health_at_home_diagnostic_desc =>
      'Patients collect samples at home using a self-collection kit, which includes materials like swabs, test cards, and collection tubes, and submit them to a CLIA/CAP certified lab (telemedicine lab) for processing. Laboratory technicians process these samples and upload results to an online portal. Primary care doctors, specialists, or other healthcare professionals review results and walk patients through next steps.';

  @override
  String get home_health_point_of_care => 'Point-of-care tests';

  @override
  String get home_health_point_of_care_desc =>
      'Diagnostics done outside of a lab that patients can take by themselves at home. These tests develop rapidly and produce results without a doctor or lab technician present. With point-of-care tests, patients review results outside a medical setting and determine their own next steps.';

  @override
  String get home_health_screening_booked_success =>
      'Screening appointment booked successfully!';

  @override
  String get home_health_screening_booking_failed => 'Booking failed';

  @override
  String get homecare_elderly_title => 'Home Care for Elderly';

  @override
  String get homecare_house_bedding_cleaning => 'House & Bedding Cleaning';

  @override
  String get homecare_house_bedding_cleaning_desc =>
      'Regular cleaning services to maintain a hygienic, comfortable, and safe living environment for the elderly.';

  @override
  String get homecare_living_security_safety => 'Living Security & Safety';

  @override
  String get homecare_living_security_safety_desc =>
      'Safety checks and organization to reduce risks and create a secure living environment.';

  @override
  String get homecare_kitchen_bathroom_repair => 'Kitchen & Bathroom Repair';

  @override
  String get homecare_kitchen_bathroom_repair_desc =>
      'On-demand minor repairs to maintain functionality and safety in key home areas.';

  @override
  String get homecare_plus_active => 'Homecare Plus Active';

  @override
  String get homecare_get_plus => 'Get Homecare Plus';

  @override
  String homecare_balance(int balance) {
    return 'Balance: $balance Hours';
  }

  @override
  String homecare_subscription_offer(int quota, String price) {
    return '$quota Hours for $price';
  }

  @override
  String get homecare_request_services_btn => 'Request Services';

  @override
  String get homecare_select_at_least_one_task =>
      'Please select at least one task.';

  @override
  String get homecare_task_list_title => 'Task List';

  @override
  String get homecare_feature_name => 'FEATURE NAME';

  @override
  String get homecare_frequency => 'FREQUENCY';

  @override
  String get homecare_weekly => 'Weekly';

  @override
  String get homecare_monthly => 'Monthly';

  @override
  String get homecare_as_needed => 'As Needed';

  @override
  String get homecare_review_checkout_title => 'Review & Checkout';

  @override
  String get homecare_requested_tasks => 'Requested Tasks';

  @override
  String get homecare_billing_option => 'Billing Option';

  @override
  String get homecare_hourly_rate => 'Hourly Rate';

  @override
  String get homecare_use_subscription_balance => 'Use Subscription Balance';

  @override
  String homecare_deduct_hours(int hours, int balance) {
    return 'Deduct $hours Hours (Balance: $balance h)';
  }

  @override
  String homecare_insufficient_balance(int balance) {
    return 'Insufficient Balance ($balance h)';
  }

  @override
  String get homecare_confirm_booking_btn => 'Confirm Booking';

  @override
  String get homecare_subscription_plans_title => 'Subscription Plans';

  @override
  String homecare_care_hours(int hours) {
    return '$hours Hours of Care';
  }

  @override
  String homecare_valid_for_days(int days) {
    return 'Valid for $days Days';
  }

  @override
  String get homecare_experienced_caregivers => 'Experienced Caregivers';

  @override
  String get homecare_active_subscription => 'Active Subscription';

  @override
  String homecare_expires_on(String date) {
    return 'Expires on $date';
  }

  @override
  String homecare_purchase_now(String price) {
    return 'Purchase Now - $price';
  }

  @override
  String get precision_nutrition_title => 'Precision Nutrition';

  @override
  String get precision_assessment_title => 'Precision Nutrition Assessment';

  @override
  String get precision_assessment_desc =>
      'Start your journey with a deep analysis of your genes, metabolism and lifestyle to understand your body\'s unique needs.';

  @override
  String get precision_plan_title => 'Precision Nutrition Plan';

  @override
  String get precision_plan_desc =>
      'Receive a personalized nutrition strategy crafted by experts to address your specific health goals and conditions.';

  @override
  String get precision_implementation_title =>
      'Precision Nutrition Implementation';

  @override
  String get precision_implementation_desc =>
      'Track progress and adapt your plan through continuous support, biomarker monitoring, and smart digital tools.';

  @override
  String get precision_start_now => 'Start Now';

  @override
  String get precision_book_now => 'Book Now';

  @override
  String get precision_main_concern_question => 'What is your main concern?';

  @override
  String get precision_main_concern_subtitle =>
      'Choose the area that best describes your primary health goal';

  @override
  String get precision_sub_health => 'Sub-Health';

  @override
  String get precision_sub_health_desc =>
      'Improve overall wellness and energy levels';

  @override
  String get precision_chronic_disease => 'Chronic Disease';

  @override
  String get precision_chronic_disease_desc =>
      'Manage and improve chronic health conditions';

  @override
  String get precision_anti_aging => 'Anti-aging';

  @override
  String get precision_anti_aging_desc =>
      'Optimize health and vitality as you age';

  @override
  String get precision_basic_info_title => 'Basic Info & Health History';

  @override
  String get precision_age_label => 'Age';

  @override
  String get precision_age_hint => 'E.g 34 years old';

  @override
  String get precision_age_error => 'Please enter your age';

  @override
  String get precision_age_valid_error => 'Please enter a valid age';

  @override
  String get precision_gender_label => 'Gender';

  @override
  String get precision_gender_error => 'Please select your gender';

  @override
  String get precision_known_condition_label => 'Known Condition (Optional)';

  @override
  String get precision_known_condition_hint =>
      'Write your condition history here';

  @override
  String get precision_special_consideration_title =>
      'Patient with Special Consideration';

  @override
  String get precision_medication_history_label =>
      'Medication & supplement history';

  @override
  String get precision_medication_history_hint =>
      'E.g: Avoid Clopidogrel, Ondansetron, etc';

  @override
  String get precision_family_history_label => 'Family health history';

  @override
  String get precision_family_history_hint =>
      'Write other biomarkers here (minimum 10 characters)';

  @override
  String get precision_family_history_error =>
      'Please enter at least 10 characters';

  @override
  String get precision_self_rated_health_title => 'Self-Rated Health';

  @override
  String get precision_terrible => 'Terrible';

  @override
  String get precision_bad => 'Bad';

  @override
  String get precision_neutral => 'Neutral';

  @override
  String get precision_good => 'Good';

  @override
  String get precision_excellent => 'Excellent';

  @override
  String get precision_its_terrible => 'It\'s terrible';

  @override
  String get precision_its_bad => 'It\'s bad';

  @override
  String get precision_its_good => 'It\'s good';

  @override
  String get precision_its_very_good => 'It\'s very good';

  @override
  String get precision_lifestyle_habits_title => 'Lifestyle & Habits';

  @override
  String get precision_sleep_hours_question =>
      'How many hours of sleep do you get per night?';

  @override
  String precision_hours_per_day(String hours) {
    return '$hours hours per day';
  }

  @override
  String get precision_activity_level_label =>
      'Describe your typical daily activity level';

  @override
  String get precision_activity_level_hint =>
      'E.g Working behind the desk 8 hours per day';

  @override
  String get precision_activity_level_error =>
      'Please describe your activity level';

  @override
  String get precision_exercise_frequency_label =>
      'How often do you exercise per week?';

  @override
  String get precision_exercise_frequency_hint =>
      'E.g: Around 30 minutes per day';

  @override
  String get precision_exercise_frequency_error =>
      'Please describe your exercise frequency';

  @override
  String get precision_stress_level_label => 'Stress levels';

  @override
  String get precision_stress_level_hint => 'E.g: Intermediate stress level';

  @override
  String get precision_stress_level_error =>
      'Please describe your stress level';

  @override
  String get precision_smoking_alcohol_label => 'Smoking or alcohol habits?';

  @override
  String get precision_smoking_alcohol_hint => 'E.g: Heavy smoking';

  @override
  String get precision_smoking_alcohol_error =>
      'Please describe your smoking/alcohol habits';

  @override
  String get precision_nutrition_habits_title => 'Nutrition Habits';

  @override
  String get precision_meal_frequency_label =>
      'Describe your daily meal frequency';

  @override
  String get precision_meal_frequency_hint => 'E.g Twice a day';

  @override
  String get precision_meal_frequency_error =>
      'Please describe your meal frequency';

  @override
  String get precision_food_sensitivities_label =>
      'Known food sensitivities or allergies';

  @override
  String get precision_food_sensitivities_hint =>
      'E.g: Seafoods such as shrimp';

  @override
  String get precision_food_sensitivities_error =>
      'Please describe your food sensitivities';

  @override
  String get precision_favorite_foods_label => 'Favorite food types';

  @override
  String get precision_favorite_foods_hint =>
      'E.g: Chicken, Healthy Soup, Meatball';

  @override
  String get precision_favorite_foods_error =>
      'Please describe your favorite foods';

  @override
  String get precision_avoided_foods_label => 'Avoided food types';

  @override
  String get precision_avoided_foods_hint => 'E.g: Seafood';

  @override
  String get precision_avoided_foods_error => 'Please describe foods you avoid';

  @override
  String get precision_water_intake_label => 'Water intake';

  @override
  String get precision_water_intake_hint => 'E.g: 7 glass per day';

  @override
  String get precision_water_intake_error =>
      'Please describe your water intake';

  @override
  String get precision_past_diets_label => 'Past diets';

  @override
  String get precision_past_diets_hint =>
      'E.g: Keto, low-carb, plant-based, raw food';

  @override
  String get precision_past_diets_error => 'Please describe your past diets';

  @override
  String get precision_biomarker_upload_title => 'Biomarker Upload';

  @override
  String get precision_upload_header =>
      'Upload your medical records and connect devices';

  @override
  String get precision_upload_subtitle =>
      'This helps us create a more accurate and personalized nutrition plan';

  @override
  String get precision_upload_medical_records => 'Upload Medical Records';

  @override
  String get precision_upload_medical_records_desc =>
      'Upload PDF, images, or other medical documents';

  @override
  String get precision_choose_file => 'Choose File';

  @override
  String get precision_connect_wearable => 'Connect Wearable Device';

  @override
  String get precision_connect_wearable_desc =>
      'Sync data from your smartwatch, fitness tracker, or other devices';

  @override
  String get precision_uploaded_files => 'Uploaded Files';

  @override
  String get precision_submit_assessment => 'Submit Assessment';

  @override
  String get precision_success_title => 'Success!';

  @override
  String get precision_success_content =>
      'Your Precision Nutrition Assessment has been submitted successfully. Our experts will review your information and create a personalized plan for you.';

  @override
  String get precision_view_details => 'View Details';

  @override
  String get precision_my_assessment_details =>
      'My Nutrition Assessment Details';

  @override
  String get precision_edit_information => 'Edit Information';

  @override
  String get precision_download_pdf => 'Download (PDF)';

  @override
  String get precision_back_to_page => 'Back to Precision Nutrition Page';

  @override
  String get precision_plan_my_plan => 'My Precision Nutrition Plan';

  @override
  String get precision_plan_tab_dietary => 'Dietary Plan';

  @override
  String get precision_plan_tab_supplements => 'Supplements';

  @override
  String get precision_plan_tab_lifestyle => 'Lifestyle';

  @override
  String get precision_plan_request_update => 'Request Plan Update';

  @override
  String get precision_plan_goal => 'GOAL';

  @override
  String get precision_plan_strategy => 'STRATEGY';

  @override
  String get precision_plan_daily_calory => 'DAILY CALORY TARGET';

  @override
  String get precision_plan_recommended_foods => 'Recommended Foods';

  @override
  String get precision_plan_foods_to_limit => 'Foods to Limit';

  @override
  String get precision_plan_weekly_meal_plan => 'Weekly Meal Plan';

  @override
  String get precision_plan_view_all => 'View All';

  @override
  String get precision_weekly_meal_plan_title => 'Weekly Meal Plan';

  @override
  String precision_day_meal_plan(String day) {
    return '$day Meal Plan';
  }

  @override
  String get precision_meal_breakfast => 'Breakfast';

  @override
  String get precision_meal_lunch => 'Lunch';

  @override
  String get precision_meal_dinner => 'Dinner';

  @override
  String get precision_implementation_journey => 'Implementation Journey';

  @override
  String get precision_implementation_indepth_assessment =>
      'In-Depth Assessment (2-4 weeks)';

  @override
  String get precision_implementation_intervention =>
      'Intervention (3-6 months)';

  @override
  String get precision_implementation_maintenance => 'Maintenance';

  @override
  String get precision_sub_health_metabolic =>
      'Metabolic Function Optimization';

  @override
  String get precision_sub_health_gut_brain => 'Gut-Brain Axis Regulation';

  @override
  String get precision_sub_health_immune => 'Immune Balance Intervention';

  @override
  String get precision_chronic_diabetes => 'Diabetes Management';

  @override
  String get precision_chronic_cardio => 'Cardiovascular Disease Support';

  @override
  String get precision_chronic_autoimmune => 'Autoimmune Disease Care';

  @override
  String get precision_chronic_obesity => 'Obesity Management';

  @override
  String get precision_anti_aging_cellular =>
      'Cellular Regeneration & Mitochondrial Health';

  @override
  String get precision_anti_aging_cognitive =>
      'Cognitive Longevity & Neuroprotection';

  @override
  String get precision_anti_aging_hormonal =>
      'Hormonal Balance & Vitality optimization';

  @override
  String get precision_anti_aging_skin => 'Skin & Structural Longevity';

  @override
  String get precision_learn_more => 'Learn More';

  @override
  String get precision_applicable_issues => 'APPLICABLE ISSUES';

  @override
  String get precision_services_include => 'SERVICES INCLUDE';

  @override
  String get precision_interventions_include => 'INTERVENTIONS INCLUDE';

  @override
  String get precision_solutions_include => 'SOLUTIONS INCLUDE';

  @override
  String get precision_technologies_used => 'TECHNOLOGIES USED';

  @override
  String get precision_programs_include => 'PROGRAMS INCLUDE';

  @override
  String get precision_precision_methods_include => 'PRECISION METHODS INCLUDE';

  @override
  String get day_monday => 'Monday';

  @override
  String get day_tuesday => 'Tuesday';

  @override
  String get day_wednesday => 'Wednesday';

  @override
  String get day_thursday => 'Thursday';

  @override
  String get day_friday => 'Friday';

  @override
  String get day_saturday => 'Saturday';

  @override
  String get day_sunday => 'Sunday';

  @override
  String get nutrition_protein => 'Protein';

  @override
  String get nutrition_carbs => 'Carbs';

  @override
  String get nutrition_fat => 'Fat';

  @override
  String get admin_homecare_service_rates => 'Service Rates';

  @override
  String get admin_homecare_subscription_plans => 'Subscription Plans';

  @override
  String get admin_homecare_update_successful => 'Update successful';

  @override
  String admin_homecare_update_failed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get admin_homecare_no_service_rates => 'No service rates found.';

  @override
  String get admin_homecare_no_subscription_plans =>
      'No subscription plans found.';

  @override
  String admin_homecare_edit_rate(String name) {
    return 'Edit Rate: $name';
  }

  @override
  String get admin_homecare_edit_plan => 'Edit Plan';

  @override
  String get admin_homecare_price => 'Price';

  @override
  String get admin_homecare_quota_hours => 'Quota (Hours)';

  @override
  String get admin_homecare_validity_days => 'Validity (Days)';

  @override
  String get admin_homecare_active => 'Active';

  @override
  String get admin_homecare_inactive => 'Inactive';

  @override
  String get admin_homecare_save_changes => 'Save Changes';

  @override
  String admin_homecare_plan_details(String price, int quota, int days) {
    return 'Price: \$$price | Quota: ${quota}h | Validity: ${days}d';
  }

  @override
  String get favourite_title => 'Favourites';

  @override
  String get favourite_no_favorites =>
      'You have no favorite professionals yet.';

  @override
  String favourite_error_fetching(String error) {
    return 'Error fetching data: $error';
  }

  @override
  String favourite_error_toggle(String error) {
    return 'Error: $error';
  }

  @override
  String get medical_store_title => 'Medical Store';

  @override
  String get medical_store_sort => 'Sort';

  @override
  String get medical_store_consumable_tab => 'Homecare Consumable';

  @override
  String get medical_store_poct_tab => 'Point of Care Testing';

  @override
  String get medical_store_no_products => 'No products available';

  @override
  String get medical_store_load_failed => 'Failed to load products';

  @override
  String get payment_title => 'Payment';

  @override
  String get payment_order_summary => 'Order Summary';

  @override
  String get payment_charge => 'Charge';

  @override
  String get payment_total => 'Total';

  @override
  String get payment_select_method => 'Select Payment Method';

  @override
  String get payment_confirm_btn => 'Confirm';

  @override
  String payment_pay_btn(String amount) {
    return 'Pay $amount';
  }

  @override
  String get payment_success_title => 'Payment Success';

  @override
  String payment_success_content(String name) {
    return 'Your money has been successfully sent to $name.';
  }

  @override
  String get payment_amount => 'Amount';

  @override
  String get payment_how_is_experience => 'How is your experience?';

  @override
  String get payment_feedback_help =>
      'Your feedback will help us to improve your\nexperience better';

  @override
  String get payment_please_feedback_btn => 'Please Feedback';

  @override
  String get payment_return_home_btn => 'Return to Home';

  @override
  String get payment_feedback_thank_you => 'Thank you for your feedback!';

  @override
  String get payment_feedback_success_content =>
      'This appointment has been completed and can be viewed in the completed orders menu';

  @override
  String get payment_view_detail_btn => 'View Detail';

  @override
  String get payment_excellent => 'Excellent';

  @override
  String payment_rated_text(String name, int stars) {
    return 'You rated $name $stars stars';
  }

  @override
  String get payment_write_text_hint => 'Write your text';

  @override
  String payment_give_tips(String name) {
    return 'Give some tips to $name';
  }

  @override
  String get payment_enter_other_amount => 'Enter other amount';

  @override
  String get payment_enter_amount_hint => 'Enter amount';

  @override
  String get payment_submit_btn => 'Submit';

  @override
  String payment_failed(String message) {
    return 'Payment Failed: $message';
  }

  @override
  String payment_feedback_failed(String message) {
    return 'Feedback Failed: $message';
  }

  @override
  String payment_purchase_failed(String message) {
    return 'Purchase Failed: $message';
  }

  @override
  String get payment_subscription_success_title => 'Payment Successful';

  @override
  String payment_subscription_success_content(String plan) {
    return 'You have successfully subscribed to $plan';
  }

  @override
  String get schedule_working_schedule_title => 'Working Schedule';

  @override
  String get schedule_weekly_hours_tab => 'Weekly Hours';

  @override
  String get schedule_date_specific_hours_tab => 'Date-specific Hours';

  @override
  String get schedule_preview_tab => 'Preview';

  @override
  String get schedule_unavailable => 'Unavailable';

  @override
  String get schedule_edit_hours => 'Edit Hours';

  @override
  String get schedule_add_hours => 'Add Hours';

  @override
  String get schedule_start => 'Start';

  @override
  String get schedule_end => 'End';

  @override
  String get schedule_please_select_time =>
      'Please select both start and end time.';

  @override
  String get schedule_end_time_error => 'End time must be after start time.';

  @override
  String get schedule_delete_time_block_title => 'Delete Time Block?';

  @override
  String schedule_delete_time_block_content(String start, String end) {
    return 'Are you sure you want to delete $start - $end?';
  }

  @override
  String get schedule_add_time_slot_title => 'Add Time Slot';

  @override
  String get schedule_add_btn => 'Add';

  @override
  String get schedule_revert_to_weekly => 'Revert to Weekly';

  @override
  String get schedule_i_am_unavailable => 'I am unavailable';

  @override
  String get schedule_mark_day_off => 'Mark this specific date as a Day Off';

  @override
  String get schedule_specific_hours => 'Specific Hours';

  @override
  String get schedule_no_slots_added =>
      'No slots added yet. You appear unavailable.';

  @override
  String get schedule_using_weekly => 'Using Weekly Schedule';

  @override
  String get schedule_customize_hours => 'Customize Hours for this Date';

  @override
  String get schedule_reset_default_title => 'Reset to Default?';

  @override
  String get schedule_reset_default_content =>
      'This will remove your custom settings for this day. The schedule will revert to your recurring weekly rules.';

  @override
  String get schedule_reset_btn => 'Reset';

  @override
  String get schedule_select_date => 'Select Date';

  @override
  String get schedule_available_hours => 'Available Hours';

  @override
  String get schedule_no_available_slots => 'No available slots for this day.';

  @override
  String get schedule_availability_added => 'Availability added!';

  @override
  String get schedule_availability_updated => 'Availability updated!';

  @override
  String get schedule_availability_removed => 'Availability removed!';

  @override
  String get schedule_reverted_success => 'Reverted to weekly schedule';

  @override
  String get schedule_updated_success => 'Schedule updated successfully';

  @override
  String get rpm_title => 'Monitor My Vitals';

  @override
  String get rpm_heart_performance => 'Heart Performance';

  @override
  String get rpm_blood_oxygen => 'Blood Oxygen Saturation (SpO2)';

  @override
  String get rpm_blood_glucose => 'Blood Glucose';

  @override
  String get rpm_blood_pressure => 'Blood Pressure';

  @override
  String get rpm_add_new_vital => '+ Add New Vital';

  @override
  String get rpm_link_device => 'Link Device';

  @override
  String get rpm_add_record => 'Add Record';

  @override
  String get second_opinion_title => 'Second Opinion';

  @override
  String get second_opinion_teleradiology_title => 'Teleradiology';

  @override
  String get second_opinion_teleradiology_desc =>
      'Discover expert second opinions on medical imaging from our specialized radiologists, guiding your healthcare decisions with focused knowledge in cardiovascular, musculoskeletal, head & neck, and neuro-imaging';

  @override
  String get second_opinion_telepathology_title => 'Telepathology';

  @override
  String get second_opinion_telepathology_desc =>
      'Our specialists leverage cutting-edge telemedicine tech for remote pathology image reviews and consultations with medical teams globally';

  @override
  String get teleradiology_title => 'Teleradiology';

  @override
  String get teleradiology_disease_name => 'Disease Name';

  @override
  String get teleradiology_disease_history => 'Disease History Description';

  @override
  String get teleradiology_disease_hint => 'E.g Diptheria, Pneumonia';

  @override
  String get teleradiology_other_biomarkers => 'Other Biomakers';

  @override
  String get teleradiology_history_hint =>
      'Enter disease history description here...';

  @override
  String get teleradiology_patient_info => 'Patient Information';

  @override
  String get teleradiology_biomarker_hint =>
      'Enter other biomarker information here...';

  @override
  String get teleradiology_radiology_images => 'Radiology Images';

  @override
  String get teleradiology_ct_scan => 'CT Scan';

  @override
  String get teleradiology_mri_scan => 'MRI Scan';

  @override
  String get teleradiology_mammogram => 'Mammogram';

  @override
  String get teleradiology_medical_opinion => 'Medical Opinion';

  @override
  String get teleradiology_professional_only_info =>
      '** Information below will be provided by Medical Professionals only';

  @override
  String get teleradiology_diagnostic_opinion => 'Diagnostic opinion';

  @override
  String get teleradiology_recommendation_opinion => 'Recommendation Opinion';

  @override
  String get physiotherapy_title => 'Physiotherapy';

  @override
  String get physiotherapy_musculoskeletal_title =>
      'Musculoskeletal Physiotherapy';

  @override
  String get physiotherapy_musculoskeletal_desc =>
      'Musculoskeletal physiotherapy treats injuries involving muscles, joints, bones, ligaments, tendons, and nerves.';

  @override
  String get physiotherapy_neurological_title => 'Neurological Physiotherapy';

  @override
  String get physiotherapy_neurological_desc =>
      'Neurological physiotherapy treats conditions affecting the nervous system, including the brain, spinal cord, and nerves.';

  @override
  String get physiotherapy_book_appointment => 'Book Appointment';

  @override
  String get physiotherapy_duration_label => 'DURATION';

  @override
  String get physiotherapy_duration_value => '45–60 minutes per session';

  @override
  String get physiotherapy_treatment_type_label => 'TREATMENT TYPE';

  @override
  String get physiotherapy_suitable_for_title =>
      'This Service is suitable for:';

  @override
  String get physiotherapy_what_you_get_title => 'What you’ll get';

  @override
  String get physiotherapy_ms_item_1 => 'Posture & movement correction';

  @override
  String get physiotherapy_ms_item_2 => 'Stretching & strengthening';

  @override
  String get physiotherapy_ms_item_3 => 'Exercise therapy';

  @override
  String get physiotherapy_ms_item_4 => 'Manual therapy';

  @override
  String get physiotherapy_ms_reason_1 => 'Overuse tendon injuries';

  @override
  String get physiotherapy_ms_reason_2 =>
      'Joint wear and tear (e.g. arthritis)';

  @override
  String get physiotherapy_ms_reason_3 => 'Muscle strain';

  @override
  String get physiotherapy_ms_reason_4 => 'Ligament sprain';

  @override
  String get physiotherapy_ms_reason_5 => 'Joint pain & stiffness';

  @override
  String get physiotherapy_ms_reason_6 => 'Movement-related pain';

  @override
  String get physiotherapy_ms_benefit_1 => 'Pain reduction';

  @override
  String get physiotherapy_ms_benefit_2 => 'Improved mobility';

  @override
  String get physiotherapy_ms_benefit_3 => 'Better joint function';

  @override
  String get physiotherapy_ms_benefit_4 => 'Easier daily activities';

  @override
  String get physiotherapy_ms_benefit_5 => 'Faster recovery';

  @override
  String get physiotherapy_neuro_item_1 => 'Strength & coordination exercises';

  @override
  String get physiotherapy_neuro_item_2 => 'Functional movement training';

  @override
  String get physiotherapy_neuro_item_3 => 'Balance & gait training';

  @override
  String get physiotherapy_neuro_item_4 => 'Neuro-motor training';

  @override
  String get physiotherapy_neuro_reason_1 => 'Stroke recovery';

  @override
  String get physiotherapy_neuro_reason_2 => 'Parkinson’s disease';

  @override
  String get physiotherapy_neuro_reason_3 => 'Multiple sclerosis';

  @override
  String get physiotherapy_neuro_reason_4 => 'Spinal cord injury';

  @override
  String get physiotherapy_neuro_reason_5 => 'Traumatic brain injury';

  @override
  String get physiotherapy_neuro_reason_6 => 'Nerve damage';

  @override
  String get physiotherapy_neuro_reason_7 => 'Balance & coordination disorders';

  @override
  String get physiotherapy_neuro_benefit_1 => 'Better movement control';

  @override
  String get physiotherapy_neuro_benefit_2 => 'Improved balance & coordination';

  @override
  String get physiotherapy_neuro_benefit_3 =>
      'Increased independence in daily activities';

  @override
  String get physiotherapy_neuro_benefit_4 => 'Reduced physical limitations';

  @override
  String get physiotherapy_neuro_benefit_5 =>
      'Improved confidence & well-being';

  @override
  String get physiotherapy_scheduling_duration => 'Duration';

  @override
  String physiotherapy_scheduling_minutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get physiotherapy_scheduling_select_date => 'Select Date';

  @override
  String get physiotherapy_scheduling_select_hour => 'Select Hour';

  @override
  String get physiotherapy_scheduling_no_slots =>
      'No available slots for this day.';

  @override
  String get physiotherapy_scheduling_failed_load_slots =>
      'Failed to load slots';

  @override
  String get physiotherapy_scheduling_submitting => 'Submitting...';

  @override
  String get physiotherapy_scheduling_submit => 'Submit';

  @override
  String get physiotherapy_flow_success => 'Appointment created successfully';

  @override
  String get physiotherapy_flow_failure => 'Failed to create appointment';

  @override
  String physiotherapy_flow_failure_with_reason(String reason) {
    return 'Failed to create appointment:\n$reason';
  }

  @override
  String physiotherapy_summary(int duration) {
    return 'Physiotherapy Session ($duration mins)';
  }
}
