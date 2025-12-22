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
