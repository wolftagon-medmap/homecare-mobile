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
  String get appointment_title => 'Appointments';

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
}
