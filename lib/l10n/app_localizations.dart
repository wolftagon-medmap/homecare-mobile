import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('zh')
  ];

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String common_error(String message);

  /// No description provided for @common_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get common_no;

  /// No description provided for @common_no_data.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get common_no_data;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get common_status;

  /// No description provided for @common_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get common_description;

  /// No description provided for @common_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get common_yes;

  /// No description provided for @common_complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get common_complete;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get common_saving;

  /// No description provided for @common_modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get common_modify;

  /// No description provided for @common_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get common_remove;

  /// No description provided for @common_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get common_updated_success;

  /// No description provided for @common_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get common_delete_success;

  /// Person's Name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Full name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// Age
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Age
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String age_years_old(int age);

  /// Gender
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Contact Number
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contact_number;

  /// Person's Address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Weight
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Height
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// None
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @created_on.
  ///
  /// In en, this message translates to:
  /// **'Created on: {date}'**
  String created_on(String date);

  /// Label for the last updated timestamp
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get last_updated;

  /// Label for the home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tab_home;

  /// Services
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Label for the Allied Health services
  ///
  /// In en, this message translates to:
  /// **'Allied Health'**
  String get allied_services;

  /// Label for the iRX Pharmacist Service
  ///
  /// In en, this message translates to:
  /// **'iRX Pharmacist Service'**
  String get pharmacist_services;

  /// Label for the Home Nursing service
  ///
  /// In en, this message translates to:
  /// **'Home Nursing'**
  String get nursing_service;

  /// Label for the Diabetic Care service
  ///
  /// In en, this message translates to:
  /// **'Diabetic Care'**
  String get diabetic_care_service;

  /// Label for the Home Health Screening service
  ///
  /// In en, this message translates to:
  /// **'Home Health Screening'**
  String get home_screening_service;

  /// Label for the Precision Nutrition service
  ///
  /// In en, this message translates to:
  /// **'Precision Nutrition'**
  String get precision_nutrition_service;

  /// Label for the Home Care for Elderly service
  ///
  /// In en, this message translates to:
  /// **'Home Care for Elderly'**
  String get homecare_for_elderly_service;

  /// Label for the Physiotherapy service
  ///
  /// In en, this message translates to:
  /// **'Physiotherapy'**
  String get physiotherapy_service;

  /// Label for the Remote Patient Monitoring service
  ///
  /// In en, this message translates to:
  /// **'Remote Patient Monitoring'**
  String get remote_patient_monitoring_service;

  /// Label for the 2nd Opinion for Medical Image service
  ///
  /// In en, this message translates to:
  /// **'2nd Opinion for Medical Image'**
  String get second_opinion_service;

  /// Label for the Health Risk Assessment service
  ///
  /// In en, this message translates to:
  /// **'Health Risk Assessment'**
  String get health_risk_assessment_service;

  /// Label for the Dietitian Service
  ///
  /// In en, this message translates to:
  /// **'Dietitian Service'**
  String get dietitian_service;

  /// Label for the Sleep & Mental Health service
  ///
  /// In en, this message translates to:
  /// **'Sleep & Mental Health'**
  String get sleep_and_mental_health_service;

  /// Greeting message on the dashboard
  ///
  /// In en, this message translates to:
  /// **'Live Longer & Live Healthier, {displayName}!'**
  String dashboard_greeting(String displayName);

  /// Placeholder text for the AI chat feature on the dashboard
  ///
  /// In en, this message translates to:
  /// **'Chat With AI doctor for all your health questions'**
  String get dashboard_chat_ai_placeholder;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// Title for the appointment list section
  ///
  /// In en, this message translates to:
  /// **'My Appointment'**
  String get appointment_list_title;

  /// Status appointment is upcoming
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get appointment_status_upcoming;

  /// Status appointment is pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get appointment_status_pending;

  /// Status appointment is waiting for approval
  ///
  /// In en, this message translates to:
  /// **'Waiting Approval'**
  String get appointment_status_waiting_approval;

  /// No description provided for @appointment_status_accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get appointment_status_accepted;

  /// Status appointment is completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get appointment_status_completed;

  /// Status appointment is cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get appointment_status_cancelled;

  /// Status appointment is missed
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get appointment_status_missed;

  /// Message displayed when there are no appointments found for a specific status
  ///
  /// In en, this message translates to:
  /// **'No {appointment_status} appointments found.'**
  String appointment_list_empty(String appointment_status);

  /// Label for the button to cancel an appointment booking
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get appointment_cancel_booking_btn;

  /// Label for the button to reschedule an appointment
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get appointment_reschedule_btn;

  /// Label for the button to book an appointment again
  ///
  /// In en, this message translates to:
  /// **'Book Again'**
  String get appointment_book_again_btn;

  /// Label for the button to rate an appointment
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get appointment_rating_btn;

  /// Label for the button to decline an appointment
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get appointment_decline_btn;

  /// Label for the button to accept an appointment
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get appointment_accept_btn;

  /// Label for the button to mark an appointment as complete
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get appointment_mark_complete_btn;

  /// Label for the button to confirm that a sample has been collected for a screening appointment
  ///
  /// In en, this message translates to:
  /// **'Confirm Sample Collected'**
  String get appointment_screening_confirm_sample_btn;

  /// Label for the button to upload a report for a screening appointment
  ///
  /// In en, this message translates to:
  /// **'Upload Report'**
  String get appointment_screening_upload_report_btn;

  /// No description provided for @appointment_arrange_video_consultation.
  ///
  /// In en, this message translates to:
  /// **'Arrange Video Consultation'**
  String get appointment_arrange_video_consultation;

  /// No description provided for @appointment_pay_btn.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get appointment_pay_btn;

  /// Title for the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Appointment Detail'**
  String get appointment_detail_title;

  /// Title for the appointment schedule section in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Appointment Schedule'**
  String get appointment_detail_schedule_title;

  /// Title for the patient information section in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get appointment_detail_patient_title;

  /// Title for the lab test information section in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Lab Test Information'**
  String get appointment_detail_lab_test_title;

  /// Label for the report section in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Reports} =1{Report} other{Reports}}'**
  String appointment_detail_report(int count);

  /// Label for the requested homecare tasks section in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Requested Homecare Tasks'**
  String get appointment_detail_requested_homecare_task;

  /// Message displayed when there are no requested homecare tasks in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'No specific homecare tasks requested.'**
  String get appointment_detail_requested_homecare_task_empty;

  /// Title for the patient problems section in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Patient Problems'**
  String get appointment_detail_patient_problem_title;

  /// Message displayed when there are no patient problems in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'No specific problem details provided.'**
  String get appointment_detail_patient_problem_empty;

  /// Title for the payment information section in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get appointment_detail_payment_title;

  /// Label for the estimated budget in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Estimated Budget'**
  String get appointment_detail_estimated_budget;

  /// No description provided for @appointment_detail_payment_details.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get appointment_detail_payment_details;

  /// Label for the payment date in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get appointment_detail_payment_date;

  /// Label for the payment method in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get appointment_detail_payment_method;

  /// Label for the order completed date in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get appointment_detail_order_completed_date;

  /// Label for the total amount in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String appointment_detail_total_amount(String amount);

  /// No description provided for @appointment_detail_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get appointment_detail_total_label;

  /// Label for the service requested in the appointment detail page
  ///
  /// In en, this message translates to:
  /// **'Services Requested'**
  String get appointment_detail_service_requested;

  /// Label for the appointment summary section
  ///
  /// In en, this message translates to:
  /// **'Summary:'**
  String get appointment_summary;

  /// Message displayed when an appointment is updated successfully
  ///
  /// In en, this message translates to:
  /// **'Appointment updated successfully'**
  String get appointment_update_success_message;

  /// No description provided for @appointment_accept_success_message.
  ///
  /// In en, this message translates to:
  /// **'Appointment accepted successfully'**
  String get appointment_accept_success_message;

  /// No description provided for @appointment_decline_success_message.
  ///
  /// In en, this message translates to:
  /// **'Appointment declined successfully'**
  String get appointment_decline_success_message;

  /// No description provided for @appointment_complete_success_message.
  ///
  /// In en, this message translates to:
  /// **'Appointment completed successfully'**
  String get appointment_complete_success_message;

  /// No description provided for @appointment_confirm_sample_success_message.
  ///
  /// In en, this message translates to:
  /// **'Sample collection confirmed successfully'**
  String get appointment_confirm_sample_success_message;

  /// No description provided for @appointment_mark_report_ready_success_message.
  ///
  /// In en, this message translates to:
  /// **'Report marked as ready'**
  String get appointment_mark_report_ready_success_message;

  /// No description provided for @appointment_cancel_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to cancel this appointment?'**
  String get appointment_cancel_dialog_content;

  /// No description provided for @appointment_cancel_dialog_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You can rebook it later from the canceled appointment menu.'**
  String get appointment_cancel_dialog_subtitle;

  /// No description provided for @appointment_complete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Complete Appointment'**
  String get appointment_complete_dialog_title;

  /// No description provided for @appointment_complete_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'Mark this appointment as completed?'**
  String get appointment_complete_dialog_content;

  /// No description provided for @appointment_accept_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Accept Appointment'**
  String get appointment_accept_dialog_title;

  /// No description provided for @appointment_accept_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this appointment?'**
  String get appointment_accept_dialog_content;

  /// No description provided for @appointment_decline_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline this appointment?'**
  String get appointment_decline_dialog_title;

  /// No description provided for @appointment_decline_dialog_subtitle.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get appointment_decline_dialog_subtitle;

  /// No description provided for @screening_report_upload_title.
  ///
  /// In en, this message translates to:
  /// **'Upload Lab Reports'**
  String get screening_report_upload_title;

  /// No description provided for @screening_report_upload_instruction.
  ///
  /// In en, this message translates to:
  /// **'Please upload all necessary lab reports before marking them as ready.'**
  String get screening_report_upload_instruction;

  /// No description provided for @screening_report_uploaded_section.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Reports ({count})'**
  String screening_report_uploaded_section(int count);

  /// No description provided for @screening_report_empty.
  ///
  /// In en, this message translates to:
  /// **'No reports uploaded yet'**
  String get screening_report_empty;

  /// No description provided for @screening_report_upload_btn.
  ///
  /// In en, this message translates to:
  /// **'Upload New Report'**
  String get screening_report_upload_btn;

  /// No description provided for @screening_report_mark_ready_btn.
  ///
  /// In en, this message translates to:
  /// **'Mark Reports as Ready'**
  String get screening_report_mark_ready_btn;

  /// No description provided for @screening_report_finalize_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Finalize Reports?'**
  String get screening_report_finalize_dialog_title;

  /// No description provided for @screening_report_finalize_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'Once marked as ready, reports will be sent to the patient and you cannot modify them anymore.'**
  String get screening_report_finalize_dialog_content;

  /// No description provided for @screening_report_finalized_message.
  ///
  /// In en, this message translates to:
  /// **'Reports Finalized'**
  String get screening_report_finalized_message;

  /// No description provided for @screening_report_delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Report?'**
  String get screening_report_delete_dialog_title;

  /// No description provided for @screening_report_delete_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this report?'**
  String get screening_report_delete_dialog_content;

  /// No description provided for @screening_report_upload_success.
  ///
  /// In en, this message translates to:
  /// **'Report uploaded successfully'**
  String get screening_report_upload_success;

  /// No description provided for @screening_report_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Report deleted successfully'**
  String get screening_report_delete_success;

  /// No description provided for @screening_report_finalize_success.
  ///
  /// In en, this message translates to:
  /// **'Reports marked as ready'**
  String get screening_report_finalize_success;

  /// Title for the patient's profile page
  ///
  /// In en, this message translates to:
  /// **'My Health Profile'**
  String get profile_patient_title;

  /// Title for the professional's profile page
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile_professional_title;

  /// Message displayed when no profile data is found
  ///
  /// In en, this message translates to:
  /// **'No profile data found'**
  String get profile_not_found;

  /// Label indicating the professional profile is verified
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profile_professional_verified_label;

  /// Label indicating the professional profile is unverified
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get profile_professional_unverified_label;

  /// Label indicating the date since the profile is active
  ///
  /// In en, this message translates to:
  /// **'Since: {date}'**
  String profile_verified_since_date(String date);

  /// Title for the patient's profile information section
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profile_patient_info_section;

  /// Title for the patient's basic information menu
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get profile_patient_basic_info;

  /// Title for the patient's medical information menu
  ///
  /// In en, this message translates to:
  /// **'Medical History & Risk Factors'**
  String get profile_patient_medical_history_n_risk_factor;

  /// Title for the patient's lifestyle and self care menu
  ///
  /// In en, this message translates to:
  /// **'Lifestyle & Self Care'**
  String get profile_patient_lifestyle_n_selfcare;

  /// Title for the patient's physical sign menu
  ///
  /// In en, this message translates to:
  /// **'Physical Sign'**
  String get profile_patient_physical_sign;

  /// Title for the patient's mental state menu
  ///
  /// In en, this message translates to:
  /// **'Mental State'**
  String get profile_patient_mental_state;

  /// Title for the patient's health records section
  ///
  /// In en, this message translates to:
  /// **'Health Records'**
  String get profile_patient_health_record_section;

  /// Title for the patient's medical records menu
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get profile_patient_medical_record;

  /// Title for the patient's pharmacogenomics profile menu
  ///
  /// In en, this message translates to:
  /// **'Pharmacogenomics Profile'**
  String get profile_patient_pharmacogenomics;

  /// Title for the patient's wellness genomics profile menu
  ///
  /// In en, this message translates to:
  /// **'Wellness Genomics Profile'**
  String get profile_patient_wellness_genomics;

  /// Label for the button to view all appointments
  ///
  /// In en, this message translates to:
  /// **'All My Appointments'**
  String get profile_all_my_appointments;

  /// Title for the professional's panel section
  ///
  /// In en, this message translates to:
  /// **'Professional Panel'**
  String get profile_professional_panel_section;

  /// Label for the button to edit professional profile
  ///
  /// In en, this message translates to:
  /// **'Edit Professional Profile'**
  String get profile_professional_edit_profile;

  /// Label for the button to view professional services
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get profile_professional_my_services;

  /// Label for the button to view professional schedule
  ///
  /// In en, this message translates to:
  /// **'My Schedule'**
  String get profile_professional_my_schedule;

  /// Title for the admin panel section
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get profile_admin_panel_section;

  /// Label for the button to manage services
  ///
  /// In en, this message translates to:
  /// **'Manage Services'**
  String get profile_admin_manage_services;

  /// Label for the button to manage health screening services
  ///
  /// In en, this message translates to:
  /// **'Manage Health Screening Services'**
  String get profile_admin_manage_health_screening_services;

  /// Label for the button to verify professionals
  ///
  /// In en, this message translates to:
  /// **'Verify Professionals'**
  String get profile_admin_verify_professional;

  /// Label for the button to access homecare configuration
  ///
  /// In en, this message translates to:
  /// **'Homecare Configuration'**
  String get profile_admin_homecare_config;

  /// Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for the app language setting
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settings_app_language;

  /// Label for the logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get auth_logout;

  /// Title for the profile information page
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profile_info_title;

  /// Label for the profile image field
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profile_info_profile_image;

  /// Label for the button to remove profile image
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get profile_info_remove_image;

  /// Label for the home address field
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get profile_info_home_address;

  /// Instruction to tap to select location on map
  ///
  /// In en, this message translates to:
  /// **'Tap to select location on map'**
  String get profile_info_select_map_location_hint;

  /// Label for the drug allergies field
  ///
  /// In en, this message translates to:
  /// **'Drug Allergies'**
  String get profile_info_drug_allergies;

  /// Title for the medical history and risk factors section
  ///
  /// In en, this message translates to:
  /// **'Medical History & Risk Factors'**
  String get risk_factor_title;

  /// No description provided for @medical_record_title.
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get medical_record_title;

  /// Message displayed when there are no medical records found
  ///
  /// In en, this message translates to:
  /// **'No medical records found.'**
  String get medical_record_empty;

  /// Title for the dialog to confirm deletion of a medical record
  ///
  /// In en, this message translates to:
  /// **'Delete Medical Record?'**
  String get medical_record_confirm_delete_dialog_title;

  /// Content for the dialog to confirm deletion of a medical record
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medical record?'**
  String get medical_record_confirm_delete_dialog_content;

  /// No description provided for @medical_record_patient_status.
  ///
  /// In en, this message translates to:
  /// **'Patient Status'**
  String get medical_record_patient_status;

  /// No description provided for @medical_record_disease_name.
  ///
  /// In en, this message translates to:
  /// **'Disease Name'**
  String get medical_record_disease_name;

  /// No description provided for @medical_record_disease_history.
  ///
  /// In en, this message translates to:
  /// **'Disease History'**
  String get medical_record_disease_history;

  /// No description provided for @medical_record_special_consideration.
  ///
  /// In en, this message translates to:
  /// **'Special Consideration'**
  String get medical_record_special_consideration;

  /// Label for the records file section in the medical record detail page
  ///
  /// In en, this message translates to:
  /// **'Records File'**
  String get medical_record_records_file;

  /// No description provided for @medical_record_download_file_btn.
  ///
  /// In en, this message translates to:
  /// **'Download File'**
  String get medical_record_download_file_btn;

  /// No description provided for @medical_record_view_file_btn.
  ///
  /// In en, this message translates to:
  /// **'View File'**
  String get medical_record_view_file_btn;

  /// No description provided for @diabetic_retinal_photography.
  ///
  /// In en, this message translates to:
  /// **'Diabetic Retinal\nPhotography (DRP)'**
  String get diabetic_retinal_photography;

  /// No description provided for @diabetic_retinal_photography_desc.
  ///
  /// In en, this message translates to:
  /// **'A common eye disease among diabetic\npatients. Blood capillaries may bleed\nand damage the retina, potentially\nleading to blindness. Regular\ndiabetic retinal photography\ncan detect and monitor your eyes.'**
  String get diabetic_retinal_photography_desc;

  /// No description provided for @diabetic_foot_screening.
  ///
  /// In en, this message translates to:
  /// **'Diabetic Foot Screening\n (DFS)'**
  String get diabetic_foot_screening;

  /// No description provided for @diabetic_foot_screening_desc.
  ///
  /// In en, this message translates to:
  /// **'Conducted by trained nurses, who will\nalso educate on proper footcare and\ngood sugar control. Referrals to\nfootcare specialists will be made\nwhere appropriate.'**
  String get diabetic_foot_screening_desc;

  /// No description provided for @diabetic_care_title.
  ///
  /// In en, this message translates to:
  /// **'Diabetic Care'**
  String get diabetic_care_title;

  /// No description provided for @common_book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get common_book_now;

  /// No description provided for @diabetes_form_submit_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit form.'**
  String get diabetes_form_submit_failed;

  /// No description provided for @common_error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error_title;

  /// No description provided for @diabetes_form_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load form data.'**
  String get diabetes_form_load_failed;

  /// No description provided for @common_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get common_next;

  /// No description provided for @common_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get common_submit;

  /// No description provided for @diabetes_form_title.
  ///
  /// In en, this message translates to:
  /// **'Diabetes Form'**
  String get diabetes_form_title;

  /// No description provided for @diabetes_history_title.
  ///
  /// In en, this message translates to:
  /// **'Diabetes History'**
  String get diabetes_history_title;

  /// No description provided for @diabetes_type_label.
  ///
  /// In en, this message translates to:
  /// **'Type of Diabetes'**
  String get diabetes_type_label;

  /// No description provided for @common_not_specified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get common_not_specified;

  /// No description provided for @year_of_diagnosis_label.
  ///
  /// In en, this message translates to:
  /// **'Year of Diagnosis'**
  String get year_of_diagnosis_label;

  /// No description provided for @last_hba1c_label.
  ///
  /// In en, this message translates to:
  /// **'Last HbA1c'**
  String get last_hba1c_label;

  /// No description provided for @current_treatment_label.
  ///
  /// In en, this message translates to:
  /// **'Current Treatment'**
  String get current_treatment_label;

  /// No description provided for @risk_factors_title.
  ///
  /// In en, this message translates to:
  /// **'Medical History & Risk Factors'**
  String get risk_factors_title;

  /// No description provided for @hypertension_label.
  ///
  /// In en, this message translates to:
  /// **'Hypertension'**
  String get hypertension_label;

  /// No description provided for @dyslipidemia_label.
  ///
  /// In en, this message translates to:
  /// **'Dyslipidemia'**
  String get dyslipidemia_label;

  /// No description provided for @cardiovascular_disease_label.
  ///
  /// In en, this message translates to:
  /// **'Cardiovascular Disease'**
  String get cardiovascular_disease_label;

  /// No description provided for @eye_disease_label.
  ///
  /// In en, this message translates to:
  /// **'Eye Disease (Retinopathy)'**
  String get eye_disease_label;

  /// No description provided for @neuropathy_label.
  ///
  /// In en, this message translates to:
  /// **'Neuropathy'**
  String get neuropathy_label;

  /// No description provided for @kidney_disease_label.
  ///
  /// In en, this message translates to:
  /// **'Kidney Disease'**
  String get kidney_disease_label;

  /// No description provided for @family_history_label.
  ///
  /// In en, this message translates to:
  /// **'Family History'**
  String get family_history_label;

  /// No description provided for @smoking_label.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get smoking_label;

  /// No description provided for @lifestyle_self_care_title.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle & Self-Care'**
  String get lifestyle_self_care_title;

  /// No description provided for @recent_hypoglycemia_label.
  ///
  /// In en, this message translates to:
  /// **'Recent Hypoglycemia'**
  String get recent_hypoglycemia_label;

  /// No description provided for @physical_activity_label.
  ///
  /// In en, this message translates to:
  /// **'Physical Activity'**
  String get physical_activity_label;

  /// No description provided for @diet_quality_label.
  ///
  /// In en, this message translates to:
  /// **'Diet Quality'**
  String get diet_quality_label;

  /// No description provided for @physical_signs_title.
  ///
  /// In en, this message translates to:
  /// **'Physical Signs'**
  String get physical_signs_title;

  /// No description provided for @physical_signs_if_have_title.
  ///
  /// In en, this message translates to:
  /// **'Physical Signs (If Have)'**
  String get physical_signs_if_have_title;

  /// No description provided for @eyes_last_exam_label.
  ///
  /// In en, this message translates to:
  /// **'Eyes (Last Exam)'**
  String get eyes_last_exam_label;

  /// No description provided for @eyes_findings_label.
  ///
  /// In en, this message translates to:
  /// **'Eyes (Findings)'**
  String get eyes_findings_label;

  /// No description provided for @kidneys_egfr_label.
  ///
  /// In en, this message translates to:
  /// **'Kidneys (eGFR)'**
  String get kidneys_egfr_label;

  /// No description provided for @kidneys_urine_acr_label.
  ///
  /// In en, this message translates to:
  /// **'Kidneys (Urine ACR)'**
  String get kidneys_urine_acr_label;

  /// No description provided for @feet_skin_label.
  ///
  /// In en, this message translates to:
  /// **'Feet (Skin)'**
  String get feet_skin_label;

  /// No description provided for @feet_deformity_label.
  ///
  /// In en, this message translates to:
  /// **'Feet (Deformity)'**
  String get feet_deformity_label;

  /// No description provided for @common_edit_information.
  ///
  /// In en, this message translates to:
  /// **'Edit Information'**
  String get common_edit_information;

  /// No description provided for @diabetes_type_question.
  ///
  /// In en, this message translates to:
  /// **'Type of Diabetes:'**
  String get diabetes_type_question;

  /// No description provided for @diabetes_type_1.
  ///
  /// In en, this message translates to:
  /// **'Type 1'**
  String get diabetes_type_1;

  /// No description provided for @diabetes_type_2.
  ///
  /// In en, this message translates to:
  /// **'Type 2'**
  String get diabetes_type_2;

  /// No description provided for @diabetes_type_gestational.
  ///
  /// In en, this message translates to:
  /// **'Gestational'**
  String get diabetes_type_gestational;

  /// No description provided for @common_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get common_other;

  /// No description provided for @enter_diabetes_type_hint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your type of diabetes'**
  String get enter_diabetes_type_hint;

  /// No description provided for @specify_diabetes_type_error.
  ///
  /// In en, this message translates to:
  /// **'Please specify your type of diabetes.'**
  String get specify_diabetes_type_error;

  /// No description provided for @year_of_diagnosis_question.
  ///
  /// In en, this message translates to:
  /// **'Year of Diagnosis:'**
  String get year_of_diagnosis_question;

  /// No description provided for @year_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g 2021'**
  String get year_hint;

  /// No description provided for @invalid_year_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid year.'**
  String get invalid_year_error;

  /// No description provided for @last_hba1c_question.
  ///
  /// In en, this message translates to:
  /// **'Last HbA1c:'**
  String get last_hba1c_question;

  /// No description provided for @invalid_value_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid value.'**
  String get invalid_value_error;

  /// No description provided for @current_treatment_question.
  ///
  /// In en, this message translates to:
  /// **'Current Treatment:'**
  String get current_treatment_question;

  /// No description provided for @treatment_diet_exercise.
  ///
  /// In en, this message translates to:
  /// **'Diet & Exercise'**
  String get treatment_diet_exercise;

  /// No description provided for @treatment_oral_medications.
  ///
  /// In en, this message translates to:
  /// **'Oral Medications'**
  String get treatment_oral_medications;

  /// No description provided for @list_medications_hint.
  ///
  /// In en, this message translates to:
  /// **'List medications...'**
  String get list_medications_hint;

  /// No description provided for @list_medications_error.
  ///
  /// In en, this message translates to:
  /// **'Please list your oral medications.'**
  String get list_medications_error;

  /// No description provided for @treatment_insulin.
  ///
  /// In en, this message translates to:
  /// **'Insulin'**
  String get treatment_insulin;

  /// No description provided for @insulin_type_dose_hint.
  ///
  /// In en, this message translates to:
  /// **'Type & dose'**
  String get insulin_type_dose_hint;

  /// No description provided for @insulin_type_dose_error.
  ///
  /// In en, this message translates to:
  /// **'Please specify your insulin type & dose.'**
  String get insulin_type_dose_error;

  /// No description provided for @answer_all_questions_error.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions on this page.'**
  String get answer_all_questions_error;

  /// No description provided for @recent_hypoglycemia_question.
  ///
  /// In en, this message translates to:
  /// **'Recent Hypoglycemia:'**
  String get recent_hypoglycemia_question;

  /// No description provided for @hypoglycemia_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get hypoglycemia_none;

  /// No description provided for @hypoglycemia_mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get hypoglycemia_mild;

  /// No description provided for @hypoglycemia_severe.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get hypoglycemia_severe;

  /// No description provided for @physical_activity_question.
  ///
  /// In en, this message translates to:
  /// **'Physical Activity:'**
  String get physical_activity_question;

  /// No description provided for @activity_regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get activity_regular;

  /// No description provided for @activity_occasional.
  ///
  /// In en, this message translates to:
  /// **'Occasional'**
  String get activity_occasional;

  /// No description provided for @activity_sedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get activity_sedentary;

  /// No description provided for @diet_quality_question.
  ///
  /// In en, this message translates to:
  /// **'Diet Quality:'**
  String get diet_quality_question;

  /// No description provided for @diet_healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get diet_healthy;

  /// No description provided for @diet_needs_improvement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get diet_needs_improvement;

  /// No description provided for @eyes_label.
  ///
  /// In en, this message translates to:
  /// **'Eyes:'**
  String get eyes_label;

  /// No description provided for @last_exam_date_label.
  ///
  /// In en, this message translates to:
  /// **'Last Exam Date'**
  String get last_exam_date_label;

  /// No description provided for @invalid_date_format_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid format (Use YYYY-MM-DD)'**
  String get invalid_date_format_error;

  /// No description provided for @invalid_date_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid date.'**
  String get invalid_date_error;

  /// No description provided for @findings_label.
  ///
  /// In en, this message translates to:
  /// **'Findings'**
  String get findings_label;

  /// No description provided for @kidneys_label.
  ///
  /// In en, this message translates to:
  /// **'Kidneys:'**
  String get kidneys_label;

  /// No description provided for @feet_label.
  ///
  /// In en, this message translates to:
  /// **'Feet:'**
  String get feet_label;

  /// No description provided for @skin_label.
  ///
  /// In en, this message translates to:
  /// **'Skin:'**
  String get skin_label;

  /// No description provided for @skin_normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get skin_normal;

  /// No description provided for @skin_dry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get skin_dry;

  /// No description provided for @skin_ulcer.
  ///
  /// In en, this message translates to:
  /// **'Ulcer'**
  String get skin_ulcer;

  /// No description provided for @skin_infection.
  ///
  /// In en, this message translates to:
  /// **'Infection'**
  String get skin_infection;

  /// No description provided for @deformity_label.
  ///
  /// In en, this message translates to:
  /// **'Deformity:'**
  String get deformity_label;

  /// No description provided for @deformity_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get deformity_none;

  /// No description provided for @deformity_bunions.
  ///
  /// In en, this message translates to:
  /// **'Bunions'**
  String get deformity_bunions;

  /// No description provided for @deformity_claw_toes.
  ///
  /// In en, this message translates to:
  /// **'Claw toes'**
  String get deformity_claw_toes;

  /// No description provided for @smoking_current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get smoking_current;

  /// No description provided for @smoking_former.
  ///
  /// In en, this message translates to:
  /// **'Former'**
  String get smoking_former;

  /// No description provided for @smoking_never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get smoking_never;

  /// No description provided for @family_history_diabetes_label.
  ///
  /// In en, this message translates to:
  /// **'Family History of Diabetes'**
  String get family_history_diabetes_label;

  /// No description provided for @common_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get common_none;

  /// No description provided for @common_upload_tap.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload your report'**
  String get common_upload_tap;

  /// No description provided for @common_ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get common_ready;

  /// No description provided for @common_full_report_file.
  ///
  /// In en, this message translates to:
  /// **'Full Report File'**
  String get common_full_report_file;

  /// No description provided for @common_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// No description provided for @common_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get common_coming_soon;

  /// No description provided for @common_feature_available_soon.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available soon!'**
  String get common_feature_available_soon;

  /// No description provided for @mental_state_title.
  ///
  /// In en, this message translates to:
  /// **'Mental State'**
  String get mental_state_title;

  /// No description provided for @mental_state_current_section.
  ///
  /// In en, this message translates to:
  /// **'Mental State (Current)'**
  String get mental_state_current_section;

  /// No description provided for @mental_state_overall_mood.
  ///
  /// In en, this message translates to:
  /// **'Overall Mood:'**
  String get mental_state_overall_mood;

  /// No description provided for @mental_state_anxiety_level.
  ///
  /// In en, this message translates to:
  /// **'Anxiety Level:'**
  String get mental_state_anxiety_level;

  /// No description provided for @mental_state_stress_level.
  ///
  /// In en, this message translates to:
  /// **'Stress Level:'**
  String get mental_state_stress_level;

  /// No description provided for @mental_state_energy_level.
  ///
  /// In en, this message translates to:
  /// **'Energy Level:'**
  String get mental_state_energy_level;

  /// No description provided for @mental_state_focus_level.
  ///
  /// In en, this message translates to:
  /// **'Focus Level:'**
  String get mental_state_focus_level;

  /// No description provided for @mental_state_sleep_quality.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality:'**
  String get mental_state_sleep_quality;

  /// No description provided for @mental_state_notes_label.
  ///
  /// In en, this message translates to:
  /// **'Notes/Events affecting your mood:'**
  String get mental_state_notes_label;

  /// No description provided for @mental_state_notes_hint.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get mental_state_notes_hint;

  /// No description provided for @pharmacogenomics_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Pharmagenomic Profile'**
  String get pharmacogenomics_profile_title;

  /// No description provided for @pharmacogenomics_delete_report_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Report'**
  String get pharmacogenomics_delete_report_title;

  /// No description provided for @pharmacogenomics_delete_report_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this report file?'**
  String get pharmacogenomics_delete_report_content;

  /// No description provided for @wellness_genomics_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Wellness Genomics Profile'**
  String get wellness_genomics_profile_title;

  /// No description provided for @settings_language_title.
  ///
  /// In en, this message translates to:
  /// **'App Languages Setting'**
  String get settings_language_title;

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English (en)'**
  String get language_en;

  /// No description provided for @language_zh.
  ///
  /// In en, this message translates to:
  /// **'Chinese (zh)'**
  String get language_zh;

  /// No description provided for @language_id.
  ///
  /// In en, this message translates to:
  /// **'Indonesian (id)'**
  String get language_id;

  /// No description provided for @auth_sign_in_title.
  ///
  /// In en, this message translates to:
  /// **'Login Here'**
  String get auth_sign_in_title;

  /// No description provided for @auth_welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back you\'ve\nbeen missed'**
  String get auth_welcome_back;

  /// No description provided for @auth_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email_hint;

  /// No description provided for @auth_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password_hint;

  /// No description provided for @auth_forgot_password_btn.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgot_password_btn;

  /// No description provided for @auth_sign_in_btn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_sign_in_btn;

  /// No description provided for @auth_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get auth_create_account;

  /// No description provided for @auth_continue_with.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get auth_continue_with;

  /// No description provided for @auth_error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get auth_error_title;

  /// No description provided for @auth_fill_email_password_error.
  ///
  /// In en, this message translates to:
  /// **'Please fill in both Email and Password.'**
  String get auth_fill_email_password_error;

  /// No description provided for @auth_fill_all_fields_error.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields correctly.'**
  String get auth_fill_all_fields_error;

  /// No description provided for @auth_select_role_error.
  ///
  /// In en, this message translates to:
  /// **'Please select a user type'**
  String get auth_select_role_error;

  /// No description provided for @auth_select_role_first_error.
  ///
  /// In en, this message translates to:
  /// **'Please select a user type first'**
  String get auth_select_role_first_error;

  /// No description provided for @auth_passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get auth_passwords_do_not_match;

  /// No description provided for @auth_enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get auth_enter_valid_email;

  /// No description provided for @auth_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get auth_enter_email;

  /// No description provided for @auth_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get auth_enter_password;

  /// No description provided for @auth_password_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get auth_password_length_error;

  /// No description provided for @auth_enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get auth_enter_username;

  /// No description provided for @auth_confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_confirm_password_hint;

  /// No description provided for @auth_username_hint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get auth_username_hint;

  /// No description provided for @auth_select_user_type_hint.
  ///
  /// In en, this message translates to:
  /// **'Select User Type'**
  String get auth_select_user_type_hint;

  /// No description provided for @auth_role_patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get auth_role_patient;

  /// No description provided for @auth_role_nurse.
  ///
  /// In en, this message translates to:
  /// **'Nurse'**
  String get auth_role_nurse;

  /// No description provided for @auth_role_pharmacist.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist'**
  String get auth_role_pharmacist;

  /// No description provided for @auth_role_radiologist.
  ///
  /// In en, this message translates to:
  /// **'Radiologist'**
  String get auth_role_radiologist;

  /// No description provided for @auth_role_caregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver/Helper'**
  String get auth_role_caregiver;

  /// No description provided for @auth_role_physiotherapist.
  ///
  /// In en, this message translates to:
  /// **'Physiotherapist'**
  String get auth_role_physiotherapist;

  /// No description provided for @auth_sign_up_title.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_sign_up_title;

  /// No description provided for @auth_sign_up_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account so you can explore all the\nexisting jobs'**
  String get auth_sign_up_subtitle;

  /// No description provided for @auth_sign_up_btn.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_sign_up_btn;

  /// No description provided for @auth_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get auth_already_have_account;

  /// No description provided for @auth_registration_successful_title.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get auth_registration_successful_title;

  /// No description provided for @auth_registration_successful_content.
  ///
  /// In en, this message translates to:
  /// **'Please check your email for verification.'**
  String get auth_registration_successful_content;

  /// No description provided for @auth_complete_registration_title.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get auth_complete_registration_title;

  /// No description provided for @auth_complete_registration_content.
  ///
  /// In en, this message translates to:
  /// **'Welcome!\nPlease select your account type to continue.'**
  String get auth_complete_registration_content;

  /// No description provided for @auth_forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgot_password_title;

  /// No description provided for @auth_forgot_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Please enter the email address linked with your account.'**
  String get auth_forgot_password_subtitle;

  /// No description provided for @auth_enter_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get auth_enter_email_hint;

  /// No description provided for @auth_send_code_btn.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get auth_send_code_btn;

  /// No description provided for @auth_otp_sent_success.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get auth_otp_sent_success;

  /// No description provided for @auth_otp_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get auth_otp_verification_title;

  /// No description provided for @auth_otp_verification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code that we have sent to your email {email}'**
  String auth_otp_verification_subtitle(String email);

  /// No description provided for @auth_verify_btn.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get auth_verify_btn;

  /// No description provided for @auth_resend_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? Resend'**
  String get auth_resend_code;

  /// No description provided for @auth_resend_in_seconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds} seconds'**
  String auth_resend_in_seconds(int seconds);

  /// No description provided for @auth_code_resent.
  ///
  /// In en, this message translates to:
  /// **'Code resent!'**
  String get auth_code_resent;

  /// No description provided for @auth_pin_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Pin is incorrect'**
  String get auth_pin_incorrect;

  /// No description provided for @auth_reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_reset_password_title;

  /// No description provided for @auth_reset_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get auth_reset_password_subtitle;

  /// No description provided for @auth_new_password_hint.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get auth_new_password_hint;

  /// No description provided for @auth_confirm_password_error.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get auth_confirm_password_error;

  /// No description provided for @auth_reset_password_btn.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_reset_password_btn;

  /// No description provided for @auth_reset_password_success_title.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successful!'**
  String get auth_reset_password_success_title;

  /// No description provided for @auth_reset_password_success_content.
  ///
  /// In en, this message translates to:
  /// **'You have successfully reset your password. Please use your new password when logging in.'**
  String get auth_reset_password_success_content;

  /// No description provided for @auth_back_to_login_btn.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get auth_back_to_login_btn;

  /// No description provided for @booking_nursing_primary_title.
  ///
  /// In en, this message translates to:
  /// **'Primary Nursing'**
  String get booking_nursing_primary_title;

  /// No description provided for @booking_nursing_primary_desc.
  ///
  /// In en, this message translates to:
  /// **'Monitor and administer\nnursing procedures from\nbody checking, Medication,\ntube feed and suctioning to\ninjections and wound care.'**
  String get booking_nursing_primary_desc;

  /// No description provided for @booking_nursing_specialized_title.
  ///
  /// In en, this message translates to:
  /// **'Specialized Nursing Services'**
  String get booking_nursing_specialized_title;

  /// No description provided for @booking_nursing_specialized_desc.
  ///
  /// In en, this message translates to:
  /// **'Focus on recovery and leave\nthe complex nursing care in\nthe hands of our experienced\nnurse Care Pros'**
  String get booking_nursing_specialized_desc;

  /// No description provided for @booking_nursing_page_title.
  ///
  /// In en, this message translates to:
  /// **'Home Nursing'**
  String get booking_nursing_page_title;

  /// No description provided for @booking_pharmacy_page_title.
  ///
  /// In en, this message translates to:
  /// **'iRX Pharmacist Service'**
  String get booking_pharmacy_page_title;

  /// No description provided for @booking_pharmacy_medication_counseling_title.
  ///
  /// In en, this message translates to:
  /// **'Medication Counseling\nand Education'**
  String get booking_pharmacy_medication_counseling_title;

  /// No description provided for @booking_pharmacy_medication_counseling_desc.
  ///
  /// In en, this message translates to:
  /// **'Medication counseling and education guide\npatients on proper use, side effects, and\nadherence to prescriptions,\nenhancing safety and\nimproving health outcomes.'**
  String get booking_pharmacy_medication_counseling_desc;

  /// No description provided for @booking_pharmacy_therapy_review_title.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Therapy\nReview'**
  String get booking_pharmacy_therapy_review_title;

  /// No description provided for @booking_pharmacy_therapy_review_desc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive review of your medication\nand lifestyle to optimize treatment\noutcomes and minimize potential side\neffects'**
  String get booking_pharmacy_therapy_review_desc;

  /// No description provided for @booking_pharmacy_health_coaching_title.
  ///
  /// In en, this message translates to:
  /// **'Health Coaching'**
  String get booking_pharmacy_health_coaching_title;

  /// No description provided for @booking_pharmacy_health_coaching_desc.
  ///
  /// In en, this message translates to:
  /// **'Personalized guidance and support to help\nindividuals achieve their health goals, manage\nchronic conditions, and improve overall well-\nbeing, with specialized programs for weight\nmanagement, diabetes management, high\nblood pressure management, and high\ncholesterol management'**
  String get booking_pharmacy_health_coaching_desc;

  /// No description provided for @booking_pharmacy_smoking_cessation_title.
  ///
  /// In en, this message translates to:
  /// **'Smoking Cessation'**
  String get booking_pharmacy_smoking_cessation_title;

  /// No description provided for @booking_pharmacy_smoking_cessation_desc.
  ///
  /// In en, this message translates to:
  /// **'Smoking cessation involves quitting\nsmoking through strategies like\ncounseling, medications, and support\nprograms to improve health and\nreduce the risk of smoking-related\ndiseases.'**
  String get booking_pharmacy_smoking_cessation_desc;

  /// No description provided for @booking_issue_list_title_nursing.
  ///
  /// In en, this message translates to:
  /// **'Nurse Services Case'**
  String get booking_issue_list_title_nursing;

  /// No description provided for @booking_issue_list_title_pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist Services Case'**
  String get booking_issue_list_title_pharmacy;

  /// No description provided for @booking_issue_list_title_radiology.
  ///
  /// In en, this message translates to:
  /// **'Radiologist Services Case'**
  String get booking_issue_list_title_radiology;

  /// No description provided for @booking_issue_list_title_default.
  ///
  /// In en, this message translates to:
  /// **'Service Case'**
  String get booking_issue_list_title_default;

  /// No description provided for @booking_tell_us_concern.
  ///
  /// In en, this message translates to:
  /// **'Tell Us Your Concern'**
  String get booking_tell_us_concern;

  /// No description provided for @booking_issue_empty.
  ///
  /// In en, this message translates to:
  /// **'There are no issues added yet.\n Please add one or more issues so\nyou can proceed to the next step.'**
  String get booking_issue_empty;

  /// No description provided for @booking_add_issue_btn.
  ///
  /// In en, this message translates to:
  /// **'Add an Issue'**
  String get booking_add_issue_btn;

  /// No description provided for @booking_next_btn.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get booking_next_btn;

  /// No description provided for @booking_issue_delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Issue'**
  String get booking_issue_delete_dialog_title;

  /// No description provided for @booking_issue_delete_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this issue?'**
  String get booking_issue_delete_dialog_content;

  /// No description provided for @booking_issue_form_add_title.
  ///
  /// In en, this message translates to:
  /// **'Add an Issue'**
  String get booking_issue_form_add_title;

  /// No description provided for @booking_issue_form_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Issue'**
  String get booking_issue_form_edit_title;

  /// No description provided for @booking_issue_form_instruction.
  ///
  /// In en, this message translates to:
  /// **'Tell us your concerns'**
  String get booking_issue_form_instruction;

  /// No description provided for @booking_issue_form_title_hint.
  ///
  /// In en, this message translates to:
  /// **'Issue Title'**
  String get booking_issue_form_title_hint;

  /// No description provided for @booking_issue_form_desc_hint.
  ///
  /// In en, this message translates to:
  /// **'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.'**
  String get booking_issue_form_desc_hint;

  /// No description provided for @booking_issue_form_images_label.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get booking_issue_form_images_label;

  /// No description provided for @booking_issue_form_update_btn.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get booking_issue_form_update_btn;

  /// No description provided for @booking_issue_form_add_btn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get booking_issue_form_add_btn;

  /// No description provided for @booking_issue_form_required_error.
  ///
  /// In en, this message translates to:
  /// **'Issue title and description are required.'**
  String get booking_issue_form_required_error;

  /// No description provided for @booking_issue_form_success_update.
  ///
  /// In en, this message translates to:
  /// **'Issue updated successfully'**
  String get booking_issue_form_success_update;

  /// No description provided for @booking_issue_form_success_add.
  ///
  /// In en, this message translates to:
  /// **'Issue added successfully'**
  String get booking_issue_form_success_add;

  /// No description provided for @booking_health_status_title.
  ///
  /// In en, this message translates to:
  /// **'Personal Case Detail'**
  String get booking_health_status_title;

  /// No description provided for @booking_health_status_mobility_label.
  ///
  /// In en, this message translates to:
  /// **'Select your mobility status'**
  String get booking_health_status_mobility_label;

  /// No description provided for @booking_health_status_record_label.
  ///
  /// In en, this message translates to:
  /// **'Select a related health record'**
  String get booking_health_status_record_label;

  /// No description provided for @booking_health_status_record_hint.
  ///
  /// In en, this message translates to:
  /// **'Please select a record'**
  String get booking_health_status_record_hint;

  /// No description provided for @booking_health_status_no_records.
  ///
  /// In en, this message translates to:
  /// **'No medical records available.'**
  String get booking_health_status_no_records;

  /// No description provided for @booking_addon_nursing_title.
  ///
  /// In en, this message translates to:
  /// **'Nursing Procedures'**
  String get booking_addon_nursing_title;

  /// No description provided for @booking_addon_specialized_nursing_title.
  ///
  /// In en, this message translates to:
  /// **'Specialized Nursing Procedures'**
  String get booking_addon_specialized_nursing_title;

  /// No description provided for @booking_addon_pharmacy_title.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Services'**
  String get booking_addon_pharmacy_title;

  /// No description provided for @booking_addon_radiology_title.
  ///
  /// In en, this message translates to:
  /// **'Radiology Services'**
  String get booking_addon_radiology_title;

  /// No description provided for @booking_addon_default_title.
  ///
  /// In en, this message translates to:
  /// **'Add On Services'**
  String get booking_addon_default_title;

  /// No description provided for @booking_addon_empty.
  ///
  /// In en, this message translates to:
  /// **'No add-on services available.'**
  String get booking_addon_empty;

  /// No description provided for @booking_estimated_budget.
  ///
  /// In en, this message translates to:
  /// **'Estimated Budget'**
  String get booking_estimated_budget;

  /// No description provided for @booking_book_appointment_btn.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get booking_book_appointment_btn;

  /// No description provided for @booking_professional_search_nurse.
  ///
  /// In en, this message translates to:
  /// **'Search Nurse'**
  String get booking_professional_search_nurse;

  /// No description provided for @booking_professional_search_pharmacist.
  ///
  /// In en, this message translates to:
  /// **'Search Pharmacist'**
  String get booking_professional_search_pharmacist;

  /// No description provided for @booking_professional_search_radiologist.
  ///
  /// In en, this message translates to:
  /// **'Search Radiologist'**
  String get booking_professional_search_radiologist;

  /// No description provided for @booking_professional_search_caregiver.
  ///
  /// In en, this message translates to:
  /// **'Search Caregiver/Helper/Worker'**
  String get booking_professional_search_caregiver;

  /// No description provided for @booking_professional_search_default.
  ///
  /// In en, this message translates to:
  /// **'Search Professional'**
  String get booking_professional_search_default;

  /// No description provided for @booking_professional_filter_text.
  ///
  /// In en, this message translates to:
  /// **'Filtering by {count} selected services'**
  String booking_professional_filter_text(int count);

  /// No description provided for @booking_professional_empty.
  ///
  /// In en, this message translates to:
  /// **'No professionals found matching your criteria.'**
  String get booking_professional_empty;

  /// No description provided for @booking_professional_appointment_btn.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get booking_professional_appointment_btn;

  /// No description provided for @booking_professional_detail_nurse.
  ///
  /// In en, this message translates to:
  /// **'Nurse Details'**
  String get booking_professional_detail_nurse;

  /// No description provided for @booking_professional_detail_pharmacist.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist Details'**
  String get booking_professional_detail_pharmacist;

  /// No description provided for @booking_professional_detail_radiologist.
  ///
  /// In en, this message translates to:
  /// **'Radiologist Details'**
  String get booking_professional_detail_radiologist;

  /// No description provided for @booking_professional_detail_default.
  ///
  /// In en, this message translates to:
  /// **'Professional Details'**
  String get booking_professional_detail_default;

  /// No description provided for @booking_professional_patients_label.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get booking_professional_patients_label;

  /// No description provided for @booking_professional_experience_label.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get booking_professional_experience_label;

  /// No description provided for @booking_professional_rating_label.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get booking_professional_rating_label;

  /// No description provided for @booking_professional_about_me.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get booking_professional_about_me;

  /// No description provided for @booking_professional_working_info.
  ///
  /// In en, this message translates to:
  /// **'Working Information'**
  String get booking_professional_working_info;

  /// No description provided for @booking_professional_certificate.
  ///
  /// In en, this message translates to:
  /// **'Professional Certificate'**
  String get booking_professional_certificate;

  /// No description provided for @booking_professional_no_certificate.
  ///
  /// In en, this message translates to:
  /// **'No certificate available.'**
  String get booking_professional_no_certificate;

  /// No description provided for @booking_professional_id_number.
  ///
  /// In en, this message translates to:
  /// **'ID Number: {number}'**
  String booking_professional_id_number(String number);

  /// No description provided for @booking_professional_issued_on.
  ///
  /// In en, this message translates to:
  /// **'Issued: {date}'**
  String booking_professional_issued_on(String date);

  /// No description provided for @booking_professional_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get booking_professional_reviews;

  /// No description provided for @booking_professional_see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get booking_professional_see_all;

  /// No description provided for @booking_professional_no_reviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews available yet.'**
  String get booking_professional_no_reviews;

  /// No description provided for @booking_professional_schedule_btn.
  ///
  /// In en, this message translates to:
  /// **'Schedule Appointment'**
  String get booking_professional_schedule_btn;

  /// No description provided for @booking_schedule_title.
  ///
  /// In en, this message translates to:
  /// **'Select Schedule'**
  String get booking_schedule_title;

  /// No description provided for @booking_schedule_select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get booking_schedule_select_date;

  /// No description provided for @booking_schedule_select_hour.
  ///
  /// In en, this message translates to:
  /// **'Select Hour'**
  String get booking_schedule_select_hour;

  /// No description provided for @booking_schedule_no_slots.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this day.'**
  String get booking_schedule_no_slots;

  /// No description provided for @booking_schedule_submit_btn.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get booking_schedule_submit_btn;

  /// No description provided for @booking_schedule_submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get booking_schedule_submitting;

  /// No description provided for @booking_schedule_reschedule_success.
  ///
  /// In en, this message translates to:
  /// **'Appointment rescheduled successfully'**
  String get booking_schedule_reschedule_success;

  /// No description provided for @booking_schedule_reschedule_failed.
  ///
  /// In en, this message translates to:
  /// **'Rescheduling failed.'**
  String get booking_schedule_reschedule_failed;

  /// No description provided for @booking_appointment_created_success.
  ///
  /// In en, this message translates to:
  /// **'Appointment created successfully'**
  String get booking_appointment_created_success;

  /// No description provided for @booking_appointment_created_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create appointment'**
  String get booking_appointment_created_failed;

  /// No description provided for @chat_pharma_title.
  ///
  /// In en, this message translates to:
  /// **'AI Pharmacist'**
  String get chat_pharma_title;

  /// No description provided for @chat_pharma_online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get chat_pharma_online;

  /// No description provided for @chat_pharma_privacy.
  ///
  /// In en, this message translates to:
  /// **'(HIPAA Privacy)'**
  String get chat_pharma_privacy;

  /// No description provided for @chat_pharma_need_help.
  ///
  /// In en, this message translates to:
  /// **'Need Help? '**
  String get chat_pharma_need_help;

  /// No description provided for @chat_pharma_request_help.
  ///
  /// In en, this message translates to:
  /// **'Request help from the Pharmacist'**
  String get chat_pharma_request_help;

  /// No description provided for @chat_pharma_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your message'**
  String get chat_pharma_input_hint;

  /// No description provided for @common_unknown_location.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get common_unknown_location;

  /// No description provided for @booking_personal_issue_concern.
  ///
  /// In en, this message translates to:
  /// **'Concern / Question'**
  String get booking_personal_issue_concern;

  /// No description provided for @booking_personal_issue_updated_on.
  ///
  /// In en, this message translates to:
  /// **'Updated on: {date}'**
  String booking_personal_issue_updated_on(String date);

  /// No description provided for @booking_personal_issue_images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get booking_personal_issue_images;

  /// No description provided for @booking_mobility_bedbound.
  ///
  /// In en, this message translates to:
  /// **'Bedbound'**
  String get booking_mobility_bedbound;

  /// No description provided for @booking_mobility_wheelchair_bound.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair'**
  String get booking_mobility_wheelchair_bound;

  /// No description provided for @booking_mobility_walking_aid.
  ///
  /// In en, this message translates to:
  /// **'With Walking Aid'**
  String get booking_mobility_walking_aid;

  /// No description provided for @booking_mobility_mobile_without_aid.
  ///
  /// In en, this message translates to:
  /// **'Independent without Walking Aid'**
  String get booking_mobility_mobile_without_aid;

  /// No description provided for @home_health_screening_title.
  ///
  /// In en, this message translates to:
  /// **'Home Health Screening'**
  String get home_health_screening_title;

  /// No description provided for @home_health_at_home_diagnostic.
  ///
  /// In en, this message translates to:
  /// **'At-home diagnostic tests'**
  String get home_health_at_home_diagnostic;

  /// No description provided for @home_health_at_home_diagnostic_desc.
  ///
  /// In en, this message translates to:
  /// **'Patients collect samples at home using a self-collection kit, which includes materials like swabs, test cards, and collection tubes, and submit them to a CLIA/CAP certified lab (telemedicine lab) for processing. Laboratory technicians process these samples and upload results to an online portal. Primary care doctors, specialists, or other healthcare professionals review results and walk patients through next steps.'**
  String get home_health_at_home_diagnostic_desc;

  /// No description provided for @home_health_point_of_care.
  ///
  /// In en, this message translates to:
  /// **'Point-of-care tests'**
  String get home_health_point_of_care;

  /// No description provided for @home_health_point_of_care_desc.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics done outside of a lab that patients can take by themselves at home. These tests develop rapidly and produce results without a doctor or lab technician present. With point-of-care tests, patients review results outside a medical setting and determine their own next steps.'**
  String get home_health_point_of_care_desc;

  /// No description provided for @home_health_screening_booked_success.
  ///
  /// In en, this message translates to:
  /// **'Screening appointment booked successfully!'**
  String get home_health_screening_booked_success;

  /// No description provided for @home_health_screening_booking_failed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed'**
  String get home_health_screening_booking_failed;

  /// No description provided for @homecare_elderly_title.
  ///
  /// In en, this message translates to:
  /// **'Home Care for Elderly'**
  String get homecare_elderly_title;

  /// No description provided for @homecare_house_bedding_cleaning.
  ///
  /// In en, this message translates to:
  /// **'House & Bedding Cleaning'**
  String get homecare_house_bedding_cleaning;

  /// No description provided for @homecare_house_bedding_cleaning_desc.
  ///
  /// In en, this message translates to:
  /// **'Regular cleaning services to maintain a hygienic, comfortable, and safe living environment for the elderly.'**
  String get homecare_house_bedding_cleaning_desc;

  /// No description provided for @homecare_living_security_safety.
  ///
  /// In en, this message translates to:
  /// **'Living Security & Safety'**
  String get homecare_living_security_safety;

  /// No description provided for @homecare_living_security_safety_desc.
  ///
  /// In en, this message translates to:
  /// **'Safety checks and organization to reduce risks and create a secure living environment.'**
  String get homecare_living_security_safety_desc;

  /// No description provided for @homecare_kitchen_bathroom_repair.
  ///
  /// In en, this message translates to:
  /// **'Kitchen & Bathroom Repair'**
  String get homecare_kitchen_bathroom_repair;

  /// No description provided for @homecare_kitchen_bathroom_repair_desc.
  ///
  /// In en, this message translates to:
  /// **'On-demand minor repairs to maintain functionality and safety in key home areas.'**
  String get homecare_kitchen_bathroom_repair_desc;

  /// No description provided for @homecare_plus_active.
  ///
  /// In en, this message translates to:
  /// **'Homecare Plus Active'**
  String get homecare_plus_active;

  /// No description provided for @homecare_get_plus.
  ///
  /// In en, this message translates to:
  /// **'Get Homecare Plus'**
  String get homecare_get_plus;

  /// No description provided for @homecare_balance.
  ///
  /// In en, this message translates to:
  /// **'Balance: {balance} Hours'**
  String homecare_balance(int balance);

  /// No description provided for @homecare_subscription_offer.
  ///
  /// In en, this message translates to:
  /// **'{quota} Hours for {price}'**
  String homecare_subscription_offer(int quota, String price);

  /// No description provided for @homecare_request_services_btn.
  ///
  /// In en, this message translates to:
  /// **'Request Services'**
  String get homecare_request_services_btn;

  /// No description provided for @homecare_select_at_least_one_task.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one task.'**
  String get homecare_select_at_least_one_task;

  /// No description provided for @homecare_task_list_title.
  ///
  /// In en, this message translates to:
  /// **'Task List'**
  String get homecare_task_list_title;

  /// No description provided for @homecare_feature_name.
  ///
  /// In en, this message translates to:
  /// **'FEATURE NAME'**
  String get homecare_feature_name;

  /// No description provided for @homecare_frequency.
  ///
  /// In en, this message translates to:
  /// **'FREQUENCY'**
  String get homecare_frequency;

  /// No description provided for @homecare_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get homecare_weekly;

  /// No description provided for @homecare_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get homecare_monthly;

  /// No description provided for @homecare_as_needed.
  ///
  /// In en, this message translates to:
  /// **'As Needed'**
  String get homecare_as_needed;

  /// No description provided for @homecare_review_checkout_title.
  ///
  /// In en, this message translates to:
  /// **'Review & Checkout'**
  String get homecare_review_checkout_title;

  /// No description provided for @homecare_requested_tasks.
  ///
  /// In en, this message translates to:
  /// **'Requested Tasks'**
  String get homecare_requested_tasks;

  /// No description provided for @homecare_billing_option.
  ///
  /// In en, this message translates to:
  /// **'Billing Option'**
  String get homecare_billing_option;

  /// No description provided for @homecare_hourly_rate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get homecare_hourly_rate;

  /// No description provided for @homecare_use_subscription_balance.
  ///
  /// In en, this message translates to:
  /// **'Use Subscription Balance'**
  String get homecare_use_subscription_balance;

  /// No description provided for @homecare_deduct_hours.
  ///
  /// In en, this message translates to:
  /// **'Deduct {hours} Hours (Balance: {balance} h)'**
  String homecare_deduct_hours(int hours, int balance);

  /// No description provided for @homecare_insufficient_balance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient Balance ({balance} h)'**
  String homecare_insufficient_balance(int balance);

  /// No description provided for @homecare_confirm_booking_btn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get homecare_confirm_booking_btn;

  /// No description provided for @homecare_subscription_plans_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get homecare_subscription_plans_title;

  /// No description provided for @homecare_care_hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} Hours of Care'**
  String homecare_care_hours(int hours);

  /// No description provided for @homecare_valid_for_days.
  ///
  /// In en, this message translates to:
  /// **'Valid for {days} Days'**
  String homecare_valid_for_days(int days);

  /// No description provided for @homecare_experienced_caregivers.
  ///
  /// In en, this message translates to:
  /// **'Experienced Caregivers'**
  String get homecare_experienced_caregivers;

  /// No description provided for @homecare_active_subscription.
  ///
  /// In en, this message translates to:
  /// **'Active Subscription'**
  String get homecare_active_subscription;

  /// No description provided for @homecare_expires_on.
  ///
  /// In en, this message translates to:
  /// **'Expires on {date}'**
  String homecare_expires_on(String date);

  /// No description provided for @homecare_purchase_now.
  ///
  /// In en, this message translates to:
  /// **'Purchase Now - {price}'**
  String homecare_purchase_now(String price);

  /// No description provided for @precision_nutrition_title.
  ///
  /// In en, this message translates to:
  /// **'Precision Nutrition'**
  String get precision_nutrition_title;

  /// No description provided for @precision_assessment_title.
  ///
  /// In en, this message translates to:
  /// **'Precision Nutrition Assessment'**
  String get precision_assessment_title;

  /// No description provided for @precision_assessment_desc.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with a deep analysis of your genes, metabolism and lifestyle to understand your body\'s unique needs.'**
  String get precision_assessment_desc;

  /// No description provided for @precision_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Precision Nutrition Plan'**
  String get precision_plan_title;

  /// No description provided for @precision_plan_desc.
  ///
  /// In en, this message translates to:
  /// **'Receive a personalized nutrition strategy crafted by experts to address your specific health goals and conditions.'**
  String get precision_plan_desc;

  /// No description provided for @precision_implementation_title.
  ///
  /// In en, this message translates to:
  /// **'Precision Nutrition Implementation'**
  String get precision_implementation_title;

  /// No description provided for @precision_implementation_desc.
  ///
  /// In en, this message translates to:
  /// **'Track progress and adapt your plan through continuous support, biomarker monitoring, and smart digital tools.'**
  String get precision_implementation_desc;

  /// No description provided for @precision_start_now.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get precision_start_now;

  /// No description provided for @precision_book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get precision_book_now;

  /// No description provided for @precision_main_concern_question.
  ///
  /// In en, this message translates to:
  /// **'What is your main concern?'**
  String get precision_main_concern_question;

  /// No description provided for @precision_main_concern_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the area that best describes your primary health goal'**
  String get precision_main_concern_subtitle;

  /// No description provided for @precision_sub_health.
  ///
  /// In en, this message translates to:
  /// **'Sub-Health'**
  String get precision_sub_health;

  /// No description provided for @precision_sub_health_desc.
  ///
  /// In en, this message translates to:
  /// **'Improve overall wellness and energy levels'**
  String get precision_sub_health_desc;

  /// No description provided for @precision_chronic_disease.
  ///
  /// In en, this message translates to:
  /// **'Chronic Disease'**
  String get precision_chronic_disease;

  /// No description provided for @precision_chronic_disease_desc.
  ///
  /// In en, this message translates to:
  /// **'Manage and improve chronic health conditions'**
  String get precision_chronic_disease_desc;

  /// No description provided for @precision_anti_aging.
  ///
  /// In en, this message translates to:
  /// **'Anti-aging'**
  String get precision_anti_aging;

  /// No description provided for @precision_anti_aging_desc.
  ///
  /// In en, this message translates to:
  /// **'Optimize health and vitality as you age'**
  String get precision_anti_aging_desc;

  /// No description provided for @precision_basic_info_title.
  ///
  /// In en, this message translates to:
  /// **'Basic Info & Health History'**
  String get precision_basic_info_title;

  /// No description provided for @precision_age_label.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get precision_age_label;

  /// No description provided for @precision_age_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g 34 years old'**
  String get precision_age_hint;

  /// No description provided for @precision_age_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get precision_age_error;

  /// No description provided for @precision_age_valid_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get precision_age_valid_error;

  /// No description provided for @precision_gender_label.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get precision_gender_label;

  /// No description provided for @precision_gender_error.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get precision_gender_error;

  /// No description provided for @precision_known_condition_label.
  ///
  /// In en, this message translates to:
  /// **'Known Condition (Optional)'**
  String get precision_known_condition_label;

  /// No description provided for @precision_known_condition_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your condition history here'**
  String get precision_known_condition_hint;

  /// No description provided for @precision_special_consideration_title.
  ///
  /// In en, this message translates to:
  /// **'Patient with Special Consideration'**
  String get precision_special_consideration_title;

  /// No description provided for @precision_medication_history_label.
  ///
  /// In en, this message translates to:
  /// **'Medication & supplement history'**
  String get precision_medication_history_label;

  /// No description provided for @precision_medication_history_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Avoid Clopidogrel, Ondansetron, etc'**
  String get precision_medication_history_hint;

  /// No description provided for @precision_family_history_label.
  ///
  /// In en, this message translates to:
  /// **'Family health history'**
  String get precision_family_history_label;

  /// No description provided for @precision_family_history_hint.
  ///
  /// In en, this message translates to:
  /// **'Write other biomarkers here (minimum 10 characters)'**
  String get precision_family_history_hint;

  /// No description provided for @precision_family_history_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least 10 characters'**
  String get precision_family_history_error;

  /// No description provided for @precision_self_rated_health_title.
  ///
  /// In en, this message translates to:
  /// **'Self-Rated Health'**
  String get precision_self_rated_health_title;

  /// No description provided for @precision_terrible.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get precision_terrible;

  /// No description provided for @precision_bad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get precision_bad;

  /// No description provided for @precision_neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get precision_neutral;

  /// No description provided for @precision_good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get precision_good;

  /// No description provided for @precision_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get precision_excellent;

  /// No description provided for @precision_its_terrible.
  ///
  /// In en, this message translates to:
  /// **'It\'s terrible'**
  String get precision_its_terrible;

  /// No description provided for @precision_its_bad.
  ///
  /// In en, this message translates to:
  /// **'It\'s bad'**
  String get precision_its_bad;

  /// No description provided for @precision_its_good.
  ///
  /// In en, this message translates to:
  /// **'It\'s good'**
  String get precision_its_good;

  /// No description provided for @precision_its_very_good.
  ///
  /// In en, this message translates to:
  /// **'It\'s very good'**
  String get precision_its_very_good;

  /// No description provided for @precision_lifestyle_habits_title.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle & Habits'**
  String get precision_lifestyle_habits_title;

  /// No description provided for @precision_sleep_hours_question.
  ///
  /// In en, this message translates to:
  /// **'How many hours of sleep do you get per night?'**
  String get precision_sleep_hours_question;

  /// No description provided for @precision_hours_per_day.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours per day'**
  String precision_hours_per_day(String hours);

  /// No description provided for @precision_activity_level_label.
  ///
  /// In en, this message translates to:
  /// **'Describe your typical daily activity level'**
  String get precision_activity_level_label;

  /// No description provided for @precision_activity_level_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g Working behind the desk 8 hours per day'**
  String get precision_activity_level_hint;

  /// No description provided for @precision_activity_level_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your activity level'**
  String get precision_activity_level_error;

  /// No description provided for @precision_exercise_frequency_label.
  ///
  /// In en, this message translates to:
  /// **'How often do you exercise per week?'**
  String get precision_exercise_frequency_label;

  /// No description provided for @precision_exercise_frequency_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Around 30 minutes per day'**
  String get precision_exercise_frequency_hint;

  /// No description provided for @precision_exercise_frequency_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your exercise frequency'**
  String get precision_exercise_frequency_error;

  /// No description provided for @precision_stress_level_label.
  ///
  /// In en, this message translates to:
  /// **'Stress levels'**
  String get precision_stress_level_label;

  /// No description provided for @precision_stress_level_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Intermediate stress level'**
  String get precision_stress_level_hint;

  /// No description provided for @precision_stress_level_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your stress level'**
  String get precision_stress_level_error;

  /// No description provided for @precision_smoking_alcohol_label.
  ///
  /// In en, this message translates to:
  /// **'Smoking or alcohol habits?'**
  String get precision_smoking_alcohol_label;

  /// No description provided for @precision_smoking_alcohol_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Heavy smoking'**
  String get precision_smoking_alcohol_hint;

  /// No description provided for @precision_smoking_alcohol_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your smoking/alcohol habits'**
  String get precision_smoking_alcohol_error;

  /// No description provided for @precision_nutrition_habits_title.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Habits'**
  String get precision_nutrition_habits_title;

  /// No description provided for @precision_meal_frequency_label.
  ///
  /// In en, this message translates to:
  /// **'Describe your daily meal frequency'**
  String get precision_meal_frequency_label;

  /// No description provided for @precision_meal_frequency_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g Twice a day'**
  String get precision_meal_frequency_hint;

  /// No description provided for @precision_meal_frequency_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your meal frequency'**
  String get precision_meal_frequency_error;

  /// No description provided for @precision_food_sensitivities_label.
  ///
  /// In en, this message translates to:
  /// **'Known food sensitivities or allergies'**
  String get precision_food_sensitivities_label;

  /// No description provided for @precision_food_sensitivities_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Seafoods such as shrimp'**
  String get precision_food_sensitivities_hint;

  /// No description provided for @precision_food_sensitivities_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your food sensitivities'**
  String get precision_food_sensitivities_error;

  /// No description provided for @precision_favorite_foods_label.
  ///
  /// In en, this message translates to:
  /// **'Favorite food types'**
  String get precision_favorite_foods_label;

  /// No description provided for @precision_favorite_foods_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Chicken, Healthy Soup, Meatball'**
  String get precision_favorite_foods_hint;

  /// No description provided for @precision_favorite_foods_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your favorite foods'**
  String get precision_favorite_foods_error;

  /// No description provided for @precision_avoided_foods_label.
  ///
  /// In en, this message translates to:
  /// **'Avoided food types'**
  String get precision_avoided_foods_label;

  /// No description provided for @precision_avoided_foods_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Seafood'**
  String get precision_avoided_foods_hint;

  /// No description provided for @precision_avoided_foods_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe foods you avoid'**
  String get precision_avoided_foods_error;

  /// No description provided for @precision_water_intake_label.
  ///
  /// In en, this message translates to:
  /// **'Water intake'**
  String get precision_water_intake_label;

  /// No description provided for @precision_water_intake_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: 7 glass per day'**
  String get precision_water_intake_hint;

  /// No description provided for @precision_water_intake_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your water intake'**
  String get precision_water_intake_error;

  /// No description provided for @precision_past_diets_label.
  ///
  /// In en, this message translates to:
  /// **'Past diets'**
  String get precision_past_diets_label;

  /// No description provided for @precision_past_diets_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Keto, low-carb, plant-based, raw food'**
  String get precision_past_diets_hint;

  /// No description provided for @precision_past_diets_error.
  ///
  /// In en, this message translates to:
  /// **'Please describe your past diets'**
  String get precision_past_diets_error;

  /// No description provided for @precision_biomarker_upload_title.
  ///
  /// In en, this message translates to:
  /// **'Biomarker Upload'**
  String get precision_biomarker_upload_title;

  /// No description provided for @precision_upload_header.
  ///
  /// In en, this message translates to:
  /// **'Upload your medical records and connect devices'**
  String get precision_upload_header;

  /// No description provided for @precision_upload_subtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us create a more accurate and personalized nutrition plan'**
  String get precision_upload_subtitle;

  /// No description provided for @precision_upload_medical_records.
  ///
  /// In en, this message translates to:
  /// **'Upload Medical Records'**
  String get precision_upload_medical_records;

  /// No description provided for @precision_upload_medical_records_desc.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF, images, or other medical documents'**
  String get precision_upload_medical_records_desc;

  /// No description provided for @precision_choose_file.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get precision_choose_file;

  /// No description provided for @precision_connect_wearable.
  ///
  /// In en, this message translates to:
  /// **'Connect Wearable Device'**
  String get precision_connect_wearable;

  /// No description provided for @precision_connect_wearable_desc.
  ///
  /// In en, this message translates to:
  /// **'Sync data from your smartwatch, fitness tracker, or other devices'**
  String get precision_connect_wearable_desc;

  /// No description provided for @precision_uploaded_files.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Files'**
  String get precision_uploaded_files;

  /// No description provided for @precision_submit_assessment.
  ///
  /// In en, this message translates to:
  /// **'Submit Assessment'**
  String get precision_submit_assessment;

  /// No description provided for @precision_success_title.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get precision_success_title;

  /// No description provided for @precision_success_content.
  ///
  /// In en, this message translates to:
  /// **'Your Precision Nutrition Assessment has been submitted successfully. Our experts will review your information and create a personalized plan for you.'**
  String get precision_success_content;

  /// No description provided for @precision_view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get precision_view_details;

  /// No description provided for @precision_my_assessment_details.
  ///
  /// In en, this message translates to:
  /// **'My Nutrition Assessment Details'**
  String get precision_my_assessment_details;

  /// No description provided for @precision_edit_information.
  ///
  /// In en, this message translates to:
  /// **'Edit Information'**
  String get precision_edit_information;

  /// No description provided for @precision_download_pdf.
  ///
  /// In en, this message translates to:
  /// **'Download (PDF)'**
  String get precision_download_pdf;

  /// No description provided for @precision_back_to_page.
  ///
  /// In en, this message translates to:
  /// **'Back to Precision Nutrition Page'**
  String get precision_back_to_page;

  /// No description provided for @precision_plan_my_plan.
  ///
  /// In en, this message translates to:
  /// **'My Precision Nutrition Plan'**
  String get precision_plan_my_plan;

  /// No description provided for @precision_plan_tab_dietary.
  ///
  /// In en, this message translates to:
  /// **'Dietary Plan'**
  String get precision_plan_tab_dietary;

  /// No description provided for @precision_plan_tab_supplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get precision_plan_tab_supplements;

  /// No description provided for @precision_plan_tab_lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get precision_plan_tab_lifestyle;

  /// No description provided for @precision_plan_request_update.
  ///
  /// In en, this message translates to:
  /// **'Request Plan Update'**
  String get precision_plan_request_update;

  /// No description provided for @precision_plan_goal.
  ///
  /// In en, this message translates to:
  /// **'GOAL'**
  String get precision_plan_goal;

  /// No description provided for @precision_plan_strategy.
  ///
  /// In en, this message translates to:
  /// **'STRATEGY'**
  String get precision_plan_strategy;

  /// No description provided for @precision_plan_daily_calory.
  ///
  /// In en, this message translates to:
  /// **'DAILY CALORY TARGET'**
  String get precision_plan_daily_calory;

  /// No description provided for @precision_plan_recommended_foods.
  ///
  /// In en, this message translates to:
  /// **'Recommended Foods'**
  String get precision_plan_recommended_foods;

  /// No description provided for @precision_plan_foods_to_limit.
  ///
  /// In en, this message translates to:
  /// **'Foods to Limit'**
  String get precision_plan_foods_to_limit;

  /// No description provided for @precision_plan_weekly_meal_plan.
  ///
  /// In en, this message translates to:
  /// **'Weekly Meal Plan'**
  String get precision_plan_weekly_meal_plan;

  /// No description provided for @precision_plan_view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get precision_plan_view_all;

  /// No description provided for @precision_weekly_meal_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly Meal Plan'**
  String get precision_weekly_meal_plan_title;

  /// No description provided for @precision_day_meal_plan.
  ///
  /// In en, this message translates to:
  /// **'{day} Meal Plan'**
  String precision_day_meal_plan(String day);

  /// No description provided for @precision_meal_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get precision_meal_breakfast;

  /// No description provided for @precision_meal_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get precision_meal_lunch;

  /// No description provided for @precision_meal_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get precision_meal_dinner;

  /// No description provided for @precision_implementation_journey.
  ///
  /// In en, this message translates to:
  /// **'Implementation Journey'**
  String get precision_implementation_journey;

  /// No description provided for @precision_implementation_indepth_assessment.
  ///
  /// In en, this message translates to:
  /// **'In-Depth Assessment (2-4 weeks)'**
  String get precision_implementation_indepth_assessment;

  /// No description provided for @precision_implementation_intervention.
  ///
  /// In en, this message translates to:
  /// **'Intervention (3-6 months)'**
  String get precision_implementation_intervention;

  /// No description provided for @precision_implementation_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get precision_implementation_maintenance;

  /// No description provided for @precision_sub_health_metabolic.
  ///
  /// In en, this message translates to:
  /// **'Metabolic Function Optimization'**
  String get precision_sub_health_metabolic;

  /// No description provided for @precision_sub_health_gut_brain.
  ///
  /// In en, this message translates to:
  /// **'Gut-Brain Axis Regulation'**
  String get precision_sub_health_gut_brain;

  /// No description provided for @precision_sub_health_immune.
  ///
  /// In en, this message translates to:
  /// **'Immune Balance Intervention'**
  String get precision_sub_health_immune;

  /// No description provided for @precision_chronic_diabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes Management'**
  String get precision_chronic_diabetes;

  /// No description provided for @precision_chronic_cardio.
  ///
  /// In en, this message translates to:
  /// **'Cardiovascular Disease Support'**
  String get precision_chronic_cardio;

  /// No description provided for @precision_chronic_autoimmune.
  ///
  /// In en, this message translates to:
  /// **'Autoimmune Disease Care'**
  String get precision_chronic_autoimmune;

  /// No description provided for @precision_chronic_obesity.
  ///
  /// In en, this message translates to:
  /// **'Obesity Management'**
  String get precision_chronic_obesity;

  /// No description provided for @precision_anti_aging_cellular.
  ///
  /// In en, this message translates to:
  /// **'Cellular Regeneration & Mitochondrial Health'**
  String get precision_anti_aging_cellular;

  /// No description provided for @precision_anti_aging_cognitive.
  ///
  /// In en, this message translates to:
  /// **'Cognitive Longevity & Neuroprotection'**
  String get precision_anti_aging_cognitive;

  /// No description provided for @precision_anti_aging_hormonal.
  ///
  /// In en, this message translates to:
  /// **'Hormonal Balance & Vitality optimization'**
  String get precision_anti_aging_hormonal;

  /// No description provided for @precision_anti_aging_skin.
  ///
  /// In en, this message translates to:
  /// **'Skin & Structural Longevity'**
  String get precision_anti_aging_skin;

  /// No description provided for @precision_learn_more.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get precision_learn_more;

  /// No description provided for @precision_applicable_issues.
  ///
  /// In en, this message translates to:
  /// **'APPLICABLE ISSUES'**
  String get precision_applicable_issues;

  /// No description provided for @precision_services_include.
  ///
  /// In en, this message translates to:
  /// **'SERVICES INCLUDE'**
  String get precision_services_include;

  /// No description provided for @precision_interventions_include.
  ///
  /// In en, this message translates to:
  /// **'INTERVENTIONS INCLUDE'**
  String get precision_interventions_include;

  /// No description provided for @precision_solutions_include.
  ///
  /// In en, this message translates to:
  /// **'SOLUTIONS INCLUDE'**
  String get precision_solutions_include;

  /// No description provided for @precision_technologies_used.
  ///
  /// In en, this message translates to:
  /// **'TECHNOLOGIES USED'**
  String get precision_technologies_used;

  /// No description provided for @precision_programs_include.
  ///
  /// In en, this message translates to:
  /// **'PROGRAMS INCLUDE'**
  String get precision_programs_include;

  /// No description provided for @precision_precision_methods_include.
  ///
  /// In en, this message translates to:
  /// **'PRECISION METHODS INCLUDE'**
  String get precision_precision_methods_include;

  /// No description provided for @day_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get day_monday;

  /// No description provided for @day_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get day_tuesday;

  /// No description provided for @day_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get day_wednesday;

  /// No description provided for @day_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get day_thursday;

  /// No description provided for @day_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get day_friday;

  /// No description provided for @day_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get day_saturday;

  /// No description provided for @day_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get day_sunday;

  /// No description provided for @nutrition_protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutrition_protein;

  /// No description provided for @nutrition_carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get nutrition_carbs;

  /// No description provided for @nutrition_fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutrition_fat;

  /// No description provided for @admin_homecare_service_rates.
  ///
  /// In en, this message translates to:
  /// **'Service Rates'**
  String get admin_homecare_service_rates;

  /// No description provided for @admin_homecare_subscription_plans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get admin_homecare_subscription_plans;

  /// No description provided for @admin_homecare_update_successful.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get admin_homecare_update_successful;

  /// No description provided for @admin_homecare_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String admin_homecare_update_failed(String error);

  /// No description provided for @admin_homecare_no_service_rates.
  ///
  /// In en, this message translates to:
  /// **'No service rates found.'**
  String get admin_homecare_no_service_rates;

  /// No description provided for @admin_homecare_no_subscription_plans.
  ///
  /// In en, this message translates to:
  /// **'No subscription plans found.'**
  String get admin_homecare_no_subscription_plans;

  /// No description provided for @admin_homecare_edit_rate.
  ///
  /// In en, this message translates to:
  /// **'Edit Rate: {name}'**
  String admin_homecare_edit_rate(String name);

  /// No description provided for @admin_homecare_edit_plan.
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get admin_homecare_edit_plan;

  /// No description provided for @admin_homecare_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get admin_homecare_price;

  /// No description provided for @admin_homecare_quota_hours.
  ///
  /// In en, this message translates to:
  /// **'Quota (Hours)'**
  String get admin_homecare_quota_hours;

  /// No description provided for @admin_homecare_validity_days.
  ///
  /// In en, this message translates to:
  /// **'Validity (Days)'**
  String get admin_homecare_validity_days;

  /// No description provided for @admin_homecare_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_homecare_active;

  /// No description provided for @admin_homecare_inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get admin_homecare_inactive;

  /// No description provided for @admin_homecare_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get admin_homecare_save_changes;

  /// No description provided for @admin_homecare_plan_details.
  ///
  /// In en, this message translates to:
  /// **'Price: \${price} | Quota: {quota}h | Validity: {days}d'**
  String admin_homecare_plan_details(String price, int quota, int days);

  /// No description provided for @favourite_title.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourite_title;

  /// No description provided for @favourite_no_favorites.
  ///
  /// In en, this message translates to:
  /// **'You have no favorite professionals yet.'**
  String get favourite_no_favorites;

  /// No description provided for @favourite_error_fetching.
  ///
  /// In en, this message translates to:
  /// **'Error fetching data: {error}'**
  String favourite_error_fetching(String error);

  /// No description provided for @favourite_error_toggle.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String favourite_error_toggle(String error);

  /// No description provided for @medical_store_title.
  ///
  /// In en, this message translates to:
  /// **'Medical Store'**
  String get medical_store_title;

  /// No description provided for @medical_store_sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get medical_store_sort;

  /// No description provided for @medical_store_consumable_tab.
  ///
  /// In en, this message translates to:
  /// **'Homecare Consumable'**
  String get medical_store_consumable_tab;

  /// No description provided for @medical_store_poct_tab.
  ///
  /// In en, this message translates to:
  /// **'Point of Care Testing'**
  String get medical_store_poct_tab;

  /// No description provided for @medical_store_no_products.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get medical_store_no_products;

  /// No description provided for @medical_store_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get medical_store_load_failed;

  /// No description provided for @payment_title.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment_title;

  /// No description provided for @payment_order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get payment_order_summary;

  /// No description provided for @payment_charge.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get payment_charge;

  /// No description provided for @payment_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get payment_total;

  /// No description provided for @payment_select_method.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get payment_select_method;

  /// No description provided for @payment_confirm_btn.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get payment_confirm_btn;

  /// No description provided for @payment_pay_btn.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payment_pay_btn(String amount);

  /// No description provided for @payment_success_title.
  ///
  /// In en, this message translates to:
  /// **'Payment Success'**
  String get payment_success_title;

  /// No description provided for @payment_success_content.
  ///
  /// In en, this message translates to:
  /// **'Your money has been successfully sent to {name}.'**
  String payment_success_content(String name);

  /// No description provided for @payment_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get payment_amount;

  /// No description provided for @payment_how_is_experience.
  ///
  /// In en, this message translates to:
  /// **'How is your experience?'**
  String get payment_how_is_experience;

  /// No description provided for @payment_feedback_help.
  ///
  /// In en, this message translates to:
  /// **'Your feedback will help us to improve your\nexperience better'**
  String get payment_feedback_help;

  /// No description provided for @payment_please_feedback_btn.
  ///
  /// In en, this message translates to:
  /// **'Please Feedback'**
  String get payment_please_feedback_btn;

  /// No description provided for @payment_return_home_btn.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get payment_return_home_btn;

  /// No description provided for @payment_feedback_thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get payment_feedback_thank_you;

  /// No description provided for @payment_feedback_success_content.
  ///
  /// In en, this message translates to:
  /// **'This appointment has been completed and can be viewed in the completed orders menu'**
  String get payment_feedback_success_content;

  /// No description provided for @payment_view_detail_btn.
  ///
  /// In en, this message translates to:
  /// **'View Detail'**
  String get payment_view_detail_btn;

  /// No description provided for @payment_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get payment_excellent;

  /// No description provided for @payment_rated_text.
  ///
  /// In en, this message translates to:
  /// **'You rated {name} {stars} stars'**
  String payment_rated_text(String name, int stars);

  /// No description provided for @payment_write_text_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your text'**
  String get payment_write_text_hint;

  /// No description provided for @payment_give_tips.
  ///
  /// In en, this message translates to:
  /// **'Give some tips to {name}'**
  String payment_give_tips(String name);

  /// No description provided for @payment_enter_other_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter other amount'**
  String get payment_enter_other_amount;

  /// No description provided for @payment_enter_amount_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get payment_enter_amount_hint;

  /// No description provided for @payment_submit_btn.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get payment_submit_btn;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed: {message}'**
  String payment_failed(String message);

  /// No description provided for @payment_feedback_failed.
  ///
  /// In en, this message translates to:
  /// **'Feedback Failed: {message}'**
  String payment_feedback_failed(String message);

  /// No description provided for @payment_purchase_failed.
  ///
  /// In en, this message translates to:
  /// **'Purchase Failed: {message}'**
  String payment_purchase_failed(String message);

  /// No description provided for @payment_subscription_success_title.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get payment_subscription_success_title;

  /// No description provided for @payment_subscription_success_content.
  ///
  /// In en, this message translates to:
  /// **'You have successfully subscribed to {plan}'**
  String payment_subscription_success_content(String plan);

  /// No description provided for @schedule_working_schedule_title.
  ///
  /// In en, this message translates to:
  /// **'Working Schedule'**
  String get schedule_working_schedule_title;

  /// No description provided for @schedule_weekly_hours_tab.
  ///
  /// In en, this message translates to:
  /// **'Weekly Hours'**
  String get schedule_weekly_hours_tab;

  /// No description provided for @schedule_date_specific_hours_tab.
  ///
  /// In en, this message translates to:
  /// **'Date-specific Hours'**
  String get schedule_date_specific_hours_tab;

  /// No description provided for @schedule_preview_tab.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get schedule_preview_tab;

  /// No description provided for @schedule_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get schedule_unavailable;

  /// No description provided for @schedule_edit_hours.
  ///
  /// In en, this message translates to:
  /// **'Edit Hours'**
  String get schedule_edit_hours;

  /// No description provided for @schedule_add_hours.
  ///
  /// In en, this message translates to:
  /// **'Add Hours'**
  String get schedule_add_hours;

  /// No description provided for @schedule_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get schedule_start;

  /// No description provided for @schedule_end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get schedule_end;

  /// No description provided for @schedule_please_select_time.
  ///
  /// In en, this message translates to:
  /// **'Please select both start and end time.'**
  String get schedule_please_select_time;

  /// No description provided for @schedule_end_time_error.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get schedule_end_time_error;

  /// No description provided for @schedule_delete_time_block_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Time Block?'**
  String get schedule_delete_time_block_title;

  /// No description provided for @schedule_delete_time_block_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {start} - {end}?'**
  String schedule_delete_time_block_content(String start, String end);

  /// No description provided for @schedule_add_time_slot_title.
  ///
  /// In en, this message translates to:
  /// **'Add Time Slot'**
  String get schedule_add_time_slot_title;

  /// No description provided for @schedule_add_btn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get schedule_add_btn;

  /// No description provided for @schedule_revert_to_weekly.
  ///
  /// In en, this message translates to:
  /// **'Revert to Weekly'**
  String get schedule_revert_to_weekly;

  /// No description provided for @schedule_i_am_unavailable.
  ///
  /// In en, this message translates to:
  /// **'I am unavailable'**
  String get schedule_i_am_unavailable;

  /// No description provided for @schedule_mark_day_off.
  ///
  /// In en, this message translates to:
  /// **'Mark this specific date as a Day Off'**
  String get schedule_mark_day_off;

  /// No description provided for @schedule_specific_hours.
  ///
  /// In en, this message translates to:
  /// **'Specific Hours'**
  String get schedule_specific_hours;

  /// No description provided for @schedule_no_slots_added.
  ///
  /// In en, this message translates to:
  /// **'No slots added yet. You appear unavailable.'**
  String get schedule_no_slots_added;

  /// No description provided for @schedule_using_weekly.
  ///
  /// In en, this message translates to:
  /// **'Using Weekly Schedule'**
  String get schedule_using_weekly;

  /// No description provided for @schedule_customize_hours.
  ///
  /// In en, this message translates to:
  /// **'Customize Hours for this Date'**
  String get schedule_customize_hours;

  /// No description provided for @schedule_reset_default_title.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default?'**
  String get schedule_reset_default_title;

  /// No description provided for @schedule_reset_default_content.
  ///
  /// In en, this message translates to:
  /// **'This will remove your custom settings for this day. The schedule will revert to your recurring weekly rules.'**
  String get schedule_reset_default_content;

  /// No description provided for @schedule_reset_btn.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get schedule_reset_btn;

  /// No description provided for @schedule_select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get schedule_select_date;

  /// No description provided for @schedule_available_hours.
  ///
  /// In en, this message translates to:
  /// **'Available Hours'**
  String get schedule_available_hours;

  /// No description provided for @schedule_no_available_slots.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this day.'**
  String get schedule_no_available_slots;

  /// No description provided for @schedule_availability_added.
  ///
  /// In en, this message translates to:
  /// **'Availability added!'**
  String get schedule_availability_added;

  /// No description provided for @schedule_availability_updated.
  ///
  /// In en, this message translates to:
  /// **'Availability updated!'**
  String get schedule_availability_updated;

  /// No description provided for @schedule_availability_removed.
  ///
  /// In en, this message translates to:
  /// **'Availability removed!'**
  String get schedule_availability_removed;

  /// No description provided for @schedule_reverted_success.
  ///
  /// In en, this message translates to:
  /// **'Reverted to weekly schedule'**
  String get schedule_reverted_success;

  /// No description provided for @schedule_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated successfully'**
  String get schedule_updated_success;

  /// No description provided for @rpm_title.
  ///
  /// In en, this message translates to:
  /// **'Monitor My Vitals'**
  String get rpm_title;

  /// No description provided for @rpm_heart_performance.
  ///
  /// In en, this message translates to:
  /// **'Heart Performance'**
  String get rpm_heart_performance;

  /// No description provided for @rpm_blood_oxygen.
  ///
  /// In en, this message translates to:
  /// **'Blood Oxygen Saturation (SpO2)'**
  String get rpm_blood_oxygen;

  /// No description provided for @rpm_blood_glucose.
  ///
  /// In en, this message translates to:
  /// **'Blood Glucose'**
  String get rpm_blood_glucose;

  /// No description provided for @rpm_blood_pressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get rpm_blood_pressure;

  /// No description provided for @rpm_add_new_vital.
  ///
  /// In en, this message translates to:
  /// **'+ Add New Vital'**
  String get rpm_add_new_vital;

  /// No description provided for @rpm_link_device.
  ///
  /// In en, this message translates to:
  /// **'Link Device'**
  String get rpm_link_device;

  /// No description provided for @rpm_add_record.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get rpm_add_record;

  /// No description provided for @second_opinion_title.
  ///
  /// In en, this message translates to:
  /// **'Second Opinion'**
  String get second_opinion_title;

  /// No description provided for @second_opinion_teleradiology_title.
  ///
  /// In en, this message translates to:
  /// **'Teleradiology'**
  String get second_opinion_teleradiology_title;

  /// No description provided for @second_opinion_teleradiology_desc.
  ///
  /// In en, this message translates to:
  /// **'Discover expert second opinions on medical imaging from our specialized radiologists, guiding your healthcare decisions with focused knowledge in cardiovascular, musculoskeletal, head & neck, and neuro-imaging'**
  String get second_opinion_teleradiology_desc;

  /// No description provided for @second_opinion_telepathology_title.
  ///
  /// In en, this message translates to:
  /// **'Telepathology'**
  String get second_opinion_telepathology_title;

  /// No description provided for @second_opinion_telepathology_desc.
  ///
  /// In en, this message translates to:
  /// **'Our specialists leverage cutting-edge telemedicine tech for remote pathology image reviews and consultations with medical teams globally'**
  String get second_opinion_telepathology_desc;

  /// No description provided for @teleradiology_title.
  ///
  /// In en, this message translates to:
  /// **'Teleradiology'**
  String get teleradiology_title;

  /// No description provided for @teleradiology_disease_name.
  ///
  /// In en, this message translates to:
  /// **'Disease Name'**
  String get teleradiology_disease_name;

  /// No description provided for @teleradiology_disease_history.
  ///
  /// In en, this message translates to:
  /// **'Disease History Description'**
  String get teleradiology_disease_history;

  /// No description provided for @teleradiology_disease_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g Diptheria, Pneumonia'**
  String get teleradiology_disease_hint;

  /// No description provided for @teleradiology_other_biomarkers.
  ///
  /// In en, this message translates to:
  /// **'Other Biomakers'**
  String get teleradiology_other_biomarkers;

  /// No description provided for @teleradiology_history_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter disease history description here...'**
  String get teleradiology_history_hint;

  /// No description provided for @teleradiology_patient_info.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get teleradiology_patient_info;

  /// No description provided for @teleradiology_biomarker_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter other biomarker information here...'**
  String get teleradiology_biomarker_hint;

  /// No description provided for @teleradiology_radiology_images.
  ///
  /// In en, this message translates to:
  /// **'Radiology Images'**
  String get teleradiology_radiology_images;

  /// No description provided for @teleradiology_ct_scan.
  ///
  /// In en, this message translates to:
  /// **'CT Scan'**
  String get teleradiology_ct_scan;

  /// No description provided for @teleradiology_mri_scan.
  ///
  /// In en, this message translates to:
  /// **'MRI Scan'**
  String get teleradiology_mri_scan;

  /// No description provided for @teleradiology_mammogram.
  ///
  /// In en, this message translates to:
  /// **'Mammogram'**
  String get teleradiology_mammogram;

  /// No description provided for @teleradiology_medical_opinion.
  ///
  /// In en, this message translates to:
  /// **'Medical Opinion'**
  String get teleradiology_medical_opinion;

  /// No description provided for @teleradiology_professional_only_info.
  ///
  /// In en, this message translates to:
  /// **'** Information below will be provided by Medical Professionals only'**
  String get teleradiology_professional_only_info;

  /// No description provided for @teleradiology_diagnostic_opinion.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic opinion'**
  String get teleradiology_diagnostic_opinion;

  /// No description provided for @teleradiology_recommendation_opinion.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Opinion'**
  String get teleradiology_recommendation_opinion;

  /// No description provided for @physiotherapy_title.
  ///
  /// In en, this message translates to:
  /// **'Physiotherapy'**
  String get physiotherapy_title;

  /// No description provided for @physiotherapy_musculoskeletal_title.
  ///
  /// In en, this message translates to:
  /// **'Musculoskeletal Physiotherapy'**
  String get physiotherapy_musculoskeletal_title;

  /// No description provided for @physiotherapy_musculoskeletal_desc.
  ///
  /// In en, this message translates to:
  /// **'Musculoskeletal physiotherapy treats injuries involving muscles, joints, bones, ligaments, tendons, and nerves.'**
  String get physiotherapy_musculoskeletal_desc;

  /// No description provided for @physiotherapy_neurological_title.
  ///
  /// In en, this message translates to:
  /// **'Neurological Physiotherapy'**
  String get physiotherapy_neurological_title;

  /// No description provided for @physiotherapy_neurological_desc.
  ///
  /// In en, this message translates to:
  /// **'Neurological physiotherapy treats conditions affecting the nervous system, including the brain, spinal cord, and nerves.'**
  String get physiotherapy_neurological_desc;

  /// No description provided for @physiotherapy_book_appointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get physiotherapy_book_appointment;

  /// No description provided for @physiotherapy_duration_label.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get physiotherapy_duration_label;

  /// No description provided for @physiotherapy_duration_value.
  ///
  /// In en, this message translates to:
  /// **'45–60 minutes per session'**
  String get physiotherapy_duration_value;

  /// No description provided for @physiotherapy_treatment_type_label.
  ///
  /// In en, this message translates to:
  /// **'TREATMENT TYPE'**
  String get physiotherapy_treatment_type_label;

  /// No description provided for @physiotherapy_suitable_for_title.
  ///
  /// In en, this message translates to:
  /// **'This Service is suitable for:'**
  String get physiotherapy_suitable_for_title;

  /// No description provided for @physiotherapy_what_you_get_title.
  ///
  /// In en, this message translates to:
  /// **'What you’ll get'**
  String get physiotherapy_what_you_get_title;

  /// No description provided for @physiotherapy_ms_item_1.
  ///
  /// In en, this message translates to:
  /// **'Posture & movement correction'**
  String get physiotherapy_ms_item_1;

  /// No description provided for @physiotherapy_ms_item_2.
  ///
  /// In en, this message translates to:
  /// **'Stretching & strengthening'**
  String get physiotherapy_ms_item_2;

  /// No description provided for @physiotherapy_ms_item_3.
  ///
  /// In en, this message translates to:
  /// **'Exercise therapy'**
  String get physiotherapy_ms_item_3;

  /// No description provided for @physiotherapy_ms_item_4.
  ///
  /// In en, this message translates to:
  /// **'Manual therapy'**
  String get physiotherapy_ms_item_4;

  /// No description provided for @physiotherapy_ms_reason_1.
  ///
  /// In en, this message translates to:
  /// **'Overuse tendon injuries'**
  String get physiotherapy_ms_reason_1;

  /// No description provided for @physiotherapy_ms_reason_2.
  ///
  /// In en, this message translates to:
  /// **'Joint wear and tear (e.g. arthritis)'**
  String get physiotherapy_ms_reason_2;

  /// No description provided for @physiotherapy_ms_reason_3.
  ///
  /// In en, this message translates to:
  /// **'Muscle strain'**
  String get physiotherapy_ms_reason_3;

  /// No description provided for @physiotherapy_ms_reason_4.
  ///
  /// In en, this message translates to:
  /// **'Ligament sprain'**
  String get physiotherapy_ms_reason_4;

  /// No description provided for @physiotherapy_ms_reason_5.
  ///
  /// In en, this message translates to:
  /// **'Joint pain & stiffness'**
  String get physiotherapy_ms_reason_5;

  /// No description provided for @physiotherapy_ms_reason_6.
  ///
  /// In en, this message translates to:
  /// **'Movement-related pain'**
  String get physiotherapy_ms_reason_6;

  /// No description provided for @physiotherapy_ms_benefit_1.
  ///
  /// In en, this message translates to:
  /// **'Pain reduction'**
  String get physiotherapy_ms_benefit_1;

  /// No description provided for @physiotherapy_ms_benefit_2.
  ///
  /// In en, this message translates to:
  /// **'Improved mobility'**
  String get physiotherapy_ms_benefit_2;

  /// No description provided for @physiotherapy_ms_benefit_3.
  ///
  /// In en, this message translates to:
  /// **'Better joint function'**
  String get physiotherapy_ms_benefit_3;

  /// No description provided for @physiotherapy_ms_benefit_4.
  ///
  /// In en, this message translates to:
  /// **'Easier daily activities'**
  String get physiotherapy_ms_benefit_4;

  /// No description provided for @physiotherapy_ms_benefit_5.
  ///
  /// In en, this message translates to:
  /// **'Faster recovery'**
  String get physiotherapy_ms_benefit_5;

  /// No description provided for @physiotherapy_neuro_item_1.
  ///
  /// In en, this message translates to:
  /// **'Strength & coordination exercises'**
  String get physiotherapy_neuro_item_1;

  /// No description provided for @physiotherapy_neuro_item_2.
  ///
  /// In en, this message translates to:
  /// **'Functional movement training'**
  String get physiotherapy_neuro_item_2;

  /// No description provided for @physiotherapy_neuro_item_3.
  ///
  /// In en, this message translates to:
  /// **'Balance & gait training'**
  String get physiotherapy_neuro_item_3;

  /// No description provided for @physiotherapy_neuro_item_4.
  ///
  /// In en, this message translates to:
  /// **'Neuro-motor training'**
  String get physiotherapy_neuro_item_4;

  /// No description provided for @physiotherapy_neuro_reason_1.
  ///
  /// In en, this message translates to:
  /// **'Stroke recovery'**
  String get physiotherapy_neuro_reason_1;

  /// No description provided for @physiotherapy_neuro_reason_2.
  ///
  /// In en, this message translates to:
  /// **'Parkinson’s disease'**
  String get physiotherapy_neuro_reason_2;

  /// No description provided for @physiotherapy_neuro_reason_3.
  ///
  /// In en, this message translates to:
  /// **'Multiple sclerosis'**
  String get physiotherapy_neuro_reason_3;

  /// No description provided for @physiotherapy_neuro_reason_4.
  ///
  /// In en, this message translates to:
  /// **'Spinal cord injury'**
  String get physiotherapy_neuro_reason_4;

  /// No description provided for @physiotherapy_neuro_reason_5.
  ///
  /// In en, this message translates to:
  /// **'Traumatic brain injury'**
  String get physiotherapy_neuro_reason_5;

  /// No description provided for @physiotherapy_neuro_reason_6.
  ///
  /// In en, this message translates to:
  /// **'Nerve damage'**
  String get physiotherapy_neuro_reason_6;

  /// No description provided for @physiotherapy_neuro_reason_7.
  ///
  /// In en, this message translates to:
  /// **'Balance & coordination disorders'**
  String get physiotherapy_neuro_reason_7;

  /// No description provided for @physiotherapy_neuro_benefit_1.
  ///
  /// In en, this message translates to:
  /// **'Better movement control'**
  String get physiotherapy_neuro_benefit_1;

  /// No description provided for @physiotherapy_neuro_benefit_2.
  ///
  /// In en, this message translates to:
  /// **'Improved balance & coordination'**
  String get physiotherapy_neuro_benefit_2;

  /// No description provided for @physiotherapy_neuro_benefit_3.
  ///
  /// In en, this message translates to:
  /// **'Increased independence in daily activities'**
  String get physiotherapy_neuro_benefit_3;

  /// No description provided for @physiotherapy_neuro_benefit_4.
  ///
  /// In en, this message translates to:
  /// **'Reduced physical limitations'**
  String get physiotherapy_neuro_benefit_4;

  /// No description provided for @physiotherapy_neuro_benefit_5.
  ///
  /// In en, this message translates to:
  /// **'Improved confidence & well-being'**
  String get physiotherapy_neuro_benefit_5;

  /// No description provided for @physiotherapy_scheduling_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get physiotherapy_scheduling_duration;

  /// No description provided for @physiotherapy_scheduling_minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String physiotherapy_scheduling_minutes(int minutes);

  /// No description provided for @physiotherapy_scheduling_select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get physiotherapy_scheduling_select_date;

  /// No description provided for @physiotherapy_scheduling_select_hour.
  ///
  /// In en, this message translates to:
  /// **'Select Hour'**
  String get physiotherapy_scheduling_select_hour;

  /// No description provided for @physiotherapy_scheduling_no_slots.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this day.'**
  String get physiotherapy_scheduling_no_slots;

  /// No description provided for @physiotherapy_scheduling_failed_load_slots.
  ///
  /// In en, this message translates to:
  /// **'Failed to load slots'**
  String get physiotherapy_scheduling_failed_load_slots;

  /// No description provided for @physiotherapy_scheduling_submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get physiotherapy_scheduling_submitting;

  /// No description provided for @physiotherapy_scheduling_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get physiotherapy_scheduling_submit;

  /// No description provided for @physiotherapy_flow_success.
  ///
  /// In en, this message translates to:
  /// **'Appointment created successfully'**
  String get physiotherapy_flow_success;

  /// No description provided for @physiotherapy_flow_failure.
  ///
  /// In en, this message translates to:
  /// **'Failed to create appointment'**
  String get physiotherapy_flow_failure;

  /// No description provided for @physiotherapy_flow_failure_with_reason.
  ///
  /// In en, this message translates to:
  /// **'Failed to create appointment:\n{reason}'**
  String physiotherapy_flow_failure_with_reason(String reason);

  /// No description provided for @physiotherapy_summary.
  ///
  /// In en, this message translates to:
  /// **'Physiotherapy Session ({duration} mins)'**
  String physiotherapy_summary(int duration);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
