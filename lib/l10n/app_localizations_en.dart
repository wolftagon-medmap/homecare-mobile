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
  String get hypertension_label => 'Hypertension';

  @override
  String get dyslipidemia_label => 'Dyslipidemia';

  @override
  String get cardiovascular_disease_label => 'Cardiovascular Disease';

  @override
  String get eye_disease_label => 'Eye Disease (Retinopathy)';

  @override
  String get neuropathy_label => 'Neuropathy';

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
  String get common_ok => 'OK';
}
