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
	@override late final _TranslationsBookingId booking = _TranslationsBookingId._(_root);
	@override late final _TranslationsDashboardId dashboard = _TranslationsDashboardId._(_root);
	@override late final _TranslationsGlobalId global = _TranslationsGlobalId._(_root);
	@override late final _TranslationsNursingId nursing = _TranslationsNursingId._(_root);
	@override late final _TranslationsPaymentId payment = _TranslationsPaymentId._(_root);
	@override late final _TranslationsPharmacyId pharmacy = _TranslationsPharmacyId._(_root);
	@override late final _TranslationsSettingsId settings = _TranslationsSettingsId._(_root);
	@override late final _TranslationsStoreId store = _TranslationsStoreId._(_root);
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

// Path: booking
class _TranslationsBookingId implements TranslationsBookingEn {
	_TranslationsBookingId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsBookingAddonId addon = _TranslationsBookingAddonId._(_root);
	@override String get book_appointment => 'Buat Janji Temu';
	@override late final _TranslationsBookingHealthStatusId health_status = _TranslationsBookingHealthStatusId._(_root);
	@override late final _TranslationsBookingIssueId issue = _TranslationsBookingIssueId._(_root);
	@override late final _TranslationsBookingProfessionalDetailId professional_detail = _TranslationsBookingProfessionalDetailId._(_root);
	@override late final _TranslationsBookingProfessionalSearchId professional_search = _TranslationsBookingProfessionalSearchId._(_root);
	@override late final _TranslationsBookingScheduleId schedule = _TranslationsBookingScheduleId._(_root);
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
	@override String get add => 'Tambah';
	@override String get book_now => 'Pesan Sekarang';
	@override String get cancel => 'Batal';
	@override String get complete => 'Selesai';
	@override String get confirm => 'Konfirmasi';
	@override String get delete => 'Hapus';
	@override String get description => 'Deskripsi';
	@override late final _TranslationsGlobalDialogId dialog = _TranslationsGlobalDialogId._(_root);
	@override String get edit_information => 'Ubah Informasi';
	@override String get error => 'Error';
	@override String error_message({required Object error}) => 'Error: ${error}';
	@override late final _TranslationsGlobalMessagesId messages = _TranslationsGlobalMessagesId._(_root);
	@override String get modify => 'Ubah';
	@override String get next => 'Lanjut';
	@override String get no => 'Tidak';
	@override String get no_data => 'Tidak ada data tersedia';
	@override String get none => 'Tidak Ada';
	@override String get not_specified => 'Tidak ditentukan';
	@override String get ok => 'OK';
	@override String get other => 'Lainnya';
	@override String get ready => 'Siap';
	@override String get remove => 'Hapus';
	@override String get retry => 'Coba Lagi';
	@override String get save => 'Simpan';
	@override String get saving => 'Menyimpan...';
	@override String get services => 'Layanan';
	@override String get status => 'Status';
	@override String get submit => 'Kirim';
	@override String get unknown_location => 'Lokasi Tidak Diketahui';
	@override String get update => 'Perbarui';
	@override String get yes => 'Ya';
}

// Path: nursing
class _TranslationsNursingId implements TranslationsNursingEn {
	_TranslationsNursingId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsNursingServicesId services = _TranslationsNursingServicesId._(_root);
	@override String get title => 'Layanan Keperawatan di Rumah';
}

// Path: payment
class _TranslationsPaymentId implements TranslationsPaymentEn {
	_TranslationsPaymentId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPaymentErrorId error = _TranslationsPaymentErrorId._(_root);
	@override late final _TranslationsPaymentFeedbackId feedback = _TranslationsPaymentFeedbackId._(_root);
	@override late final _TranslationsPaymentFeedbackSuccessId feedback_success = _TranslationsPaymentFeedbackSuccessId._(_root);
	@override late final _TranslationsPaymentMessagesId messages = _TranslationsPaymentMessagesId._(_root);
	@override late final _TranslationsPaymentMethodsId methods = _TranslationsPaymentMethodsId._(_root);
	@override late final _TranslationsPaymentOfflineSuccessId offline_success = _TranslationsPaymentOfflineSuccessId._(_root);
	@override String get order_summary => 'Ringkasan Pesanan';
	@override String pay_btn({required Object amount}) => 'Bayar ${amount}';
	@override String get price_label => 'Harga';
	@override String get return_home_btn => 'Kembali ke Beranda';
	@override String get select_method => 'Pilih Metode Pembayaran';
	@override String get service_charge => 'Biaya Layanan';
	@override late final _TranslationsPaymentSubscriptionSuccessId subscription_success = _TranslationsPaymentSubscriptionSuccessId._(_root);
	@override late final _TranslationsPaymentSuccessId success = _TranslationsPaymentSuccessId._(_root);
	@override String get title => 'Pembayaran';
	@override String get total_label => 'Total';
	@override String get validity_label => 'Masa Berlaku';
}

// Path: pharmacy
class _TranslationsPharmacyId implements TranslationsPharmacyEn {
	_TranslationsPharmacyId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPharmacyServicesId services = _TranslationsPharmacyServicesId._(_root);
	@override String get title => 'Layanan iRX Pharmacist';
}

// Path: settings
class _TranslationsSettingsId implements TranslationsSettingsEn {
	_TranslationsSettingsId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get account => 'Akun';
	@override String get app_language => 'Bahasa Aplikasi';
	@override String get settings => 'Pengaturan';
}

// Path: store
class _TranslationsStoreId implements TranslationsStoreEn {
	_TranslationsStoreId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get consumable => 'Barang Habis Pakai';
	@override late final _TranslationsStoreMessagesId messages = _TranslationsStoreMessagesId._(_root);
	@override String get no_products => 'Tidak ada produk tersedia';
	@override String get poct => 'Point of Care Testing';
	@override String get sort => 'Urutkan';
	@override String get title => 'Toko Medis';
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

// Path: booking.addon
class _TranslationsBookingAddonId implements TranslationsBookingAddonEn {
	_TranslationsBookingAddonId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Tidak ada layanan tambahan yang tersedia.';
	@override String get estimated_budget => 'Perkiraan Biaya';
	@override late final _TranslationsBookingAddonTitleId title = _TranslationsBookingAddonTitleId._(_root);
}

// Path: booking.health_status
class _TranslationsBookingHealthStatusId implements TranslationsBookingHealthStatusEn {
	_TranslationsBookingHealthStatusId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get empty_record => 'Tidak ada rekam medis yang tersedia.';
	@override String get mobility_detail_hint => 'contoh: tongkat jalan, alat bantu jalan, lainnya';
	@override String get mobility_label => 'Pilih status mobilitas Anda';
	@override String get record_hint => 'Silakan pilih rekam medis';
	@override String get record_label => 'Pilih rekam medis terkait';
	@override String get title => 'Detail Kasus Pribadi';
}

// Path: booking.issue
class _TranslationsBookingIssueId implements TranslationsBookingIssueEn {
	_TranslationsBookingIssueId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get add_issue_button => 'Tambah Keluhan';
	@override String get add_issue_title => 'Tambah Keluhan';
	@override String get default_page_title => 'Kasus Layanan';
	@override late final _TranslationsBookingIssueDeleteDialogId delete_dialog = _TranslationsBookingIssueDeleteDialogId._(_root);
	@override String get edit_issue_title => 'Ubah Keluhan';
	@override String get empty_issue => 'Belum ada keluhan yang ditambahkan.\n Harap tambahkan keluhan agar\nAnda dapat melanjutkan ke langkah berikutnya.';
	@override String get fill_complaint_instruction => 'Ceritakan keluhan Anda';
	@override late final _TranslationsBookingIssueFormId form = _TranslationsBookingIssueFormId._(_root);
	@override String get images => 'Gambar';
	@override late final _TranslationsBookingIssueMessagesId messages = _TranslationsBookingIssueMessagesId._(_root);
	@override String get nurse_page_title => 'Kasus Layanan Perawat';
	@override String get pharmacy_page_title => 'Kasus Layanan Apoteker';
	@override String get radiology_page_title => 'Kasus Layanan Radiolog';
	@override String updated_on({required Object date}) => 'Diperbarui pada: ${date}';
}

// Path: booking.professional_detail
class _TranslationsBookingProfessionalDetailId implements TranslationsBookingProfessionalDetailEn {
	_TranslationsBookingProfessionalDetailId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get about_me => 'Tentang Saya';
	@override String get certificates => 'Sertifikat Profesional';
	@override String get experience_label => 'Pengalaman';
	@override String id_number({required Object number}) => 'Nomor ID: ${number}';
	@override String issued_on({required Object date}) => 'Diterbitkan: ${date}';
	@override String get no_certificate => 'Sertifikat tidak tersedia.';
	@override String get no_reviews => 'Belum ada ulasan.';
	@override String get patients_label => 'Pasien';
	@override String get rating_label => 'Penilaian';
	@override String get reviews => 'Ulasan';
	@override String get schedule_button => 'Jadwalkan Janji Temu';
	@override String get see_all_button => 'Lihat Semua';
	@override late final _TranslationsBookingProfessionalDetailTitleId title = _TranslationsBookingProfessionalDetailTitleId._(_root);
	@override String get working_info => 'Informasi Kerja';
}

// Path: booking.professional_search
class _TranslationsBookingProfessionalSearchId implements TranslationsBookingProfessionalSearchEn {
	_TranslationsBookingProfessionalSearchId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get appointment_button => 'Buat Janji Temu';
	@override String get empty => 'Tidak ditemukan profesional yang cocok dengan kriteria Anda.';
	@override String filter_text({required Object count}) => 'Difilter berdasarkan ${count} layanan terpilih';
	@override late final _TranslationsBookingProfessionalSearchTitleId title = _TranslationsBookingProfessionalSearchTitleId._(_root);
}

// Path: booking.schedule
class _TranslationsBookingScheduleId implements TranslationsBookingScheduleEn {
	_TranslationsBookingScheduleId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get empty_slots => 'Tidak ada slot tersedia untuk hari ini.';
	@override late final _TranslationsBookingScheduleMessagesId messages = _TranslationsBookingScheduleMessagesId._(_root);
	@override String get select_date => 'Pilih Tanggal';
	@override String get select_hour => 'Pilih Jam';
	@override String get submit_button => 'Kirim';
	@override String get submitting_button => 'Mengirim...';
	@override String get title => 'Pilih Jadwal';
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

// Path: global.messages
class _TranslationsGlobalMessagesId implements TranslationsGlobalMessagesEn {
	_TranslationsGlobalMessagesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get delete_success => 'Berhasil dihapus';
	@override String get updated_success => 'Berhasil diperbarui';
}

// Path: nursing.services
class _TranslationsNursingServicesId implements TranslationsNursingServicesEn {
	_TranslationsNursingServicesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsNursingServicesPrimaryNursingId primary_nursing = _TranslationsNursingServicesPrimaryNursingId._(_root);
	@override late final _TranslationsNursingServicesSpecializedNursingId specialized_nursing = _TranslationsNursingServicesSpecializedNursingId._(_root);
}

// Path: payment.error
class _TranslationsPaymentErrorId implements TranslationsPaymentErrorEn {
	_TranslationsPaymentErrorId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get appointment_id_missing => 'Error: ID Janji Temu hilang.';
}

// Path: payment.feedback
class _TranslationsPaymentFeedbackId implements TranslationsPaymentFeedbackEn {
	_TranslationsPaymentFeedbackId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get enter_amount_hint => 'Masukkan jumlah';
	@override String get enter_other_amount => 'Masukkan jumlah lain';
	@override String get excellent => 'Luar Biasa';
	@override String give_tips({required Object name}) => 'Berikan tip kepada ${name}';
	@override String rated_text({required Object name, required Object stars}) => 'Anda memberi ${name} ${stars} bintang';
	@override String get submit_btn => 'Kirim Ulasan';
	@override String get write_text_hint => 'Tulis ulasan Anda di sini...';
}

// Path: payment.feedback_success
class _TranslationsPaymentFeedbackSuccessId implements TranslationsPaymentFeedbackSuccessEn {
	_TranslationsPaymentFeedbackSuccessId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get content => 'Ulasan Anda telah berhasil dikirim.';
	@override String get thank_you => 'Terima Kasih!';
	@override String get view_detail_btn => 'Lihat Detail Janji Temu';
}

// Path: payment.messages
class _TranslationsPaymentMessagesId implements TranslationsPaymentMessagesEn {
	_TranslationsPaymentMessagesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String failed({required Object error}) => 'Pembayaran Gagal: ${error}';
	@override String feedback_failed({required Object error}) => 'Gagal Mengirim Ulasan: ${error}';
	@override String purchase_failed({required Object error}) => 'Pembelian Gagal: ${error}';
}

// Path: payment.methods
class _TranslationsPaymentMethodsId implements TranslationsPaymentMethodsEn {
	_TranslationsPaymentMethodsId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get cash_offline => 'Tunai (Pembayaran Offline)';
}

// Path: payment.offline_success
class _TranslationsPaymentOfflineSuccessId implements TranslationsPaymentOfflineSuccessEn {
	_TranslationsPaymentOfflineSuccessId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get content => 'Permintaan Anda telah berhasil dikirim.\nSilakan bayar langsung ke profesional saat janji temu.';
	@override String get estimated_total => 'Perkiraan Total';
	@override String get title => 'Permintaan Dikirim';
}

// Path: payment.subscription_success
class _TranslationsPaymentSubscriptionSuccessId implements TranslationsPaymentSubscriptionSuccessEn {
	_TranslationsPaymentSubscriptionSuccessId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String content({required Object planName}) => 'Anda telah berhasil membeli ${planName}';
	@override String get title => 'Pembayaran Berhasil';
}

// Path: payment.success
class _TranslationsPaymentSuccessId implements TranslationsPaymentSuccessEn {
	_TranslationsPaymentSuccessId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get amount => 'Jumlah';
	@override String content({required Object name}) => 'Uang Anda telah berhasil dikirim ke ${name}.';
	@override String get experience_subtitle => 'Ulasan Anda akan membantu kami meningkatkan\npengalaman Anda menjadi lebih baik';
	@override String get experience_title => 'Bagaimana pengalaman Anda?';
	@override String get feedback_btn => 'Berikan Ulasan';
	@override String get title => 'Pembayaran Berhasil';
}

// Path: pharmacy.services
class _TranslationsPharmacyServicesId implements TranslationsPharmacyServicesEn {
	_TranslationsPharmacyServicesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPharmacyServicesHealthCoachingId health_coaching = _TranslationsPharmacyServicesHealthCoachingId._(_root);
	@override late final _TranslationsPharmacyServicesReviewAndCounselingId review_and_counseling = _TranslationsPharmacyServicesReviewAndCounselingId._(_root);
	@override late final _TranslationsPharmacyServicesSmokingCessationId smoking_cessation = _TranslationsPharmacyServicesSmokingCessationId._(_root);
}

// Path: store.messages
class _TranslationsStoreMessagesId implements TranslationsStoreMessagesEn {
	_TranslationsStoreMessagesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get load_failed => 'Gagal memuat produk';
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

// Path: booking.addon.title
class _TranslationsBookingAddonTitleId implements TranslationsBookingAddonTitleEn {
	_TranslationsBookingAddonTitleId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Layanan Tambahan';
	@override String get nursing => 'Prosedur Keperawatan';
	@override String get pharmacy => 'Layanan Farmasi';
	@override String get radiology => 'Layanan Radiologi';
	@override String get specialized_nursing => 'Prosedur Keperawatan Khusus';
}

// Path: booking.issue.delete_dialog
class _TranslationsBookingIssueDeleteDialogId implements TranslationsBookingIssueDeleteDialogEn {
	_TranslationsBookingIssueDeleteDialogId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get content => 'Apakah Anda yakin ingin menghapus keluhan ini?';
	@override String get title => 'Hapus Keluhan';
}

// Path: booking.issue.form
class _TranslationsBookingIssueFormId implements TranslationsBookingIssueFormEn {
	_TranslationsBookingIssueFormId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get add_button => 'Tambah';
	@override String get complaint_description_hint => 'Silakan masukkan pertanyaan, kekhawatiran, gejala relevan yang terkait dengan kasus Anda beserta kata kunci terkait.';
	@override String get complaint_label => 'Keluhan';
	@override String get complaint_title_hint => 'Beritahu kami keluhan Anda';
	@override String get title_description_required => 'Judul dan deskripsi keluhan wajib diisi.';
}

// Path: booking.issue.messages
class _TranslationsBookingIssueMessagesId implements TranslationsBookingIssueMessagesEn {
	_TranslationsBookingIssueMessagesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get add_issue_success => 'Keluhan berhasil ditambahkan';
	@override String get edit_issue_success => 'Keluhan berhasil diperbarui';
}

// Path: booking.professional_detail.title
class _TranslationsBookingProfessionalDetailTitleId implements TranslationsBookingProfessionalDetailTitleEn {
	_TranslationsBookingProfessionalDetailTitleId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get kDefault => 'Detail Profesional';
	@override String get nurse => 'Detail Perawat';
	@override String get pharmacist => 'Detail Apoteker';
	@override String get radiologist => 'Detail Radiolog';
}

// Path: booking.professional_search.title
class _TranslationsBookingProfessionalSearchTitleId implements TranslationsBookingProfessionalSearchTitleEn {
	_TranslationsBookingProfessionalSearchTitleId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get caregiver => 'Cari Pengasuh/Pendamping/Pekerja';
	@override String get kDefault => 'Cari Profesional';
	@override String get nurse => 'Cari Perawat';
	@override String get pharmacist => 'Cari Apoteker';
	@override String get radiologist => 'Cari Radiolog';
}

// Path: booking.schedule.messages
class _TranslationsBookingScheduleMessagesId implements TranslationsBookingScheduleMessagesEn {
	_TranslationsBookingScheduleMessagesId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get reschedule_failed => 'Penjadwalan ulang gagal.';
	@override String get reschedule_success => 'Janji temu berhasil dijadwalkan ulang';
}

// Path: nursing.services.primary_nursing
class _TranslationsNursingServicesPrimaryNursingId implements TranslationsNursingServicesPrimaryNursingEn {
	_TranslationsNursingServicesPrimaryNursingId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get description => 'Memantau dan melakukan prosedur keperawatan mulai dari pemeriksaan fisik, pemberian obat, tube feed (selang makan), dan suction (penyedotan lendir), hingga suntikan dan perawatan luka.';
	@override String get title => 'Layanan Keperawatan Primer';
}

// Path: nursing.services.specialized_nursing
class _TranslationsNursingServicesSpecializedNursingId implements TranslationsNursingServicesSpecializedNursingEn {
	_TranslationsNursingServicesSpecializedNursingId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get description => 'Fokus pada pemulihan Anda, dan percayakan perawatan medis yang kompleks kepada perawat profesional kami yang berpengalaman.';
	@override String get title => 'Layanan Keperawatan Khusus';
}

// Path: pharmacy.services.health_coaching
class _TranslationsPharmacyServicesHealthCoachingId implements TranslationsPharmacyServicesHealthCoachingEn {
	_TranslationsPharmacyServicesHealthCoachingId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get description => 'Panduan dan dukungan yang dipersonalisasi untuk membantu individu mencapai target kesehatan, mengelola kondisi kronis, dan meningkatkan kesejahteraan secara keseluruhan, dengan program khusus untuk manajemen berat badan, diabetes, tekanan darah tinggi, serta kolesterol tinggi.';
	@override String get title => 'Pelatihan Kesehatan';
}

// Path: pharmacy.services.review_and_counseling
class _TranslationsPharmacyServicesReviewAndCounselingId implements TranslationsPharmacyServicesReviewAndCounselingEn {
	_TranslationsPharmacyServicesReviewAndCounselingId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get description => 'Evaluasi obat dan panduan ahli untuk membantu Anda mengelola efek samping serta mengoptimalkan hasil kesehatan Anda.';
	@override String get title => 'Evaluasi Komprehensif dan Konsultasi';
}

// Path: pharmacy.services.smoking_cessation
class _TranslationsPharmacyServicesSmokingCessationId implements TranslationsPharmacyServicesSmokingCessationEn {
	_TranslationsPharmacyServicesSmokingCessationId._(this._root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get description => 'Program berhenti merokok melibatkan penghentian kebiasaan merokok melalui strategi seperti konseling, pengobatan, dan program dukungan untuk meningkatkan kesehatan serta mengurangi risiko penyakit terkait rokok.';
	@override String get title => 'Berhenti Merokok';
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
			'booking.addon.empty' => 'Tidak ada layanan tambahan yang tersedia.',
			'booking.addon.estimated_budget' => 'Perkiraan Biaya',
			'booking.addon.title.kDefault' => 'Layanan Tambahan',
			'booking.addon.title.nursing' => 'Prosedur Keperawatan',
			'booking.addon.title.pharmacy' => 'Layanan Farmasi',
			'booking.addon.title.radiology' => 'Layanan Radiologi',
			'booking.addon.title.specialized_nursing' => 'Prosedur Keperawatan Khusus',
			'booking.book_appointment' => 'Buat Janji Temu',
			'booking.health_status.empty_record' => 'Tidak ada rekam medis yang tersedia.',
			'booking.health_status.mobility_detail_hint' => 'contoh: tongkat jalan, alat bantu jalan, lainnya',
			'booking.health_status.mobility_label' => 'Pilih status mobilitas Anda',
			'booking.health_status.record_hint' => 'Silakan pilih rekam medis',
			'booking.health_status.record_label' => 'Pilih rekam medis terkait',
			'booking.health_status.title' => 'Detail Kasus Pribadi',
			'booking.issue.add_issue_button' => 'Tambah Keluhan',
			'booking.issue.add_issue_title' => 'Tambah Keluhan',
			'booking.issue.default_page_title' => 'Kasus Layanan',
			'booking.issue.delete_dialog.content' => 'Apakah Anda yakin ingin menghapus keluhan ini?',
			'booking.issue.delete_dialog.title' => 'Hapus Keluhan',
			'booking.issue.edit_issue_title' => 'Ubah Keluhan',
			'booking.issue.empty_issue' => 'Belum ada keluhan yang ditambahkan.\n Harap tambahkan keluhan agar\nAnda dapat melanjutkan ke langkah berikutnya.',
			'booking.issue.fill_complaint_instruction' => 'Ceritakan keluhan Anda',
			'booking.issue.form.add_button' => 'Tambah',
			'booking.issue.form.complaint_description_hint' => 'Silakan masukkan pertanyaan, kekhawatiran, gejala relevan yang terkait dengan kasus Anda beserta kata kunci terkait.',
			'booking.issue.form.complaint_label' => 'Keluhan',
			'booking.issue.form.complaint_title_hint' => 'Beritahu kami keluhan Anda',
			'booking.issue.form.title_description_required' => 'Judul dan deskripsi keluhan wajib diisi.',
			'booking.issue.images' => 'Gambar',
			'booking.issue.messages.add_issue_success' => 'Keluhan berhasil ditambahkan',
			'booking.issue.messages.edit_issue_success' => 'Keluhan berhasil diperbarui',
			'booking.issue.nurse_page_title' => 'Kasus Layanan Perawat',
			'booking.issue.pharmacy_page_title' => 'Kasus Layanan Apoteker',
			'booking.issue.radiology_page_title' => 'Kasus Layanan Radiolog',
			'booking.issue.updated_on' => ({required Object date}) => 'Diperbarui pada: ${date}',
			'booking.professional_detail.about_me' => 'Tentang Saya',
			'booking.professional_detail.certificates' => 'Sertifikat Profesional',
			'booking.professional_detail.experience_label' => 'Pengalaman',
			'booking.professional_detail.id_number' => ({required Object number}) => 'Nomor ID: ${number}',
			'booking.professional_detail.issued_on' => ({required Object date}) => 'Diterbitkan: ${date}',
			'booking.professional_detail.no_certificate' => 'Sertifikat tidak tersedia.',
			'booking.professional_detail.no_reviews' => 'Belum ada ulasan.',
			'booking.professional_detail.patients_label' => 'Pasien',
			'booking.professional_detail.rating_label' => 'Penilaian',
			'booking.professional_detail.reviews' => 'Ulasan',
			'booking.professional_detail.schedule_button' => 'Jadwalkan Janji Temu',
			'booking.professional_detail.see_all_button' => 'Lihat Semua',
			'booking.professional_detail.title.kDefault' => 'Detail Profesional',
			'booking.professional_detail.title.nurse' => 'Detail Perawat',
			'booking.professional_detail.title.pharmacist' => 'Detail Apoteker',
			'booking.professional_detail.title.radiologist' => 'Detail Radiolog',
			'booking.professional_detail.working_info' => 'Informasi Kerja',
			'booking.professional_search.appointment_button' => 'Buat Janji Temu',
			'booking.professional_search.empty' => 'Tidak ditemukan profesional yang cocok dengan kriteria Anda.',
			'booking.professional_search.filter_text' => ({required Object count}) => 'Difilter berdasarkan ${count} layanan terpilih',
			'booking.professional_search.title.caregiver' => 'Cari Pengasuh/Pendamping/Pekerja',
			'booking.professional_search.title.kDefault' => 'Cari Profesional',
			'booking.professional_search.title.nurse' => 'Cari Perawat',
			'booking.professional_search.title.pharmacist' => 'Cari Apoteker',
			'booking.professional_search.title.radiologist' => 'Cari Radiolog',
			'booking.schedule.empty_slots' => 'Tidak ada slot tersedia untuk hari ini.',
			'booking.schedule.messages.reschedule_failed' => 'Penjadwalan ulang gagal.',
			'booking.schedule.messages.reschedule_success' => 'Janji temu berhasil dijadwalkan ulang',
			'booking.schedule.select_date' => 'Pilih Tanggal',
			'booking.schedule.select_hour' => 'Pilih Jam',
			'booking.schedule.submit_button' => 'Kirim',
			'booking.schedule.submitting_button' => 'Mengirim...',
			'booking.schedule.title' => 'Pilih Jadwal',
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
			'global.add' => 'Tambah',
			'global.book_now' => 'Pesan Sekarang',
			'global.cancel' => 'Batal',
			'global.complete' => 'Selesai',
			'global.confirm' => 'Konfirmasi',
			'global.delete' => 'Hapus',
			'global.description' => 'Deskripsi',
			'global.dialog.coming_soon' => 'Segera Hadir',
			'global.dialog.feature_available_soon' => 'Fitur ini akan segera tersedia!',
			'global.edit_information' => 'Ubah Informasi',
			'global.error' => 'Error',
			'global.error_message' => ({required Object error}) => 'Error: ${error}',
			'global.messages.delete_success' => 'Berhasil dihapus',
			'global.messages.updated_success' => 'Berhasil diperbarui',
			'global.modify' => 'Ubah',
			'global.next' => 'Lanjut',
			'global.no' => 'Tidak',
			'global.no_data' => 'Tidak ada data tersedia',
			'global.none' => 'Tidak Ada',
			'global.not_specified' => 'Tidak ditentukan',
			'global.ok' => 'OK',
			'global.other' => 'Lainnya',
			'global.ready' => 'Siap',
			'global.remove' => 'Hapus',
			'global.retry' => 'Coba Lagi',
			'global.save' => 'Simpan',
			'global.saving' => 'Menyimpan...',
			'global.services' => 'Layanan',
			'global.status' => 'Status',
			'global.submit' => 'Kirim',
			'global.unknown_location' => 'Lokasi Tidak Diketahui',
			'global.update' => 'Perbarui',
			'global.yes' => 'Ya',
			'nursing.services.primary_nursing.description' => 'Memantau dan melakukan prosedur keperawatan mulai dari pemeriksaan fisik, pemberian obat, tube feed (selang makan), dan suction (penyedotan lendir), hingga suntikan dan perawatan luka.',
			'nursing.services.primary_nursing.title' => 'Layanan Keperawatan Primer',
			'nursing.services.specialized_nursing.description' => 'Fokus pada pemulihan Anda, dan percayakan perawatan medis yang kompleks kepada perawat profesional kami yang berpengalaman.',
			'nursing.services.specialized_nursing.title' => 'Layanan Keperawatan Khusus',
			'nursing.title' => 'Layanan Keperawatan di Rumah',
			'payment.error.appointment_id_missing' => 'Error: ID Janji Temu hilang.',
			'payment.feedback.enter_amount_hint' => 'Masukkan jumlah',
			'payment.feedback.enter_other_amount' => 'Masukkan jumlah lain',
			'payment.feedback.excellent' => 'Luar Biasa',
			'payment.feedback.give_tips' => ({required Object name}) => 'Berikan tip kepada ${name}',
			'payment.feedback.rated_text' => ({required Object name, required Object stars}) => 'Anda memberi ${name} ${stars} bintang',
			'payment.feedback.submit_btn' => 'Kirim Ulasan',
			'payment.feedback.write_text_hint' => 'Tulis ulasan Anda di sini...',
			'payment.feedback_success.content' => 'Ulasan Anda telah berhasil dikirim.',
			'payment.feedback_success.thank_you' => 'Terima Kasih!',
			'payment.feedback_success.view_detail_btn' => 'Lihat Detail Janji Temu',
			'payment.messages.failed' => ({required Object error}) => 'Pembayaran Gagal: ${error}',
			'payment.messages.feedback_failed' => ({required Object error}) => 'Gagal Mengirim Ulasan: ${error}',
			'payment.messages.purchase_failed' => ({required Object error}) => 'Pembelian Gagal: ${error}',
			'payment.methods.cash_offline' => 'Tunai (Pembayaran Offline)',
			'payment.offline_success.content' => 'Permintaan Anda telah berhasil dikirim.\nSilakan bayar langsung ke profesional saat janji temu.',
			'payment.offline_success.estimated_total' => 'Perkiraan Total',
			'payment.offline_success.title' => 'Permintaan Dikirim',
			'payment.order_summary' => 'Ringkasan Pesanan',
			'payment.pay_btn' => ({required Object amount}) => 'Bayar ${amount}',
			'payment.price_label' => 'Harga',
			'payment.return_home_btn' => 'Kembali ke Beranda',
			'payment.select_method' => 'Pilih Metode Pembayaran',
			'payment.service_charge' => 'Biaya Layanan',
			'payment.subscription_success.content' => ({required Object planName}) => 'Anda telah berhasil membeli ${planName}',
			'payment.subscription_success.title' => 'Pembayaran Berhasil',
			'payment.success.amount' => 'Jumlah',
			'payment.success.content' => ({required Object name}) => 'Uang Anda telah berhasil dikirim ke ${name}.',
			'payment.success.experience_subtitle' => 'Ulasan Anda akan membantu kami meningkatkan\npengalaman Anda menjadi lebih baik',
			'payment.success.experience_title' => 'Bagaimana pengalaman Anda?',
			'payment.success.feedback_btn' => 'Berikan Ulasan',
			'payment.success.title' => 'Pembayaran Berhasil',
			'payment.title' => 'Pembayaran',
			'payment.total_label' => 'Total',
			'payment.validity_label' => 'Masa Berlaku',
			'pharmacy.services.health_coaching.description' => 'Panduan dan dukungan yang dipersonalisasi untuk membantu individu mencapai target kesehatan, mengelola kondisi kronis, dan meningkatkan kesejahteraan secara keseluruhan, dengan program khusus untuk manajemen berat badan, diabetes, tekanan darah tinggi, serta kolesterol tinggi.',
			'pharmacy.services.health_coaching.title' => 'Pelatihan Kesehatan',
			'pharmacy.services.review_and_counseling.description' => 'Evaluasi obat dan panduan ahli untuk membantu Anda mengelola efek samping serta mengoptimalkan hasil kesehatan Anda.',
			'pharmacy.services.review_and_counseling.title' => 'Evaluasi Komprehensif dan Konsultasi',
			'pharmacy.services.smoking_cessation.description' => 'Program berhenti merokok melibatkan penghentian kebiasaan merokok melalui strategi seperti konseling, pengobatan, dan program dukungan untuk meningkatkan kesehatan serta mengurangi risiko penyakit terkait rokok.',
			'pharmacy.services.smoking_cessation.title' => 'Berhenti Merokok',
			'pharmacy.title' => 'Layanan iRX Pharmacist',
			'settings.account' => 'Akun',
			'settings.app_language' => 'Bahasa Aplikasi',
			'settings.settings' => 'Pengaturan',
			'store.consumable' => 'Barang Habis Pakai',
			'store.messages.load_failed' => 'Gagal memuat produk',
			'store.no_products' => 'Tidak ada produk tersedia',
			'store.poct' => 'Point of Care Testing',
			'store.sort' => 'Urutkan',
			'store.title' => 'Toko Medis',
			_ => null,
		};
	}
}
