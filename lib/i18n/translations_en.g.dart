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
	late final TranslationsDashboardEn dashboard = TranslationsDashboardEn._(_root);
	late final TranslationsGlobalEn global = TranslationsGlobalEn._(_root);
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

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	late final TranslationsGlobalDialogEn dialog = TranslationsGlobalDialogEn._(_root);

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Services'
	String get services => 'Services';

	/// en: 'Submit'
	String get submit => 'Submit';
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
			'global.cancel' => 'Cancel',
			'global.dialog.coming_soon' => 'Coming Soon',
			'global.dialog.feature_available_soon' => 'This feature will be available soon!',
			'global.error' => 'Error',
			'global.ok' => 'OK',
			'global.services' => 'Services',
			'global.submit' => 'Submit',
			_ => null,
		};
	}
}
