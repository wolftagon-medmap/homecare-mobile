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

  /// No description provided for @appointment_title.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointment_title;

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
