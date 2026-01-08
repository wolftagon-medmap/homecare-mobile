///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsBookingEn booking = TranslationsBookingEn._(_root);
	late final TranslationsDashboardEn dashboard = TranslationsDashboardEn._(_root);
	late final TranslationsGlobalEn global = TranslationsGlobalEn._(_root);
	late final TranslationsNursingEn nursing = TranslationsNursingEn._(_root);
	late final TranslationsPharmacyEn pharmacy = TranslationsPharmacyEn._(_root);
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthButtonEn button = TranslationsAuthButtonEn._(_root);

	/// en: 'Or continue with'
	String get continue_with_alternative_text => 'Or continue with';

	late final TranslationsAuthForgotPasswordEn forgot_password = TranslationsAuthForgotPasswordEn._(_root);
	late final TranslationsAuthFormEn form = TranslationsAuthFormEn._(_root);
	late final TranslationsAuthLoginEn login = TranslationsAuthLoginEn._(_root);
	late final TranslationsAuthOtpVerificationEn otp_verification = TranslationsAuthOtpVerificationEn._(_root);
	late final TranslationsAuthRegisterEn register = TranslationsAuthRegisterEn._(_root);
	late final TranslationsAuthResetPasswordEn reset_password = TranslationsAuthResetPasswordEn._(_root);
	late final TranslationsAuthResetPasswordSuccessEn reset_password_success = TranslationsAuthResetPasswordSuccessEn._(_root);
	late final TranslationsAuthUserRoleEn user_role = TranslationsAuthUserRoleEn._(_root);
}

// Path: booking
class TranslationsBookingEn {
	TranslationsBookingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsBookingAddonEn addon = TranslationsBookingAddonEn._(_root);

	/// en: 'Book Appointment'
	String get book_appointment => 'Book Appointment';

	late final TranslationsBookingHealthStatusEn health_status = TranslationsBookingHealthStatusEn._(_root);
	late final TranslationsBookingIssueEn issue = TranslationsBookingIssueEn._(_root);
	late final TranslationsBookingProfessionalDetailEn professional_detail = TranslationsBookingProfessionalDetailEn._(_root);
	late final TranslationsBookingProfessionalSearchEn professional_search = TranslationsBookingProfessionalSearchEn._(_root);
	late final TranslationsBookingScheduleEn schedule = TranslationsBookingScheduleEn._(_root);
}

// Path: dashboard
class TranslationsDashboardEn {
	TranslationsDashboardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Allied Health'
	String get allied_services => 'Allied Health';

	/// en: 'Chat With AI doctor for all your health questions'
	String get chat_ai_placeholder => 'Chat With AI doctor for all your health questions';

	/// en: 'Live Longer & Live Healthier, {displayName}!'
	String greeting({required Object displayName}) => 'Live Longer & Live Healthier, ${displayName}!';

	late final TranslationsDashboardServicesEn services = TranslationsDashboardServicesEn._(_root);
}

// Path: global
class TranslationsGlobalEn {
	TranslationsGlobalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Book Now'
	String get book_now => 'Book Now';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Complete'
	String get complete => 'Complete';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Description'
	String get description => 'Description';

	late final TranslationsGlobalDialogEn dialog = TranslationsGlobalDialogEn._(_root);

	/// en: 'Edit Information'
	String get edit_information => 'Edit Information';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Error: {error}'
	String error_message({required Object error}) => 'Error: ${error}';

	late final TranslationsGlobalMessagesEn messages = TranslationsGlobalMessagesEn._(_root);

	/// en: 'Modify'
	String get modify => 'Modify';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'No'
	String get no => 'No';

	/// en: 'No data available'
	String get no_data => 'No data available';

	/// en: 'None'
	String get none => 'None';

	/// en: 'Not specified'
	String get not_specified => 'Not specified';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Other'
	String get other => 'Other';

	/// en: 'Ready'
	String get ready => 'Ready';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Saving...'
	String get saving => 'Saving...';

	/// en: 'Services'
	String get services => 'Services';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Submit'
	String get submit => 'Submit';

	/// en: 'Unknown Location'
	String get unknown_location => 'Unknown Location';

	/// en: 'Update'
	String get update => 'Update';

	/// en: 'Yes'
	String get yes => 'Yes';
}

// Path: nursing
class TranslationsNursingEn {
	TranslationsNursingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsNursingServicesEn services = TranslationsNursingServicesEn._(_root);

	/// en: 'Home Nursing'
	String get title => 'Home Nursing';
}

// Path: pharmacy
class TranslationsPharmacyEn {
	TranslationsPharmacyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPharmacyServicesEn services = TranslationsPharmacyServicesEn._(_root);

	/// en: 'iRX Pharmacist Service'
	String get title => 'iRX Pharmacist Service';
}

// Path: auth.button
class TranslationsAuthButtonEn {
	TranslationsAuthButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: auth.forgot_password
class TranslationsAuthForgotPasswordEn {
	TranslationsAuthForgotPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthForgotPasswordFormEn form = TranslationsAuthForgotPasswordFormEn._(_root);
	late final TranslationsAuthForgotPasswordMessageEn message = TranslationsAuthForgotPasswordMessageEn._(_root);

	/// en: 'Send Code'
	String get send_code_button => 'Send Code';

	/// en: 'Don't worry! Please enter the email address linked with your account.'
	String get subtitle => 'Don\'t worry! Please enter the email address linked with your account.';

	/// en: 'Forgot Password?'
	String get title => 'Forgot Password?';
}

// Path: auth.form
class TranslationsAuthFormEn {
	TranslationsAuthFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthFormLabelEn label = TranslationsAuthFormLabelEn._(_root);
	late final TranslationsAuthFormValidationEn validation = TranslationsAuthFormValidationEn._(_root);
}

// Path: auth.login
class TranslationsAuthLoginEn {
	TranslationsAuthLoginEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthLoginButtonEn button = TranslationsAuthLoginButtonEn._(_root);
	late final TranslationsAuthLoginFormEn form = TranslationsAuthLoginFormEn._(_root);
	late final TranslationsAuthLoginRoleSelectionDialogEn role_selection_dialog = TranslationsAuthLoginRoleSelectionDialogEn._(_root);

	/// en: 'Welcome Back you've been missed'
	String get subtitle => 'Welcome Back you\'ve\nbeen missed';

	/// en: 'Login Here'
	String get title => 'Login Here';
}

// Path: auth.otp_verification
class TranslationsAuthOtpVerificationEn {
	TranslationsAuthOtpVerificationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthOtpVerificationButtonEn button = TranslationsAuthOtpVerificationButtonEn._(_root);
	late final TranslationsAuthOtpVerificationMessageEn message = TranslationsAuthOtpVerificationMessageEn._(_root);

	/// en: 'Resend in {seconds} seconds'
	String resend_time_countdown({required Object seconds}) => 'Resend in ${seconds} seconds';

	/// en: 'Enter the code that we have sent to your email {email}'
	String subtitle({required Object email}) => 'Enter the code that we have sent to your email ${email}';

	/// en: 'Enter Verification Code'
	String get title => 'Enter Verification Code';
}

// Path: auth.register
class TranslationsAuthRegisterEn {
	TranslationsAuthRegisterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthRegisterButtonEn button = TranslationsAuthRegisterButtonEn._(_root);
	late final TranslationsAuthRegisterRegistrationSuccessDialogEn registration_success_dialog = TranslationsAuthRegisterRegistrationSuccessDialogEn._(_root);

	/// en: 'Create an account so you can explore all the existing jobs'
	String get subtitle => 'Create an account so you can explore all the\nexisting jobs';

	/// en: 'Create Account'
	String get title => 'Create Account';
}

// Path: auth.reset_password
class TranslationsAuthResetPasswordEn {
	TranslationsAuthResetPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthResetPasswordButtonEn button = TranslationsAuthResetPasswordButtonEn._(_root);

	/// en: 'Please enter your new password'
	String get subtitle => 'Please enter your new password';

	/// en: 'Reset Password'
	String get title => 'Reset Password';
}

// Path: auth.reset_password_success
class TranslationsAuthResetPasswordSuccessEn {
	TranslationsAuthResetPasswordSuccessEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'You have successfully reset your password. Please use your new password when logging in.'
	String get body => 'You have successfully reset your password. Please use your new password when logging in.';

	late final TranslationsAuthResetPasswordSuccessButtonEn button = TranslationsAuthResetPasswordSuccessButtonEn._(_root);

	/// en: 'Password Reset Successful!'
	String get title => 'Password Reset Successful!';
}

// Path: auth.user_role
class TranslationsAuthUserRoleEn {
	TranslationsAuthUserRoleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Caregiver/Helper'
	String get caregiver => 'Caregiver/Helper';

	/// en: 'Nurse'
	String get nurse => 'Nurse';

	/// en: 'Patient'
	String get patient => 'Patient';

	/// en: 'Pharmacist'
	String get pharmacist => 'Pharmacist';

	/// en: 'Physiotherapist'
	String get physiotherapist => 'Physiotherapist';

	/// en: 'Radiologist'
	String get radiologist => 'Radiologist';
}

// Path: booking.addon
class TranslationsBookingAddonEn {
	TranslationsBookingAddonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No add-on services available.'
	String get empty => 'No add-on services available.';

	/// en: 'Estimated Budget'
	String get estimated_budget => 'Estimated Budget';

	late final TranslationsBookingAddonTitleEn title = TranslationsBookingAddonTitleEn._(_root);
}

// Path: booking.health_status
class TranslationsBookingHealthStatusEn {
	TranslationsBookingHealthStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No medical records available.'
	String get empty_record => 'No medical records available.';

	/// en: 'Select your mobility status'
	String get mobility_label => 'Select your mobility status';

	/// en: 'Please select a record'
	String get record_hint => 'Please select a record';

	/// en: 'Select a related health record'
	String get record_label => 'Select a related health record';

	/// en: 'Personal Case Detail'
	String get title => 'Personal Case Detail';
}

// Path: booking.issue
class TranslationsBookingIssueEn {
	TranslationsBookingIssueEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add an Issue'
	String get add_issue_button => 'Add an Issue';

	/// en: 'Add an Issue'
	String get add_issue_title => 'Add an Issue';

	/// en: 'Service Case'
	String get default_page_title => 'Service Case';

	late final TranslationsBookingIssueDeleteDialogEn delete_dialog = TranslationsBookingIssueDeleteDialogEn._(_root);

	/// en: 'Edit Issue'
	String get edit_issue_title => 'Edit Issue';

	/// en: 'There are no issues added yet. Please add one or more issues so you can proceed to the next step.'
	String get empty_issue => 'There are no issues added yet.\n Please add one or more issues so\nyou can proceed to the next step.';

	/// en: 'Tell us your concerns'
	String get fill_complaint_instruction => 'Tell us your concerns';

	late final TranslationsBookingIssueFormEn form = TranslationsBookingIssueFormEn._(_root);

	/// en: 'Images'
	String get images => 'Images';

	late final TranslationsBookingIssueMessagesEn messages = TranslationsBookingIssueMessagesEn._(_root);

	/// en: 'Nurse Services Case'
	String get nurse_page_title => 'Nurse Services Case';

	/// en: 'Pharmacist Services Case'
	String get pharmacy_page_title => 'Pharmacist Services Case';

	/// en: 'Radiologist Services Case'
	String get radiology_page_title => 'Radiologist Services Case';

	/// en: 'Updated on: {date}'
	String updated_on({required Object date}) => 'Updated on: ${date}';
}

// Path: booking.professional_detail
class TranslationsBookingProfessionalDetailEn {
	TranslationsBookingProfessionalDetailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About Me'
	String get about_me => 'About Me';

	/// en: 'Professional Certificate'
	String get certificates => 'Professional Certificate';

	/// en: 'Experience'
	String get experience_label => 'Experience';

	/// en: 'ID Number: {number}'
	String id_number({required Object number}) => 'ID Number: ${number}';

	/// en: 'Issued: {date}'
	String issued_on({required Object date}) => 'Issued: ${date}';

	/// en: 'No certificate available.'
	String get no_certificate => 'No certificate available.';

	/// en: 'No reviews available yet.'
	String get no_reviews => 'No reviews available yet.';

	/// en: 'Patients'
	String get patients_label => 'Patients';

	/// en: 'Rating'
	String get rating_label => 'Rating';

	/// en: 'Reviews'
	String get reviews => 'Reviews';

	/// en: 'Schedule Appointment'
	String get schedule_button => 'Schedule Appointment';

	/// en: 'See All'
	String get see_all_button => 'See All';

	late final TranslationsBookingProfessionalDetailTitleEn title = TranslationsBookingProfessionalDetailTitleEn._(_root);

	/// en: 'Working Information'
	String get working_info => 'Working Information';
}

// Path: booking.professional_search
class TranslationsBookingProfessionalSearchEn {
	TranslationsBookingProfessionalSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appointment'
	String get appointment_button => 'Appointment';

	/// en: 'No professionals found matching your criteria.'
	String get empty => 'No professionals found matching your criteria.';

	/// en: 'Filtering by {count} selected services'
	String filter_text({required Object count}) => 'Filtering by ${count} selected services';

	late final TranslationsBookingProfessionalSearchTitleEn title = TranslationsBookingProfessionalSearchTitleEn._(_root);
}

// Path: booking.schedule
class TranslationsBookingScheduleEn {
	TranslationsBookingScheduleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No available slots for this day.'
	String get empty_slots => 'No available slots for this day.';

	late final TranslationsBookingScheduleMessagesEn messages = TranslationsBookingScheduleMessagesEn._(_root);

	/// en: 'Select Date'
	String get select_date => 'Select Date';

	/// en: 'Select Hour'
	String get select_hour => 'Select Hour';

	/// en: 'Submit'
	String get submit_button => 'Submit';

	/// en: 'Submitting...'
	String get submitting_button => 'Submitting...';

	/// en: 'Select Schedule'
	String get title => 'Select Schedule';
}

// Path: dashboard.services
class TranslationsDashboardServicesEn {
	TranslationsDashboardServicesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Diabetic Care'
	String get diabetic_care => 'Diabetic Care';

	/// en: 'Dietitian Service'
	String get dietitian => 'Dietitian Service';

	/// en: 'Health Risk Assessment'
	String get health_risk_assessment => 'Health Risk Assessment';

	/// en: 'Home Health Screening'
	String get home_screening => 'Home Health Screening';

	/// en: 'Home Care for Elderly'
	String get homecare_for_elderly => 'Home Care for Elderly';

	/// en: 'Home Nursing'
	String get nursing => 'Home Nursing';

	/// en: 'iRX Pharmacist Service'
	String get pharmacist => 'iRX Pharmacist Service';

	/// en: 'Physiotherapy'
	String get physiotherapy => 'Physiotherapy';

	/// en: 'Precision Nutrition'
	String get precision_nutrition => 'Precision Nutrition';

	/// en: 'Remote Patient Monitoring'
	String get remote_patient_monitoring => 'Remote Patient Monitoring';

	/// en: '2nd Opinion for Medical Image'
	String get second_opinion => '2nd Opinion for Medical Image';

	/// en: 'Sleep & Mental Health'
	String get sleep_and_mental_health => 'Sleep & Mental Health';
}

// Path: global.dialog
class TranslationsGlobalDialogEn {
	TranslationsGlobalDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Coming Soon'
	String get coming_soon => 'Coming Soon';

	/// en: 'This feature will be available soon!'
	String get feature_available_soon => 'This feature will be available soon!';
}

// Path: global.messages
class TranslationsGlobalMessagesEn {
	TranslationsGlobalMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Deleted successfully'
	String get delete_success => 'Deleted successfully';

	/// en: 'Updated successfully'
	String get updated_success => 'Updated successfully';
}

// Path: nursing.services
class TranslationsNursingServicesEn {
	TranslationsNursingServicesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsNursingServicesPrimaryNursingEn primary_nursing = TranslationsNursingServicesPrimaryNursingEn._(_root);
	late final TranslationsNursingServicesSpecializedNursingEn specialized_nursing = TranslationsNursingServicesSpecializedNursingEn._(_root);
}

// Path: pharmacy.services
class TranslationsPharmacyServicesEn {
	TranslationsPharmacyServicesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPharmacyServicesHealthCoachingEn health_coaching = TranslationsPharmacyServicesHealthCoachingEn._(_root);
	late final TranslationsPharmacyServicesMedicationCounselingEn medication_counseling = TranslationsPharmacyServicesMedicationCounselingEn._(_root);
	late final TranslationsPharmacyServicesSmokingCessationEn smoking_cessation = TranslationsPharmacyServicesSmokingCessationEn._(_root);
	late final TranslationsPharmacyServicesTherapyReviewEn therapy_review = TranslationsPharmacyServicesTherapyReviewEn._(_root);
}

// Path: auth.forgot_password.form
class TranslationsAuthForgotPasswordFormEn {
	TranslationsAuthForgotPasswordFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthForgotPasswordFormLabelEn label = TranslationsAuthForgotPasswordFormLabelEn._(_root);
}

// Path: auth.forgot_password.message
class TranslationsAuthForgotPasswordMessageEn {
	TranslationsAuthForgotPasswordMessageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OTP sent successfully'
	String get otp_sent => 'OTP sent successfully';
}

// Path: auth.form.label
class TranslationsAuthFormLabelEn {
	TranslationsAuthFormLabelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'New Password'
	String get new_password => 'New Password';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm Password'
	String get password_confirm => 'Confirm Password';

	/// en: 'Select User Type'
	String get user_role => 'Select User Type';

	/// en: 'Username'
	String get username => 'Username';
}

// Path: auth.form.validation
class TranslationsAuthFormValidationEn {
	TranslationsAuthFormValidationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter your email'
	String get email_required => 'Please enter your email';

	/// en: 'Please enter a valid email'
	String get invalid_email => 'Please enter a valid email';

	/// en: 'Password must be at least 6 characters'
	String get invalid_password_length => 'Password must be at least 6 characters';

	/// en: 'Please confirm your password'
	String get password_confirm_required => 'Please confirm your password';

	/// en: 'Passwords do not match'
	String get password_mismatch => 'Passwords do not match';

	/// en: 'Please enter a password'
	String get password_required => 'Please enter a password';

	/// en: 'Please select a user type'
	String get user_role_required => 'Please select a user type';

	/// en: 'Please enter a username'
	String get username_required => 'Please enter a username';
}

// Path: auth.login.button
class TranslationsAuthLoginButtonEn {
	TranslationsAuthLoginButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create new account'
	String get create_account_link => 'Create new account';

	/// en: 'Forgot Password?'
	String get forgot_password_link => 'Forgot Password?';

	/// en: 'Sign In'
	String get submit => 'Sign In';
}

// Path: auth.login.form
class TranslationsAuthLoginFormEn {
	TranslationsAuthLoginFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthLoginFormValidationEn validation = TranslationsAuthLoginFormValidationEn._(_root);
}

// Path: auth.login.role_selection_dialog
class TranslationsAuthLoginRoleSelectionDialogEn {
	TranslationsAuthLoginRoleSelectionDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome! Please select your account type to continue.'
	String get body => 'Welcome!\nPlease select your account type to continue.';

	/// en: 'Complete Registration'
	String get title => 'Complete Registration';
}

// Path: auth.otp_verification.button
class TranslationsAuthOtpVerificationButtonEn {
	TranslationsAuthOtpVerificationButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Didn't receive the code? Resend'
	String get resend_code => 'Didn\'t receive the code? Resend';

	/// en: 'Verify'
	String get submit => 'Verify';
}

// Path: auth.otp_verification.message
class TranslationsAuthOtpVerificationMessageEn {
	TranslationsAuthOtpVerificationMessageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Code resent!'
	String get code_resent => 'Code resent!';
}

// Path: auth.register.button
class TranslationsAuthRegisterButtonEn {
	TranslationsAuthRegisterButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Already have an account'
	String get login_link => 'Already have an account';

	/// en: 'Sign Up'
	String get submit => 'Sign Up';
}

// Path: auth.register.registration_success_dialog
class TranslationsAuthRegisterRegistrationSuccessDialogEn {
	TranslationsAuthRegisterRegistrationSuccessDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please check your email for verification.'
	String get body => 'Please check your email for verification.';

	/// en: 'Registration Successful'
	String get title => 'Registration Successful';
}

// Path: auth.reset_password.button
class TranslationsAuthResetPasswordButtonEn {
	TranslationsAuthResetPasswordButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reset Password'
	String get submit => 'Reset Password';
}

// Path: auth.reset_password_success.button
class TranslationsAuthResetPasswordSuccessButtonEn {
	TranslationsAuthResetPasswordSuccessButtonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Back to Login'
	String get login_page_link => 'Back to Login';
}

// Path: booking.addon.title
class TranslationsBookingAddonTitleEn {
	TranslationsBookingAddonTitleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add On Services'
	String get kDefault => 'Add On Services';

	/// en: 'Nursing Procedures'
	String get nursing => 'Nursing Procedures';

	/// en: 'Pharmacy Services'
	String get pharmacy => 'Pharmacy Services';

	/// en: 'Radiology Services'
	String get radiology => 'Radiology Services';

	/// en: 'Specialized Nursing Procedures'
	String get specialized_nursing => 'Specialized Nursing Procedures';
}

// Path: booking.issue.delete_dialog
class TranslationsBookingIssueDeleteDialogEn {
	TranslationsBookingIssueDeleteDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Are you sure you want to delete this issue?'
	String get content => 'Are you sure you want to delete this issue?';

	/// en: 'Delete Issue'
	String get title => 'Delete Issue';
}

// Path: booking.issue.form
class TranslationsBookingIssueFormEn {
	TranslationsBookingIssueFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add'
	String get add_button => 'Add';

	/// en: 'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.'
	String get complaint_description_hint => 'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.';

	/// en: 'Chief complaint'
	String get complaint_label => 'Chief complaint';

	/// en: '[main symptom] in the [specific body part]'
	String get complaint_title_hint => '[main symptom] in the [specific body part]';

	/// en: 'Issue title and description are required.'
	String get title_description_required => 'Issue title and description are required.';
}

// Path: booking.issue.messages
class TranslationsBookingIssueMessagesEn {
	TranslationsBookingIssueMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Issue added successfully'
	String get add_issue_success => 'Issue added successfully';

	/// en: 'Issue updated successfully'
	String get edit_issue_success => 'Issue updated successfully';
}

// Path: booking.professional_detail.title
class TranslationsBookingProfessionalDetailTitleEn {
	TranslationsBookingProfessionalDetailTitleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Professional Details'
	String get kDefault => 'Professional Details';

	/// en: 'Nurse Details'
	String get nurse => 'Nurse Details';

	/// en: 'Pharmacist Details'
	String get pharmacist => 'Pharmacist Details';

	/// en: 'Radiologist Details'
	String get radiologist => 'Radiologist Details';
}

// Path: booking.professional_search.title
class TranslationsBookingProfessionalSearchTitleEn {
	TranslationsBookingProfessionalSearchTitleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search Caregiver/Helper/Worker'
	String get caregiver => 'Search Caregiver/Helper/Worker';

	/// en: 'Search Professional'
	String get kDefault => 'Search Professional';

	/// en: 'Search Nurse'
	String get nurse => 'Search Nurse';

	/// en: 'Search Pharmacist'
	String get pharmacist => 'Search Pharmacist';

	/// en: 'Search Radiologist'
	String get radiologist => 'Search Radiologist';
}

// Path: booking.schedule.messages
class TranslationsBookingScheduleMessagesEn {
	TranslationsBookingScheduleMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rescheduling failed.'
	String get reschedule_failed => 'Rescheduling failed.';

	/// en: 'Appointment rescheduled successfully'
	String get reschedule_success => 'Appointment rescheduled successfully';
}

// Path: nursing.services.primary_nursing
class TranslationsNursingServicesPrimaryNursingEn {
	TranslationsNursingServicesPrimaryNursingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Monitor and administer nursing procedures from body checking, medication, tube feed and suctioning to injections and wound care.'
	String get description => 'Monitor and administer nursing procedures from body checking, medication, tube feed and suctioning to injections and wound care.';

	/// en: 'Primary Nursing'
	String get title => 'Primary Nursing';
}

// Path: nursing.services.specialized_nursing
class TranslationsNursingServicesSpecializedNursingEn {
	TranslationsNursingServicesSpecializedNursingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Focus on recovery and leave the complex nursing care in the hands of our experienced nurse Care Pros'
	String get description => 'Focus on recovery and leave the complex nursing care in the hands of our experienced nurse Care Pros';

	/// en: 'Specialized Nursing Services'
	String get title => 'Specialized Nursing Services';
}

// Path: pharmacy.services.health_coaching
class TranslationsPharmacyServicesHealthCoachingEn {
	TranslationsPharmacyServicesHealthCoachingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Personalized guidance and support to help individuals achieve their health goals, manage chronic conditions, and improve overall well-being, with specialized programs for weight management, diabetes management, high blood pressure management, and high cholesterol management.'
	String get description => 'Personalized guidance and support to help individuals achieve their health goals, manage chronic conditions, and improve overall well-being, with specialized programs for weight management, diabetes management, high blood pressure management, and high cholesterol management.';

	/// en: 'Health Coaching'
	String get title => 'Health Coaching';
}

// Path: pharmacy.services.medication_counseling
class TranslationsPharmacyServicesMedicationCounselingEn {
	TranslationsPharmacyServicesMedicationCounselingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Medication counseling and education guide patients on proper use, side effects, and adherence to prescriptions, enhancing safety and improving health outcomes.'
	String get description => 'Medication counseling and education guide patients on proper use, side effects, and adherence to prescriptions, enhancing safety and improving health outcomes.';

	/// en: 'Medication Counseling and Education'
	String get title => 'Medication Counseling\nand Education';
}

// Path: pharmacy.services.smoking_cessation
class TranslationsPharmacyServicesSmokingCessationEn {
	TranslationsPharmacyServicesSmokingCessationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Smoking cessation involves quitting smoking through strategies like counseling, medications, and support programs to improve health and reduce the risk of smoking-related diseases.'
	String get description => 'Smoking cessation involves quitting smoking through strategies like counseling, medications, and support programs to improve health and reduce the risk of smoking-related diseases.';

	/// en: 'Smoking Cessation'
	String get title => 'Smoking Cessation';
}

// Path: pharmacy.services.therapy_review
class TranslationsPharmacyServicesTherapyReviewEn {
	TranslationsPharmacyServicesTherapyReviewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Comprehensive review of your medication and lifestyle to optimize treatment outcomes and minimize potential side effects.'
	String get description => 'Comprehensive review of your medication and lifestyle to optimize treatment outcomes and minimize potential side effects.';

	/// en: 'Comprehensive Therapy Review'
	String get title => 'Comprehensive Therapy Review';
}

// Path: auth.forgot_password.form.label
class TranslationsAuthForgotPasswordFormLabelEn {
	TranslationsAuthForgotPasswordFormLabelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter your email'
	String get email => 'Enter your email';
}

// Path: auth.login.form.validation
class TranslationsAuthLoginFormValidationEn {
	TranslationsAuthLoginFormValidationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please fill in both Email and Password.'
	String get email_password_required => 'Please fill in both Email and Password.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.button.logout' => 'Logout',
			'auth.continue_with_alternative_text' => 'Or continue with',
			'auth.forgot_password.form.label.email' => 'Enter your email',
			'auth.forgot_password.message.otp_sent' => 'OTP sent successfully',
			'auth.forgot_password.send_code_button' => 'Send Code',
			'auth.forgot_password.subtitle' => 'Don\'t worry! Please enter the email address linked with your account.',
			'auth.forgot_password.title' => 'Forgot Password?',
			'auth.form.label.email' => 'Email',
			'auth.form.label.new_password' => 'New Password',
			'auth.form.label.password' => 'Password',
			'auth.form.label.password_confirm' => 'Confirm Password',
			'auth.form.label.user_role' => 'Select User Type',
			'auth.form.label.username' => 'Username',
			'auth.form.validation.email_required' => 'Please enter your email',
			'auth.form.validation.invalid_email' => 'Please enter a valid email',
			'auth.form.validation.invalid_password_length' => 'Password must be at least 6 characters',
			'auth.form.validation.password_confirm_required' => 'Please confirm your password',
			'auth.form.validation.password_mismatch' => 'Passwords do not match',
			'auth.form.validation.password_required' => 'Please enter a password',
			'auth.form.validation.user_role_required' => 'Please select a user type',
			'auth.form.validation.username_required' => 'Please enter a username',
			'auth.login.button.create_account_link' => 'Create new account',
			'auth.login.button.forgot_password_link' => 'Forgot Password?',
			'auth.login.button.submit' => 'Sign In',
			'auth.login.form.validation.email_password_required' => 'Please fill in both Email and Password.',
			'auth.login.role_selection_dialog.body' => 'Welcome!\nPlease select your account type to continue.',
			'auth.login.role_selection_dialog.title' => 'Complete Registration',
			'auth.login.subtitle' => 'Welcome Back you\'ve\nbeen missed',
			'auth.login.title' => 'Login Here',
			'auth.otp_verification.button.resend_code' => 'Didn\'t receive the code? Resend',
			'auth.otp_verification.button.submit' => 'Verify',
			'auth.otp_verification.message.code_resent' => 'Code resent!',
			'auth.otp_verification.resend_time_countdown' => ({required Object seconds}) => 'Resend in ${seconds} seconds',
			'auth.otp_verification.subtitle' => ({required Object email}) => 'Enter the code that we have sent to your email ${email}',
			'auth.otp_verification.title' => 'Enter Verification Code',
			'auth.register.button.login_link' => 'Already have an account',
			'auth.register.button.submit' => 'Sign Up',
			'auth.register.registration_success_dialog.body' => 'Please check your email for verification.',
			'auth.register.registration_success_dialog.title' => 'Registration Successful',
			'auth.register.subtitle' => 'Create an account so you can explore all the\nexisting jobs',
			'auth.register.title' => 'Create Account',
			'auth.reset_password.button.submit' => 'Reset Password',
			'auth.reset_password.subtitle' => 'Please enter your new password',
			'auth.reset_password.title' => 'Reset Password',
			'auth.reset_password_success.body' => 'You have successfully reset your password. Please use your new password when logging in.',
			'auth.reset_password_success.button.login_page_link' => 'Back to Login',
			'auth.reset_password_success.title' => 'Password Reset Successful!',
			'auth.user_role.caregiver' => 'Caregiver/Helper',
			'auth.user_role.nurse' => 'Nurse',
			'auth.user_role.patient' => 'Patient',
			'auth.user_role.pharmacist' => 'Pharmacist',
			'auth.user_role.physiotherapist' => 'Physiotherapist',
			'auth.user_role.radiologist' => 'Radiologist',
			'booking.addon.empty' => 'No add-on services available.',
			'booking.addon.estimated_budget' => 'Estimated Budget',
			'booking.addon.title.kDefault' => 'Add On Services',
			'booking.addon.title.nursing' => 'Nursing Procedures',
			'booking.addon.title.pharmacy' => 'Pharmacy Services',
			'booking.addon.title.radiology' => 'Radiology Services',
			'booking.addon.title.specialized_nursing' => 'Specialized Nursing Procedures',
			'booking.book_appointment' => 'Book Appointment',
			'booking.health_status.empty_record' => 'No medical records available.',
			'booking.health_status.mobility_label' => 'Select your mobility status',
			'booking.health_status.record_hint' => 'Please select a record',
			'booking.health_status.record_label' => 'Select a related health record',
			'booking.health_status.title' => 'Personal Case Detail',
			'booking.issue.add_issue_button' => 'Add an Issue',
			'booking.issue.add_issue_title' => 'Add an Issue',
			'booking.issue.default_page_title' => 'Service Case',
			'booking.issue.delete_dialog.content' => 'Are you sure you want to delete this issue?',
			'booking.issue.delete_dialog.title' => 'Delete Issue',
			'booking.issue.edit_issue_title' => 'Edit Issue',
			'booking.issue.empty_issue' => 'There are no issues added yet.\n Please add one or more issues so\nyou can proceed to the next step.',
			'booking.issue.fill_complaint_instruction' => 'Tell us your concerns',
			'booking.issue.form.add_button' => 'Add',
			'booking.issue.form.complaint_description_hint' => 'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.',
			'booking.issue.form.complaint_label' => 'Chief complaint',
			'booking.issue.form.complaint_title_hint' => '[main symptom] in the [specific body part]',
			'booking.issue.form.title_description_required' => 'Issue title and description are required.',
			'booking.issue.images' => 'Images',
			'booking.issue.messages.add_issue_success' => 'Issue added successfully',
			'booking.issue.messages.edit_issue_success' => 'Issue updated successfully',
			'booking.issue.nurse_page_title' => 'Nurse Services Case',
			'booking.issue.pharmacy_page_title' => 'Pharmacist Services Case',
			'booking.issue.radiology_page_title' => 'Radiologist Services Case',
			'booking.issue.updated_on' => ({required Object date}) => 'Updated on: ${date}',
			'booking.professional_detail.about_me' => 'About Me',
			'booking.professional_detail.certificates' => 'Professional Certificate',
			'booking.professional_detail.experience_label' => 'Experience',
			'booking.professional_detail.id_number' => ({required Object number}) => 'ID Number: ${number}',
			'booking.professional_detail.issued_on' => ({required Object date}) => 'Issued: ${date}',
			'booking.professional_detail.no_certificate' => 'No certificate available.',
			'booking.professional_detail.no_reviews' => 'No reviews available yet.',
			'booking.professional_detail.patients_label' => 'Patients',
			'booking.professional_detail.rating_label' => 'Rating',
			'booking.professional_detail.reviews' => 'Reviews',
			'booking.professional_detail.schedule_button' => 'Schedule Appointment',
			'booking.professional_detail.see_all_button' => 'See All',
			'booking.professional_detail.title.kDefault' => 'Professional Details',
			'booking.professional_detail.title.nurse' => 'Nurse Details',
			'booking.professional_detail.title.pharmacist' => 'Pharmacist Details',
			'booking.professional_detail.title.radiologist' => 'Radiologist Details',
			'booking.professional_detail.working_info' => 'Working Information',
			'booking.professional_search.appointment_button' => 'Appointment',
			'booking.professional_search.empty' => 'No professionals found matching your criteria.',
			'booking.professional_search.filter_text' => ({required Object count}) => 'Filtering by ${count} selected services',
			'booking.professional_search.title.caregiver' => 'Search Caregiver/Helper/Worker',
			'booking.professional_search.title.kDefault' => 'Search Professional',
			'booking.professional_search.title.nurse' => 'Search Nurse',
			'booking.professional_search.title.pharmacist' => 'Search Pharmacist',
			'booking.professional_search.title.radiologist' => 'Search Radiologist',
			'booking.schedule.empty_slots' => 'No available slots for this day.',
			'booking.schedule.messages.reschedule_failed' => 'Rescheduling failed.',
			'booking.schedule.messages.reschedule_success' => 'Appointment rescheduled successfully',
			'booking.schedule.select_date' => 'Select Date',
			'booking.schedule.select_hour' => 'Select Hour',
			'booking.schedule.submit_button' => 'Submit',
			'booking.schedule.submitting_button' => 'Submitting...',
			'booking.schedule.title' => 'Select Schedule',
			'dashboard.allied_services' => 'Allied Health',
			'dashboard.chat_ai_placeholder' => 'Chat With AI doctor for all your health questions',
			'dashboard.greeting' => ({required Object displayName}) => 'Live Longer & Live Healthier, ${displayName}!',
			'dashboard.services.diabetic_care' => 'Diabetic Care',
			'dashboard.services.dietitian' => 'Dietitian Service',
			'dashboard.services.health_risk_assessment' => 'Health Risk Assessment',
			'dashboard.services.home_screening' => 'Home Health Screening',
			'dashboard.services.homecare_for_elderly' => 'Home Care for Elderly',
			'dashboard.services.nursing' => 'Home Nursing',
			'dashboard.services.pharmacist' => 'iRX Pharmacist Service',
			'dashboard.services.physiotherapy' => 'Physiotherapy',
			'dashboard.services.precision_nutrition' => 'Precision Nutrition',
			'dashboard.services.remote_patient_monitoring' => 'Remote Patient Monitoring',
			'dashboard.services.second_opinion' => '2nd Opinion for Medical Image',
			'dashboard.services.sleep_and_mental_health' => 'Sleep & Mental Health',
			'global.add' => 'Add',
			'global.book_now' => 'Book Now',
			'global.cancel' => 'Cancel',
			'global.complete' => 'Complete',
			'global.confirm' => 'Confirm',
			'global.delete' => 'Delete',
			'global.description' => 'Description',
			'global.dialog.coming_soon' => 'Coming Soon',
			'global.dialog.feature_available_soon' => 'This feature will be available soon!',
			'global.edit_information' => 'Edit Information',
			'global.error' => 'Error',
			'global.error_message' => ({required Object error}) => 'Error: ${error}',
			'global.messages.delete_success' => 'Deleted successfully',
			'global.messages.updated_success' => 'Updated successfully',
			'global.modify' => 'Modify',
			'global.next' => 'Next',
			'global.no' => 'No',
			'global.no_data' => 'No data available',
			'global.none' => 'None',
			'global.not_specified' => 'Not specified',
			'global.ok' => 'OK',
			'global.other' => 'Other',
			'global.ready' => 'Ready',
			'global.remove' => 'Remove',
			'global.retry' => 'Retry',
			'global.save' => 'Save',
			'global.saving' => 'Saving...',
			'global.services' => 'Services',
			'global.status' => 'Status',
			'global.submit' => 'Submit',
			'global.unknown_location' => 'Unknown Location',
			'global.update' => 'Update',
			'global.yes' => 'Yes',
			'nursing.services.primary_nursing.description' => 'Monitor and administer nursing procedures from body checking, medication, tube feed and suctioning to injections and wound care.',
			'nursing.services.primary_nursing.title' => 'Primary Nursing',
			'nursing.services.specialized_nursing.description' => 'Focus on recovery and leave the complex nursing care in the hands of our experienced nurse Care Pros',
			'nursing.services.specialized_nursing.title' => 'Specialized Nursing Services',
			'nursing.title' => 'Home Nursing',
			'pharmacy.services.health_coaching.description' => 'Personalized guidance and support to help individuals achieve their health goals, manage chronic conditions, and improve overall well-being, with specialized programs for weight management, diabetes management, high blood pressure management, and high cholesterol management.',
			'pharmacy.services.health_coaching.title' => 'Health Coaching',
			'pharmacy.services.medication_counseling.description' => 'Medication counseling and education guide patients on proper use, side effects, and adherence to prescriptions, enhancing safety and improving health outcomes.',
			'pharmacy.services.medication_counseling.title' => 'Medication Counseling\nand Education',
			'pharmacy.services.smoking_cessation.description' => 'Smoking cessation involves quitting smoking through strategies like counseling, medications, and support programs to improve health and reduce the risk of smoking-related diseases.',
			'pharmacy.services.smoking_cessation.title' => 'Smoking Cessation',
			'pharmacy.services.therapy_review.description' => 'Comprehensive review of your medication and lifestyle to optimize treatment outcomes and minimize potential side effects.',
			'pharmacy.services.therapy_review.title' => 'Comprehensive Therapy Review',
			'pharmacy.title' => 'iRX Pharmacist Service',
			_ => null,
		};
	}
}
