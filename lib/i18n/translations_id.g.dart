///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsId with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.id,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <id>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsId _root = this; // ignore: unused_field

	@override 
	TranslationsId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsId(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAuthId auth = _TranslationsAuthId._(_root);
	@override late final _TranslationsDashboardId dashboard = _TranslationsDashboardId._(_root);
	@override late final _TranslationsGlobalId global = _TranslationsGlobalId._(_root);
}

// Path: auth
class _TranslationsAuthId implements TranslationsAuthEn {
	_TranslationsAuthId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthButtonId button = _TranslationsAuthButtonId._(_root);
	@override String get continue_with_alternative_text => 'atau lanjutkan dengan';
	@override late final _TranslationsAuthForgotPasswordId forgot_password = _TranslationsAuthForgotPasswordId._(_root);
	@override late final _TranslationsAuthFormId form = _TranslationsAuthFormId._(_root);
	@override late final _TranslationsAuthLoginId login = _TranslationsAuthLoginId._(_root);
	@override late final _TranslationsAuthOtpVerificationId otp_verification = _TranslationsAuthOtpVerificationId._(_root);
	@override late final _TranslationsAuthRegisterId register = _TranslationsAuthRegisterId._(_root);
	@override late final _TranslationsAuthResetPasswordId reset_password = _TranslationsAuthResetPasswordId._(_root);
	@override late final _TranslationsAuthResetPasswordSuccessId reset_password_success = _TranslationsAuthResetPasswordSuccessId._(_root);
	@override late final _TranslationsAuthUserRoleId user_role = _TranslationsAuthUserRoleId._(_root);
}

// Path: dashboard
class _TranslationsDashboardId implements TranslationsDashboardEn {
	_TranslationsDashboardId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get allied_services => 'Layanan Kesehatan Penunjang';
	@override String get chat_ai_placeholder => 'Tanya dokter AI seputar kesehatan Anda';
	@override String greeting({required Object displayName}) => 'Hidup Lebih Lama & Sehat, ${displayName}!';
	@override late final _TranslationsDashboardServicesId services = _TranslationsDashboardServicesId._(_root);
}

// Path: global
class _TranslationsGlobalId implements TranslationsGlobalEn {
	_TranslationsGlobalId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Batal';
	@override late final _TranslationsGlobalDialogId dialog = _TranslationsGlobalDialogId._(_root);
	@override String get error => 'Error';
	@override String get ok => 'OK';
	@override String get services => 'Layanan';
	@override String get submit => 'Kirim';
}

// Path: auth.button
class _TranslationsAuthButtonId implements TranslationsAuthButtonEn {
	_TranslationsAuthButtonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get logout => 'Keluar';
}

// Path: auth.forgot_password
class _TranslationsAuthForgotPasswordId implements TranslationsAuthForgotPasswordEn {
	_TranslationsAuthForgotPasswordId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthForgotPasswordFormId form = _TranslationsAuthForgotPasswordFormId._(_root);
	@override late final _TranslationsAuthForgotPasswordMessageId message = _TranslationsAuthForgotPasswordMessageId._(_root);
	@override String get send_code_button => 'Kirim Kode';
	@override String get subtitle => 'Jangan khawatir! Silakan masukkan alamat email yang terhubung dengan akun Anda.';
	@override String get title => 'Lupa Kata Sandi?';
}

// Path: auth.form
class _TranslationsAuthFormId implements TranslationsAuthFormEn {
	_TranslationsAuthFormId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthFormLabelId label = _TranslationsAuthFormLabelId._(_root);
	@override late final _TranslationsAuthFormValidationId validation = _TranslationsAuthFormValidationId._(_root);
}

// Path: auth.login
class _TranslationsAuthLoginId implements TranslationsAuthLoginEn {
	_TranslationsAuthLoginId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthLoginButtonId button = _TranslationsAuthLoginButtonId._(_root);
	@override late final _TranslationsAuthLoginFormId form = _TranslationsAuthLoginFormId._(_root);
	@override late final _TranslationsAuthLoginRoleSelectionDialogId role_selection_dialog = _TranslationsAuthLoginRoleSelectionDialogId._(_root);
	@override String get subtitle => 'Selamat Datang Kembali!';
	@override String get title => 'Login';
}

// Path: auth.otp_verification
class _TranslationsAuthOtpVerificationId implements TranslationsAuthOtpVerificationEn {
	_TranslationsAuthOtpVerificationId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthOtpVerificationButtonId button = _TranslationsAuthOtpVerificationButtonId._(_root);
	@override late final _TranslationsAuthOtpVerificationMessageId message = _TranslationsAuthOtpVerificationMessageId._(_root);
	@override String resend_time_countdown({required Object seconds}) => 'Kirim ulang dalam ${seconds} detik';
	@override String subtitle({required Object email}) => 'Masukkan kode yang telah kami kirim ke email Anda ${email}';
	@override String get title => 'Masukkan Kode Verifikasi';
}

// Path: auth.register
class _TranslationsAuthRegisterId implements TranslationsAuthRegisterEn {
	_TranslationsAuthRegisterId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthRegisterButtonId button = _TranslationsAuthRegisterButtonId._(_root);
	@override late final _TranslationsAuthRegisterRegistrationSuccessDialogId registration_success_dialog = _TranslationsAuthRegisterRegistrationSuccessDialogId._(_root);
	@override String get subtitle => 'Buat akun agar Anda dapat menjelajahi semua\npekerjaan yang ada';
	@override String get title => 'Buat Akun';
}

// Path: auth.reset_password
class _TranslationsAuthResetPasswordId implements TranslationsAuthResetPasswordEn {
	_TranslationsAuthResetPasswordId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthResetPasswordButtonId button = _TranslationsAuthResetPasswordButtonId._(_root);
	@override String get subtitle => 'Silakan masukkan kata sandi baru Anda';
	@override String get title => 'Atur Ulang Kata Sandi';
}

// Path: auth.reset_password_success
class _TranslationsAuthResetPasswordSuccessId implements TranslationsAuthResetPasswordSuccessEn {
	_TranslationsAuthResetPasswordSuccessId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get body => 'Anda telah berhasil mengatur ulang kata sandi Anda. Silakan gunakan kata sandi baru Anda saat masuk.';
	@override late final _TranslationsAuthResetPasswordSuccessButtonId button = _TranslationsAuthResetPasswordSuccessButtonId._(_root);
	@override String get title => 'Atur Ulang Kata Sandi Berhasil!';
}

// Path: auth.user_role
class _TranslationsAuthUserRoleId implements TranslationsAuthUserRoleEn {
	_TranslationsAuthUserRoleId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get caregiver => 'Pengasuh/Pendamping';
	@override String get nurse => 'Perawat';
	@override String get patient => 'Pasien';
	@override String get pharmacist => 'Apoteker';
	@override String get physiotherapist => 'Fisioterapis';
	@override String get radiologist => 'Radiolog';
}

// Path: dashboard.services
class _TranslationsDashboardServicesId implements TranslationsDashboardServicesEn {
	_TranslationsDashboardServicesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get diabetic_care => 'Perawatan Diabetes';
	@override String get dietitian => 'Layanan Ahli Gizi';
	@override String get health_risk_assessment => 'Penilaian Risiko Kesehatan';
	@override String get home_screening => 'Skrining Kesehatan di Rumah';
	@override String get homecare_for_elderly => 'Perawatan Lansia di Rumah';
	@override String get nursing => 'Layanan Keperawatan di Rumah';
	@override String get pharmacist => 'Layanan Apoteker iRX';
	@override String get physiotherapy => 'Fisioterapi';
	@override String get precision_nutrition => 'Nutrisi Presisi';
	@override String get remote_patient_monitoring => 'Pemantauan Kesehatan Jarak Jauh';
	@override String get second_opinion => 'Second Opinion Citra Medis';
	@override String get sleep_and_mental_health => 'Tidur & Kesehatan Mental';
}

// Path: global.dialog
class _TranslationsGlobalDialogId implements TranslationsGlobalDialogEn {
	_TranslationsGlobalDialogId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get coming_soon => 'Segera Hadir';
	@override String get feature_available_soon => 'Fitur ini akan segera tersedia!';
}

// Path: auth.forgot_password.form
class _TranslationsAuthForgotPasswordFormId implements TranslationsAuthForgotPasswordFormEn {
	_TranslationsAuthForgotPasswordFormId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthForgotPasswordFormLabelId label = _TranslationsAuthForgotPasswordFormLabelId._(_root);
}

// Path: auth.forgot_password.message
class _TranslationsAuthForgotPasswordMessageId implements TranslationsAuthForgotPasswordMessageEn {
	_TranslationsAuthForgotPasswordMessageId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get otp_sent => 'OTP berhasil dikirim';
}

// Path: auth.form.label
class _TranslationsAuthFormLabelId implements TranslationsAuthFormLabelEn {
	_TranslationsAuthFormLabelId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get email => 'Email';
	@override String get new_password => 'Kata Sandi Baru';
	@override String get password => 'Kata Sandi';
	@override String get password_confirm => 'Konfirmasi Kata Sandi';
	@override String get user_role => 'Pilih Tipe Pengguna';
	@override String get username => 'Nama Pengguna';
}

// Path: auth.form.validation
class _TranslationsAuthFormValidationId implements TranslationsAuthFormValidationEn {
	_TranslationsAuthFormValidationId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get email_required => 'Harap masukkan email Anda';
	@override String get invalid_email => 'Harap masukkan email yang valid';
	@override String get invalid_password_length => 'Kata sandi harus minimal 6 karakter';
	@override String get password_confirm_required => 'Harap konfirmasi kata sandi Anda';
	@override String get password_mismatch => 'Kata sandi tidak cocok';
	@override String get password_required => 'Harap masukkan kata sandi';
	@override String get user_role_required => 'Harap pilih tipe pengguna';
	@override String get username_required => 'Harap masukkan nama pengguna';
}

// Path: auth.login.button
class _TranslationsAuthLoginButtonId implements TranslationsAuthLoginButtonEn {
	_TranslationsAuthLoginButtonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get create_account_link => 'Buat akun baru';
	@override String get forgot_password_link => 'Lupa Kata Sandi?';
	@override String get submit => 'Masuk';
}

// Path: auth.login.form
class _TranslationsAuthLoginFormId implements TranslationsAuthLoginFormEn {
	_TranslationsAuthLoginFormId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthLoginFormValidationId validation = _TranslationsAuthLoginFormValidationId._(_root);
}

// Path: auth.login.role_selection_dialog
class _TranslationsAuthLoginRoleSelectionDialogId implements TranslationsAuthLoginRoleSelectionDialogEn {
	_TranslationsAuthLoginRoleSelectionDialogId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get body => 'Selamat Datang!\nSilakan pilih tipe akun Anda untuk melanjutkan.';
	@override String get title => 'Selesaikan Pendaftaran';
}

// Path: auth.otp_verification.button
class _TranslationsAuthOtpVerificationButtonId implements TranslationsAuthOtpVerificationButtonEn {
	_TranslationsAuthOtpVerificationButtonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get resend_code => 'Tidak menerima kode? Kirim Ulang';
	@override String get submit => 'Verifikasi';
}

// Path: auth.otp_verification.message
class _TranslationsAuthOtpVerificationMessageId implements TranslationsAuthOtpVerificationMessageEn {
	_TranslationsAuthOtpVerificationMessageId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get code_resent => 'Kode dikirim ulang!';
}

// Path: auth.register.button
class _TranslationsAuthRegisterButtonId implements TranslationsAuthRegisterButtonEn {
	_TranslationsAuthRegisterButtonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get login_link => 'Sudah punya akun';
	@override String get submit => 'Daftar';
}

// Path: auth.register.registration_success_dialog
class _TranslationsAuthRegisterRegistrationSuccessDialogId implements TranslationsAuthRegisterRegistrationSuccessDialogEn {
	_TranslationsAuthRegisterRegistrationSuccessDialogId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get body => 'Silakan periksa email Anda untuk verifikasi.';
	@override String get title => 'Pendaftaran Berhasil';
}

// Path: auth.reset_password.button
class _TranslationsAuthResetPasswordButtonId implements TranslationsAuthResetPasswordButtonEn {
	_TranslationsAuthResetPasswordButtonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get submit => 'Atur Ulang Kata Sandi';
}

// Path: auth.reset_password_success.button
class _TranslationsAuthResetPasswordSuccessButtonId implements TranslationsAuthResetPasswordSuccessButtonEn {
	_TranslationsAuthResetPasswordSuccessButtonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get login_page_link => 'Kembali ke Login';
}

// Path: auth.forgot_password.form.label
class _TranslationsAuthForgotPasswordFormLabelId implements TranslationsAuthForgotPasswordFormLabelEn {
	_TranslationsAuthForgotPasswordFormLabelId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get email => 'Masukkan email Anda';
}

// Path: auth.login.form.validation
class _TranslationsAuthLoginFormValidationId implements TranslationsAuthLoginFormValidationEn {
	_TranslationsAuthLoginFormValidationId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get email_password_required => 'Harap isi Email dan Kata Sandi.';
}

/// The flat map containing all translations for locale <id>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsId {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.button.logout' => 'Keluar',
			'auth.continue_with_alternative_text' => 'atau lanjutkan dengan',
			'auth.forgot_password.form.label.email' => 'Masukkan email Anda',
			'auth.forgot_password.message.otp_sent' => 'OTP berhasil dikirim',
			'auth.forgot_password.send_code_button' => 'Kirim Kode',
			'auth.forgot_password.subtitle' => 'Jangan khawatir! Silakan masukkan alamat email yang terhubung dengan akun Anda.',
			'auth.forgot_password.title' => 'Lupa Kata Sandi?',
			'auth.form.label.email' => 'Email',
			'auth.form.label.new_password' => 'Kata Sandi Baru',
			'auth.form.label.password' => 'Kata Sandi',
			'auth.form.label.password_confirm' => 'Konfirmasi Kata Sandi',
			'auth.form.label.user_role' => 'Pilih Tipe Pengguna',
			'auth.form.label.username' => 'Nama Pengguna',
			'auth.form.validation.email_required' => 'Harap masukkan email Anda',
			'auth.form.validation.invalid_email' => 'Harap masukkan email yang valid',
			'auth.form.validation.invalid_password_length' => 'Kata sandi harus minimal 6 karakter',
			'auth.form.validation.password_confirm_required' => 'Harap konfirmasi kata sandi Anda',
			'auth.form.validation.password_mismatch' => 'Kata sandi tidak cocok',
			'auth.form.validation.password_required' => 'Harap masukkan kata sandi',
			'auth.form.validation.user_role_required' => 'Harap pilih tipe pengguna',
			'auth.form.validation.username_required' => 'Harap masukkan nama pengguna',
			'auth.login.button.create_account_link' => 'Buat akun baru',
			'auth.login.button.forgot_password_link' => 'Lupa Kata Sandi?',
			'auth.login.button.submit' => 'Masuk',
			'auth.login.form.validation.email_password_required' => 'Harap isi Email dan Kata Sandi.',
			'auth.login.role_selection_dialog.body' => 'Selamat Datang!\nSilakan pilih tipe akun Anda untuk melanjutkan.',
			'auth.login.role_selection_dialog.title' => 'Selesaikan Pendaftaran',
			'auth.login.subtitle' => 'Selamat Datang Kembali!',
			'auth.login.title' => 'Login',
			'auth.otp_verification.button.resend_code' => 'Tidak menerima kode? Kirim Ulang',
			'auth.otp_verification.button.submit' => 'Verifikasi',
			'auth.otp_verification.message.code_resent' => 'Kode dikirim ulang!',
			'auth.otp_verification.resend_time_countdown' => ({required Object seconds}) => 'Kirim ulang dalam ${seconds} detik',
			'auth.otp_verification.subtitle' => ({required Object email}) => 'Masukkan kode yang telah kami kirim ke email Anda ${email}',
			'auth.otp_verification.title' => 'Masukkan Kode Verifikasi',
			'auth.register.button.login_link' => 'Sudah punya akun',
			'auth.register.button.submit' => 'Daftar',
			'auth.register.registration_success_dialog.body' => 'Silakan periksa email Anda untuk verifikasi.',
			'auth.register.registration_success_dialog.title' => 'Pendaftaran Berhasil',
			'auth.register.subtitle' => 'Buat akun agar Anda dapat menjelajahi semua\npekerjaan yang ada',
			'auth.register.title' => 'Buat Akun',
			'auth.reset_password.button.submit' => 'Atur Ulang Kata Sandi',
			'auth.reset_password.subtitle' => 'Silakan masukkan kata sandi baru Anda',
			'auth.reset_password.title' => 'Atur Ulang Kata Sandi',
			'auth.reset_password_success.body' => 'Anda telah berhasil mengatur ulang kata sandi Anda. Silakan gunakan kata sandi baru Anda saat masuk.',
			'auth.reset_password_success.button.login_page_link' => 'Kembali ke Login',
			'auth.reset_password_success.title' => 'Atur Ulang Kata Sandi Berhasil!',
			'auth.user_role.caregiver' => 'Pengasuh/Pendamping',
			'auth.user_role.nurse' => 'Perawat',
			'auth.user_role.patient' => 'Pasien',
			'auth.user_role.pharmacist' => 'Apoteker',
			'auth.user_role.physiotherapist' => 'Fisioterapis',
			'auth.user_role.radiologist' => 'Radiolog',
			'dashboard.allied_services' => 'Layanan Kesehatan Penunjang',
			'dashboard.chat_ai_placeholder' => 'Tanya dokter AI seputar kesehatan Anda',
			'dashboard.greeting' => ({required Object displayName}) => 'Hidup Lebih Lama & Sehat, ${displayName}!',
			'dashboard.services.diabetic_care' => 'Perawatan Diabetes',
			'dashboard.services.dietitian' => 'Layanan Ahli Gizi',
			'dashboard.services.health_risk_assessment' => 'Penilaian Risiko Kesehatan',
			'dashboard.services.home_screening' => 'Skrining Kesehatan di Rumah',
			'dashboard.services.homecare_for_elderly' => 'Perawatan Lansia di Rumah',
			'dashboard.services.nursing' => 'Layanan Keperawatan di Rumah',
			'dashboard.services.pharmacist' => 'Layanan Apoteker iRX',
			'dashboard.services.physiotherapy' => 'Fisioterapi',
			'dashboard.services.precision_nutrition' => 'Nutrisi Presisi',
			'dashboard.services.remote_patient_monitoring' => 'Pemantauan Kesehatan Jarak Jauh',
			'dashboard.services.second_opinion' => 'Second Opinion Citra Medis',
			'dashboard.services.sleep_and_mental_health' => 'Tidur & Kesehatan Mental',
			'global.cancel' => 'Batal',
			'global.dialog.coming_soon' => 'Segera Hadir',
			'global.dialog.feature_available_soon' => 'Fitur ini akan segera tersedia!',
			'global.error' => 'Error',
			'global.ok' => 'OK',
			'global.services' => 'Layanan',
			'global.submit' => 'Kirim',
			_ => null,
		};
	}
}
