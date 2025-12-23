// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get common_cancel => 'Batal';

  @override
  String get common_confirm => 'Konfirmasi';

  @override
  String get common_delete => 'Hapus';

  @override
  String common_error(String message) {
    return 'Kesalahan: $message';
  }

  @override
  String get common_no => 'Tidak';

  @override
  String get common_no_data => 'Tidak ada data tersedia';

  @override
  String get common_retry => 'Coba Lagi';

  @override
  String get common_status => 'Status';

  @override
  String get common_description => 'Deskripsi';

  @override
  String get common_yes => 'Ya';

  @override
  String get common_complete => 'Selesai';

  @override
  String get common_save => 'Simpan';

  @override
  String get common_saving => 'Menyimpan...';

  @override
  String get common_modify => 'Ubah';

  @override
  String get common_remove => 'Hapus';

  @override
  String get common_updated_success => 'Berhasil diperbarui';

  @override
  String get common_delete_success => 'Berhasil dihapus';

  @override
  String get name => 'Nama';

  @override
  String get full_name => 'Nama Lengkap';

  @override
  String get age => 'Usia';

  @override
  String age_years_old(int age) {
    return '$age tahun';
  }

  @override
  String get gender => 'Jenis Kelamin';

  @override
  String get contact_number => 'Nomor Kontak';

  @override
  String get address => 'Alamat';

  @override
  String get weight => 'Berat';

  @override
  String get height => 'Tinggi';

  @override
  String get none => 'Tidak Ada';

  @override
  String created_on(String date) {
    return 'Dibuat pada: $date';
  }

  @override
  String get last_updated => 'Terakhir diperbarui';

  @override
  String get tab_home => 'Beranda';

  @override
  String get services => 'Layanan';

  @override
  String get allied_services => 'Layanan Kesehatan Penunjang';

  @override
  String get pharmacist_services => 'Layanan Apoteker iRX';

  @override
  String get nursing_service => 'Layanan Keperawatan di Rumah';

  @override
  String get diabetic_care_service => 'Perawatan Diabetes';

  @override
  String get home_screening_service => 'Skrining Kesehatan di Rumah';

  @override
  String get precision_nutrition_service => 'Nutrisi Presisi';

  @override
  String get homecare_for_elderly_service => 'Perawatan Lansia di Rumah';

  @override
  String get physiotherapy_service => 'Fisioterapi';

  @override
  String get remote_patient_monitoring_service =>
      'Pemantauan Kesehatan Jarak Jauh';

  @override
  String get second_opinion_service => 'Pendapat Kedua Citra Medis';

  @override
  String get health_risk_assessment_service => 'Penilaian Risiko Kesehatan';

  @override
  String get dietitian_service => 'Layanan Ahli Gizi';

  @override
  String get sleep_and_mental_health_service => 'Tidur & Kesehatan Mental';

  @override
  String dashboard_greeting(String displayName) {
    return 'Hidup Lebih Lama & Sehat, $displayName!';
  }

  @override
  String get dashboard_chat_ai_placeholder =>
      'Tanya dokter AI seputar kesehatan Anda';

  @override
  String get appointment => 'Janji Temu';

  @override
  String get appointment_list_title => 'Janji Temu Saya';

  @override
  String get appointment_status_upcoming => 'Akan Datang';

  @override
  String get appointment_status_pending => 'Menunggu';

  @override
  String get appointment_status_waiting_approval => 'Menunggu Persetujuan';

  @override
  String get appointment_status_accepted => 'Disetujui';

  @override
  String get appointment_status_completed => 'Selesai';

  @override
  String get appointment_status_cancelled => 'Dibatalkan';

  @override
  String get appointment_status_missed => 'Terlewat';

  @override
  String appointment_list_empty(String appointment_status) {
    return 'Tidak ditemukan janji temu $appointment_status.';
  }

  @override
  String get appointment_cancel_booking_btn => 'Batalkan';

  @override
  String get appointment_reschedule_btn => 'Jadwalkan Ulang';

  @override
  String get appointment_book_again_btn => 'Pesan Lagi';

  @override
  String get appointment_rating_btn => 'Nilai';

  @override
  String get appointment_decline_btn => 'Tolak';

  @override
  String get appointment_accept_btn => 'Terima';

  @override
  String get appointment_mark_complete_btn => 'Tandai Selesai';

  @override
  String get appointment_screening_confirm_sample_btn =>
      'Konfirmasi Sampel Diambil';

  @override
  String get appointment_screening_upload_report_btn => 'Unggah Laporan';

  @override
  String get appointment_arrange_video_consultation => 'Atur Konsultasi Video';

  @override
  String get appointment_pay_btn => 'Bayar';

  @override
  String get appointment_detail_title => 'Detail Janji Temu';

  @override
  String get appointment_detail_schedule_title => 'Jadwal Janji Temu';

  @override
  String get appointment_detail_patient_title => 'Informasi Pasien';

  @override
  String get appointment_detail_lab_test_title => 'Informasi Tes Lab';

  @override
  String appointment_detail_report(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Laporan',
      one: 'Laporan',
      zero: 'Tidak Ada Laporan',
    );
    return '$_temp0';
  }

  @override
  String get appointment_detail_requested_homecare_task =>
      'Tugas Homecare yang Diminta';

  @override
  String get appointment_detail_requested_homecare_task_empty =>
      'Tidak ada tugas homecare khusus yang diminta.';

  @override
  String get appointment_detail_patient_problem_title => 'Keluhan Pasien';

  @override
  String get appointment_detail_patient_problem_empty =>
      'Tidak ada detail keluhan khusus yang diberikan.';

  @override
  String get appointment_detail_payment_title => 'Informasi Pembayaran';

  @override
  String get appointment_detail_estimated_budget => 'Perkiraan Biaya';

  @override
  String get appointment_detail_payment_details => 'Rincian Pembayaran';

  @override
  String get appointment_detail_payment_date => 'Tanggal Pembayaran';

  @override
  String get appointment_detail_payment_method => 'Metode Pembayaran';

  @override
  String get appointment_detail_order_completed_date => 'Pesanan Selesai';

  @override
  String appointment_detail_total_amount(String amount) {
    return 'Total: $amount';
  }

  @override
  String get appointment_detail_total_label => 'Total';

  @override
  String get appointment_detail_service_requested => 'Layanan yang Diminta';

  @override
  String get appointment_summary => 'Ringkasan:';

  @override
  String get appointment_update_success_message =>
      'Janji temu berhasil diperbarui';

  @override
  String get appointment_accept_success_message =>
      'Janji temu berhasil diterima';

  @override
  String get appointment_decline_success_message =>
      'Janji temu berhasil ditolak';

  @override
  String get appointment_complete_success_message =>
      'Janji temu berhasil diselesaikan';

  @override
  String get appointment_confirm_sample_success_message =>
      'Pengambilan sampel berhasil dikonfirmasi';

  @override
  String get appointment_mark_report_ready_success_message =>
      'Laporan ditandai sebagai siap';

  @override
  String get appointment_cancel_dialog_content =>
      'Apakah Anda yakin ingin membatalkan janji temu ini?';

  @override
  String get appointment_cancel_dialog_subtitle =>
      'Anda dapat memesan ulang nanti dari menu janji temu yang dibatalkan.';

  @override
  String get appointment_complete_dialog_title => 'Selesaikan Janji Temu';

  @override
  String get appointment_complete_dialog_content =>
      'Tandai janji temu ini sebagai selesai?';

  @override
  String get appointment_accept_dialog_title => 'Terima Janji Temu';

  @override
  String get appointment_accept_dialog_content =>
      'Apakah Anda yakin ingin menerima janji temu ini?';

  @override
  String get appointment_decline_dialog_title =>
      'Apakah Anda yakin ingin menolak janji temu ini?';

  @override
  String get appointment_decline_dialog_subtitle =>
      'Tindakan ini tidak dapat dibatalkan.';

  @override
  String get screening_report_upload_title => 'Unggah Laporan Lab';

  @override
  String get screening_report_upload_instruction =>
      'Harap unggah semua laporan lab yang diperlukan sebelum menandainya sebagai siap.';

  @override
  String screening_report_uploaded_section(int count) {
    return 'Laporan Terunggah ($count)';
  }

  @override
  String get screening_report_empty => 'Belum ada laporan yang diunggah';

  @override
  String get screening_report_upload_btn => 'Unggah Laporan Baru';

  @override
  String get screening_report_mark_ready_btn => 'Tandai Laporan Siap';

  @override
  String get screening_report_finalize_dialog_title => 'Finalisasi Laporan?';

  @override
  String get screening_report_finalize_dialog_content =>
      'Setelah ditandai siap, laporan akan dikirim ke pasien dan Anda tidak dapat mengubahnya lagi.';

  @override
  String get screening_report_finalized_message => 'Laporan Difinalisasi';

  @override
  String get screening_report_delete_dialog_title => 'Hapus Laporan?';

  @override
  String get screening_report_delete_dialog_content =>
      'Apakah Anda yakin ingin menghapus laporan ini?';

  @override
  String get screening_report_upload_success => 'Laporan berhasil diunggah';

  @override
  String get screening_report_delete_success => 'Laporan berhasil dihapus';

  @override
  String get screening_report_finalize_success =>
      'Laporan ditandai sebagai siap';

  @override
  String get profile_patient_title => 'Profil Kesehatan Saya';

  @override
  String get profile_professional_title => 'Profil Saya';

  @override
  String get profile_not_found => 'Data profil tidak ditemukan';

  @override
  String get profile_professional_verified_label => 'Terverifikasi';

  @override
  String get profile_professional_unverified_label => 'Belum Terverifikasi';

  @override
  String profile_verified_since_date(String date) {
    return 'Sejak: $date';
  }

  @override
  String get profile_patient_info_section => 'Informasi Profil';

  @override
  String get profile_patient_basic_info => 'Informasi Dasar';

  @override
  String get profile_patient_medical_history_n_risk_factor =>
      'Riwayat Medis & Faktor Risiko';

  @override
  String get profile_patient_lifestyle_n_selfcare =>
      'Gaya Hidup & Perawatan Mandiri';

  @override
  String get profile_patient_physical_sign => 'Kondisi Fisik';

  @override
  String get profile_patient_mental_state => 'Kesehatan Mental';

  @override
  String get profile_patient_health_record_section => 'Catatan Kesehatan';

  @override
  String get profile_patient_medical_record => 'Rekam Medis';

  @override
  String get profile_patient_pharmacogenomics => 'Profil Farmakogenomik';

  @override
  String get profile_patient_wellness_genomics => 'Profil Wellness Genomic';

  @override
  String get profile_all_my_appointments => 'Semua Janji Temu';

  @override
  String get profile_professional_panel_section => 'Panel Profesional';

  @override
  String get profile_professional_edit_profile => 'Ubah Profil Profesional';

  @override
  String get profile_professional_my_services => 'Layanan Saya';

  @override
  String get profile_professional_my_schedule => 'Jadwal Saya';

  @override
  String get profile_admin_panel_section => 'Panel Admin';

  @override
  String get profile_admin_manage_services => 'Kelola Layanan';

  @override
  String get profile_admin_manage_health_screening_services =>
      'Kelola Layanan Skrining';

  @override
  String get profile_admin_verify_professional => 'Verifikasi Profesional';

  @override
  String get profile_admin_homecare_config => 'Pengaturan Homecare';

  @override
  String get settings => 'Pengaturan';

  @override
  String get settings_app_language => 'Bahasa Aplikasi';

  @override
  String get auth_logout => 'Keluar';

  @override
  String get profile_info_title => 'Informasi Profil';

  @override
  String get profile_info_profile_image => 'Foto Profil';

  @override
  String get profile_info_remove_image => 'Hapus Foto';

  @override
  String get profile_info_home_address => 'Alamat Rumah';

  @override
  String get profile_info_select_map_location_hint => 'Pilih lokasi di peta';

  @override
  String get profile_info_drug_allergies => 'Alergi Obat';

  @override
  String get risk_factor_title => 'Riwayat Medis & Faktor Risiko';

  @override
  String get medical_record_title => 'Rekam Medis';

  @override
  String get medical_record_empty => 'Tidak ada rekam medis yang ditemukan.';

  @override
  String get medical_record_confirm_delete_dialog_title => 'Hapus Rekam Medis?';

  @override
  String get medical_record_confirm_delete_dialog_content =>
      'Apakah Anda yakin ingin menghapus rekam medis ini?';

  @override
  String get medical_record_patient_status => 'Status Pasien';

  @override
  String get medical_record_disease_name => 'Nama Penyakit';

  @override
  String get medical_record_disease_history => 'Riwayat Penyakit';

  @override
  String get medical_record_special_consideration => 'Pertimbangan Khusus';

  @override
  String get medical_record_records_file => 'File Rekam Medis';

  @override
  String get medical_record_download_file_btn => 'Unduh File';

  @override
  String get medical_record_view_file_btn => 'Lihat File';

  @override
  String get diabetic_retinal_photography => 'Fotografi Retina Diabetes (DRP)';

  @override
  String get diabetic_retinal_photography_desc =>
      'Penyakit mata umum di kalangan pasien diabetes. Kapiler darah mungkin berdarah dan merusak retina, berpotensi menyebabkan kebutaan. Fotografi retina diabetes secara teratur dapat mendeteksi dan memantau mata Anda.';

  @override
  String get diabetic_foot_screening => 'Skrining Kaki Diabetes (DFS)';

  @override
  String get diabetic_foot_screening_desc =>
      'Dilakukan oleh perawat terlatih, yang juga akan mengedukasi tentang perawatan kaki yang tepat dan kontrol gula yang baik. Rujukan ke spesialis perawatan kaki akan dibuat jika perlu.';

  @override
  String get diabetic_care_title => 'Perawatan Diabetes';

  @override
  String get common_book_now => 'Pesan Sekarang';

  @override
  String get diabetes_form_submit_failed => 'Gagal mengirim formulir.';

  @override
  String get common_error_title => 'Kesalahan';

  @override
  String get diabetes_form_load_failed => 'Gagal memuat data formulir.';

  @override
  String get common_next => 'Lanjut';

  @override
  String get common_submit => 'Kirim';

  @override
  String get diabetes_form_title => 'Formulir Diabetes';

  @override
  String get diabetes_history_title => 'Riwayat Diabetes';

  @override
  String get diabetes_type_label => 'Tipe Diabetes';

  @override
  String get common_not_specified => 'Tidak ditentukan';

  @override
  String get year_of_diagnosis_label => 'Tahun Diagnosis';

  @override
  String get last_hba1c_label => 'HbA1c Terakhir';

  @override
  String get current_treatment_label => 'Pengobatan Saat Ini';

  @override
  String get risk_factors_title => 'Riwayat Medis & Faktor Risiko';

  @override
  String get hypertension_label => 'Hipertensi';

  @override
  String get dyslipidemia_label => 'Dislipidemia';

  @override
  String get cardiovascular_disease_label => 'Penyakit Kardiovaskular';

  @override
  String get eye_disease_label => 'Penyakit Mata (Retinopati)';

  @override
  String get neuropathy_label => 'Neuropati';

  @override
  String get kidney_disease_label => 'Penyakit Ginjal';

  @override
  String get family_history_label => 'Riwayat Keluarga';

  @override
  String get smoking_label => 'Merokok';

  @override
  String get lifestyle_self_care_title => 'Gaya Hidup & Perawatan Mandiri';

  @override
  String get recent_hypoglycemia_label => 'Hipoglikemia Baru-baru ini';

  @override
  String get physical_activity_label => 'Aktivitas Fisik';

  @override
  String get diet_quality_label => 'Kualitas Diet';

  @override
  String get physical_signs_title => 'Tanda Fisik';

  @override
  String get physical_signs_if_have_title => 'Tanda Fisik (Jika Ada)';

  @override
  String get eyes_last_exam_label => 'Mata (Pemeriksaan Terakhir)';

  @override
  String get eyes_findings_label => 'Mata (Temuan)';

  @override
  String get kidneys_egfr_label => 'Ginjal (eGFR)';

  @override
  String get kidneys_urine_acr_label => 'Ginjal (Urine ACR)';

  @override
  String get feet_skin_label => 'Kaki (Kulit)';

  @override
  String get feet_deformity_label => 'Kaki (Deformitas)';

  @override
  String get common_edit_information => 'Ubah Informasi';

  @override
  String get diabetes_type_question => 'Tipe Diabetes:';

  @override
  String get diabetes_type_1 => 'Tipe 1';

  @override
  String get diabetes_type_2 => 'Tipe 2';

  @override
  String get diabetes_type_gestational => 'Gestasional';

  @override
  String get common_other => 'Lainnya';

  @override
  String get enter_diabetes_type_hint => 'Silakan masukkan tipe diabetes Anda';

  @override
  String get specify_diabetes_type_error =>
      'Harap tentukan tipe diabetes Anda.';

  @override
  String get year_of_diagnosis_question => 'Tahun Diagnosis:';

  @override
  String get year_hint => 'mis. 2021';

  @override
  String get invalid_year_error => 'Tahun tidak valid.';

  @override
  String get last_hba1c_question => 'HbA1c Terakhir:';

  @override
  String get invalid_value_error => 'Nilai tidak valid.';

  @override
  String get current_treatment_question => 'Pengobatan Saat Ini:';

  @override
  String get treatment_diet_exercise => 'Diet & Olahraga';

  @override
  String get treatment_oral_medications => 'Obat Oral';

  @override
  String get list_medications_hint => 'Daftar obat...';

  @override
  String get list_medications_error => 'Harap cantumkan obat oral Anda.';

  @override
  String get treatment_insulin => 'Insulin';

  @override
  String get insulin_type_dose_hint => 'Tipe & dosis';

  @override
  String get insulin_type_dose_error =>
      'Harap tentukan tipe & dosis insulin Anda.';

  @override
  String get answer_all_questions_error =>
      'Harap jawab semua pertanyaan di halaman ini.';

  @override
  String get recent_hypoglycemia_question => 'Hipoglikemia Baru-baru ini:';

  @override
  String get hypoglycemia_none => 'Tidak Ada';

  @override
  String get hypoglycemia_mild => 'Ringan';

  @override
  String get hypoglycemia_severe => 'Berat';

  @override
  String get physical_activity_question => 'Aktivitas Fisik:';

  @override
  String get activity_regular => 'Teratur';

  @override
  String get activity_occasional => 'Sesekali';

  @override
  String get activity_sedentary => 'Sedenter (Kurang Gerak)';

  @override
  String get diet_quality_question => 'Kualitas Diet:';

  @override
  String get diet_healthy => 'Sehat';

  @override
  String get diet_needs_improvement => 'Perlu Perbaikan';

  @override
  String get eyes_label => 'Mata:';

  @override
  String get last_exam_date_label => 'Tanggal Pemeriksaan Terakhir';

  @override
  String get invalid_date_format_error =>
      'Format tidak valid (Gunakan TTTT-BB-HH)';

  @override
  String get invalid_date_error => 'Tanggal tidak valid.';

  @override
  String get findings_label => 'Temuan';

  @override
  String get kidneys_label => 'Ginjal:';

  @override
  String get feet_label => 'Kaki:';

  @override
  String get skin_label => 'Kulit:';

  @override
  String get skin_normal => 'Normal';

  @override
  String get skin_dry => 'Kering';

  @override
  String get skin_ulcer => 'Ulkus';

  @override
  String get skin_infection => 'Infeksi';

  @override
  String get deformity_label => 'Deformitas:';

  @override
  String get deformity_none => 'Tidak Ada';

  @override
  String get deformity_bunions => 'Bunion';

  @override
  String get deformity_claw_toes => 'Jari Kaki Cakar';

  @override
  String get smoking_current => 'Perokok Aktif';

  @override
  String get smoking_former => 'Mantan Perokok';

  @override
  String get smoking_never => 'Tidak Pernah';

  @override
  String get family_history_diabetes_label => 'Riwayat Diabetes Keluarga';

  @override
  String get common_none => 'Tidak Ada';

  @override
  String get common_upload_tap => 'Ketuk untuk mengunggah laporan';

  @override
  String get common_ready => 'Siap';

  @override
  String get common_full_report_file => 'File Laporan Lengkap';

  @override
  String get common_ok => 'OK';

  @override
  String get mental_state_title => 'Kesehatan Mental';

  @override
  String get mental_state_current_section => 'Kesehatan Mental (Saat Ini)';

  @override
  String get mental_state_overall_mood => 'Suasana Hati Keseluruhan:';

  @override
  String get mental_state_anxiety_level => 'Tingkat Kecemasan:';

  @override
  String get mental_state_stress_level => 'Tingkat Stres:';

  @override
  String get mental_state_energy_level => 'Tingkat Energi:';

  @override
  String get mental_state_focus_level => 'Tingkat Fokus:';

  @override
  String get mental_state_sleep_quality => 'Kualitas Tidur:';

  @override
  String get mental_state_notes_label =>
      'Catatan/Peristiwa yang memengaruhi suasana hati:';

  @override
  String get mental_state_notes_hint => 'Catatan tambahan';

  @override
  String get pharmacogenomics_profile_title => 'Profil Farmakogenomik';

  @override
  String get pharmacogenomics_delete_report_title => 'Hapus Laporan';

  @override
  String get pharmacogenomics_delete_report_content =>
      'Apakah Anda yakin ingin menghapus file laporan ini?';

  @override
  String get wellness_genomics_profile_title => 'Profil Wellness Genomic';

  @override
  String get settings_language_title => 'Pengaturan Bahasa Aplikasi';

  @override
  String get language_en => 'Inggris (en)';

  @override
  String get language_zh => 'Mandarin (zh)';

  @override
  String get language_id => 'Bahasa Indonesia (id)';

  @override
  String get auth_sign_in_title => 'Login';

  @override
  String get auth_welcome_back => 'Selamat Datang Kembali!';

  @override
  String get auth_email_hint => 'Email';

  @override
  String get auth_password_hint => 'Kata Sandi';

  @override
  String get auth_forgot_password_btn => 'Lupa Kata Sandi?';

  @override
  String get auth_sign_in_btn => 'Masuk';

  @override
  String get auth_create_account => 'Buat akun baru';

  @override
  String get auth_continue_with => 'atau lanjutkan dengan';

  @override
  String get auth_error_title => 'Kesalahan';

  @override
  String get auth_fill_email_password_error =>
      'Harap isi Email dan Kata Sandi.';

  @override
  String get auth_fill_all_fields_error =>
      'Harap isi semua bidang dengan benar.';

  @override
  String get auth_select_role_error => 'Harap pilih tipe pengguna';

  @override
  String get auth_select_role_first_error =>
      'Harap pilih tipe pengguna terlebih dahulu';

  @override
  String get auth_passwords_do_not_match => 'Kata sandi tidak cocok';

  @override
  String get auth_enter_valid_email => 'Harap masukkan email yang valid';

  @override
  String get auth_enter_email => 'Harap masukkan email Anda';

  @override
  String get auth_enter_password => 'Harap masukkan kata sandi';

  @override
  String get auth_password_length_error =>
      'Kata sandi harus minimal 6 karakter';

  @override
  String get auth_enter_username => 'Harap masukkan nama pengguna';

  @override
  String get auth_confirm_password_hint => 'Konfirmasi Kata Sandi';

  @override
  String get auth_username_hint => 'Nama Pengguna';

  @override
  String get auth_select_user_type_hint => 'Pilih Tipe Pengguna';

  @override
  String get auth_role_patient => 'Pasien';

  @override
  String get auth_role_nurse => 'Perawat';

  @override
  String get auth_role_pharmacist => 'Apoteker';

  @override
  String get auth_role_radiologist => 'Radiolog';

  @override
  String get auth_role_caregiver => 'Pengasuh/Pendamping';

  @override
  String get auth_sign_up_title => 'Buat Akun';

  @override
  String get auth_sign_up_subtitle =>
      'Buat akun agar Anda dapat menjelajahi semua\npekerjaan yang ada';

  @override
  String get auth_sign_up_btn => 'Daftar';

  @override
  String get auth_already_have_account => 'Sudah punya akun';

  @override
  String get auth_registration_successful_title => 'Pendaftaran Berhasil';

  @override
  String get auth_registration_successful_content =>
      'Silakan periksa email Anda untuk verifikasi.';

  @override
  String get auth_complete_registration_title => 'Selesaikan Pendaftaran';

  @override
  String get auth_complete_registration_content =>
      'Selamat Datang!\nSilakan pilih tipe akun Anda untuk melanjutkan.';

  @override
  String get auth_forgot_password_title => 'Lupa Kata Sandi?';

  @override
  String get auth_forgot_password_subtitle =>
      'Jangan khawatir! Silakan masukkan alamat email yang terhubung dengan akun Anda.';

  @override
  String get auth_enter_email_hint => 'Masukkan email Anda';

  @override
  String get auth_send_code_btn => 'Kirim Kode';

  @override
  String get auth_otp_sent_success => 'OTP berhasil dikirim';

  @override
  String get auth_otp_verification_title => 'Masukkan Kode Verifikasi';

  @override
  String auth_otp_verification_subtitle(String email) {
    return 'Masukkan kode yang telah kami kirim ke email Anda $email';
  }

  @override
  String get auth_verify_btn => 'Verifikasi';

  @override
  String get auth_resend_code => 'Tidak menerima kode? Kirim Ulang';

  @override
  String auth_resend_in_seconds(int seconds) {
    return 'Kirim ulang dalam $seconds detik';
  }

  @override
  String get auth_code_resent => 'Kode dikirim ulang!';

  @override
  String get auth_pin_incorrect => 'Pin salah';

  @override
  String get auth_reset_password_title => 'Atur Ulang Kata Sandi';

  @override
  String get auth_reset_password_subtitle =>
      'Silakan masukkan kata sandi baru Anda';

  @override
  String get auth_new_password_hint => 'Kata Sandi Baru';

  @override
  String get auth_confirm_password_error => 'Harap konfirmasi kata sandi Anda';

  @override
  String get auth_reset_password_btn => 'Atur Ulang Kata Sandi';

  @override
  String get auth_reset_password_success_title =>
      'Atur Ulang Kata Sandi Berhasil!';

  @override
  String get auth_reset_password_success_content =>
      'Anda telah berhasil mengatur ulang kata sandi Anda. Silakan gunakan kata sandi baru Anda saat masuk.';

  @override
  String get auth_back_to_login_btn => 'Kembali ke Login';

  @override
  String get booking_nursing_primary_title => 'Perawatan Primer';

  @override
  String get booking_nursing_primary_desc =>
      'Memantau dan memberikan\nprosedur keperawatan mulai dari\npemeriksaan tubuh, pengobatan,\nselang makan dan penyedotan hingga\nsuntikan dan perawatan luka.';

  @override
  String get booking_nursing_specialized_title => 'Layanan Keperawatan Khusus';

  @override
  String get booking_nursing_specialized_desc =>
      'Fokus pada pemulihan dan serahkan perawatan keperawatan yang kompleks di tangan perawat profesional kami yang berpengalaman';

  @override
  String get booking_nursing_page_title => 'Layanan Keperawatan di Rumah';

  @override
  String get booking_pharmacy_page_title => 'Layanan Apoteker iRX';

  @override
  String get booking_pharmacy_medication_counseling_title =>
      'Konseling dan Edukasi\nObat';

  @override
  String get booking_pharmacy_medication_counseling_desc =>
      'Konseling dan edukasi obat memandu\npasien tentang penggunaan yang tepat, efek samping, dan\nkepatuhan terhadap resep,\nmeningkatkan keamanan dan\nmeningkatkan hasil kesehatan.';

  @override
  String get booking_pharmacy_therapy_review_title =>
      'Tinjauan Terapi\nKomprehensif';

  @override
  String get booking_pharmacy_therapy_review_desc =>
      'Tinjauan komprehensif terhadap obat\ndan gaya hidup Anda untuk mengoptimalkan hasil\npengobatan dan meminimalkan potensi efek\nsamping';

  @override
  String get booking_pharmacy_health_coaching_title => 'Pelatihan Kesehatan';

  @override
  String get booking_pharmacy_health_coaching_desc =>
      'Panduan dan dukungan yang dipersonalisasi untuk membantu\nindividu mencapai tujuan kesehatan mereka, mengelola\nkondisi kronis, dan meningkatkan kesejahteraan secara keseluruhan\n, dengan program khusus untuk manajemen\nberat badan, manajemen diabetes, manajemen\ntekanan darah tinggi, dan manajemen\nkolesterol tinggi';

  @override
  String get booking_pharmacy_smoking_cessation_title => 'Berhenti Merokok';

  @override
  String get booking_pharmacy_smoking_cessation_desc =>
      'Berhenti merokok melibatkan menghentikan\nkebiasaan merokok melalui strategi seperti\nkonseling, obat-obatan, dan program\ndukungan untuk meningkatkan kesehatan dan\nmengurangi risiko penyakit terkait\nmerokok.';

  @override
  String get booking_issue_list_title_nursing => 'Kasus Layanan Perawat';

  @override
  String get booking_issue_list_title_pharmacy => 'Kasus Layanan Apoteker';

  @override
  String get booking_issue_list_title_radiology => 'Kasus Layanan Radiolog';

  @override
  String get booking_issue_list_title_default => 'Kasus Layanan';

  @override
  String get booking_tell_us_concern => 'Beritahu kami keluhan Anda';

  @override
  String get booking_issue_empty =>
      'Belum ada keluhan yang ditambahkan.\n Harap tambahkan keluhan agar\nAnda dapat melanjutkan ke langkah berikutnya.';

  @override
  String get booking_add_issue_btn => 'Tambah Keluhan';

  @override
  String get booking_next_btn => 'Lanjut';

  @override
  String get booking_issue_delete_dialog_title => 'Hapus Keluhan';

  @override
  String get booking_issue_delete_dialog_content =>
      'Apakah Anda yakin ingin menghapus keluhan ini?';

  @override
  String get booking_issue_form_add_title => 'Tambah Keluhan';

  @override
  String get booking_issue_form_edit_title => 'Ubah Keluhan';

  @override
  String get booking_issue_form_instruction => 'Ceritakan kekhawatiran Anda';

  @override
  String get booking_issue_form_title_hint => 'Judul Keluhan';

  @override
  String get booking_issue_form_desc_hint =>
      'Silakan masukkan pertanyaan, kekhawatiran, gejala relevan yang terkait dengan kasus Anda beserta kata kunci terkait.';

  @override
  String get booking_issue_form_images_label => 'Gambar';

  @override
  String get booking_issue_form_update_btn => 'Perbarui';

  @override
  String get booking_issue_form_add_btn => 'Tambah';

  @override
  String get booking_issue_form_required_error =>
      'Judul dan deskripsi keluhan wajib diisi.';

  @override
  String get booking_issue_form_success_update => 'Keluhan berhasil diperbarui';

  @override
  String get booking_issue_form_success_add => 'Keluhan berhasil ditambahkan';

  @override
  String get booking_health_status_title => 'Detail Kasus Pribadi';

  @override
  String get booking_health_status_mobility_label =>
      'Pilih status mobilitas Anda';

  @override
  String get booking_health_status_record_label => 'Pilih rekam medis terkait';

  @override
  String get booking_health_status_record_hint => 'Silakan pilih rekam medis';

  @override
  String get booking_health_status_no_records =>
      'Tidak ada rekam medis yang tersedia.';

  @override
  String get booking_addon_nursing_title => 'Prosedur Keperawatan';

  @override
  String get booking_addon_specialized_nursing_title =>
      'Prosedur Keperawatan Khusus';

  @override
  String get booking_addon_pharmacy_title => 'Layanan Farmasi';

  @override
  String get booking_addon_radiology_title => 'Layanan Radiologi';

  @override
  String get booking_addon_default_title => 'Layanan Tambahan';

  @override
  String get booking_addon_empty => 'Tidak ada layanan tambahan yang tersedia.';

  @override
  String get booking_estimated_budget => 'Perkiraan Biaya';

  @override
  String get booking_book_appointment_btn => 'Buat Janji Temu';

  @override
  String get booking_professional_search_nurse => 'Cari Perawat';

  @override
  String get booking_professional_search_pharmacist => 'Cari Apoteker';

  @override
  String get booking_professional_search_radiologist => 'Cari Radiolog';

  @override
  String get booking_professional_search_caregiver =>
      'Cari Pengasuh/Pendamping/Pekerja';

  @override
  String get booking_professional_search_default => 'Cari Profesional';

  @override
  String booking_professional_filter_text(int count) {
    return 'Difilter berdasarkan $count layanan terpilih';
  }

  @override
  String get booking_professional_empty =>
      'Tidak ditemukan profesional yang cocok dengan kriteria Anda.';

  @override
  String get booking_professional_appointment_btn => 'Buat Janji Temu';

  @override
  String get booking_professional_detail_nurse => 'Detail Perawat';

  @override
  String get booking_professional_detail_pharmacist => 'Detail Apoteker';

  @override
  String get booking_professional_detail_radiologist => 'Detail Radiolog';

  @override
  String get booking_professional_detail_default => 'Detail Profesional';

  @override
  String get booking_professional_patients_label => 'Pasien';

  @override
  String get booking_professional_experience_label => 'Pengalaman';

  @override
  String get booking_professional_rating_label => 'Penilaian';

  @override
  String get booking_professional_about_me => 'Tentang Saya';

  @override
  String get booking_professional_working_info => 'Informasi Kerja';

  @override
  String get booking_professional_certificate => 'Sertifikat Profesional';

  @override
  String get booking_professional_no_certificate =>
      'Sertifikat tidak tersedia.';

  @override
  String booking_professional_id_number(String number) {
    return 'Nomor ID: $number';
  }

  @override
  String booking_professional_issued_on(String date) {
    return 'Diterbitkan: $date';
  }

  @override
  String get booking_professional_reviews => 'Ulasan';

  @override
  String get booking_professional_see_all => 'Lihat Semua';

  @override
  String get booking_professional_no_reviews => 'Belum ada ulasan.';

  @override
  String get booking_professional_schedule_btn => 'Jadwalkan Janji Temu';

  @override
  String get booking_schedule_title => 'Pilih Jadwal';

  @override
  String get booking_schedule_select_date => 'Pilih Tanggal';

  @override
  String get booking_schedule_select_hour => 'Pilih Jam';

  @override
  String get booking_schedule_no_slots =>
      'Tidak ada slot tersedia untuk hari ini.';

  @override
  String get booking_schedule_submit_btn => 'Kirim';

  @override
  String get booking_schedule_submitting => 'Mengirim...';

  @override
  String get booking_schedule_reschedule_success =>
      'Janji temu berhasil dijadwalkan ulang';

  @override
  String get booking_schedule_reschedule_failed => 'Penjadwalan ulang gagal.';

  @override
  String get booking_appointment_created_success =>
      'Janji temu berhasil dibuat';

  @override
  String get booking_appointment_created_failed => 'Gagal membuat janji temu';

  @override
  String get chat_pharma_title => 'Apoteker AI';

  @override
  String get chat_pharma_online => 'Online';

  @override
  String get chat_pharma_privacy => '(Privasi HIPAA)';

  @override
  String get chat_pharma_need_help => 'Butuh Bantuan? ';

  @override
  String get chat_pharma_request_help => 'Minta bantuan dari Apoteker';

  @override
  String get chat_pharma_input_hint => 'Tulis pesan Anda';

  @override
  String get common_unknown_location => 'Lokasi Tidak Diketahui';

  @override
  String get booking_personal_issue_concern => 'Kekhawatiran / Pertanyaan';

  @override
  String booking_personal_issue_updated_on(String date) {
    return 'Diperbarui pada: $date';
  }

  @override
  String get booking_personal_issue_images => 'Gambar';

  @override
  String get booking_mobility_bedbound => 'Terbaring di Tempat Tidur';

  @override
  String get booking_mobility_wheelchair_bound => 'Menggunakan Kursi Roda';

  @override
  String get booking_mobility_walking_aid => 'Alat Bantu Jalan';

  @override
  String get booking_mobility_mobile_without_aid => 'Bergerak Tanpa Alat Bantu';

  @override
  String get home_health_screening_title => 'Skrining Kesehatan di Rumah';

  @override
  String get home_health_at_home_diagnostic => 'Tes diagnostik di rumah';

  @override
  String get home_health_at_home_diagnostic_desc =>
      'Pasien mengumpulkan sampel di rumah menggunakan alat pengumpulan mandiri, yang mencakup bahan seperti penyeka, kartu tes, dan tabung pengumpul, dan menyerahkannya ke laboratorium bersertifikat CLIA/CAP (laboratorium telemedis) untuk diproses. Teknisi laboratorium memproses sampel ini dan mengunggah hasilnya ke portal online. Dokter perawatan primer, spesialis, atau profesional kesehatan lainnya meninjau hasil dan memandu pasien melalui langkah selanjutnya.';

  @override
  String get home_health_point_of_care => 'Tes di tempat perawatan (POCT)';

  @override
  String get home_health_point_of_care_desc =>
      'Diagnostik dilakukan di luar laboratorium yang dapat dilakukan pasien sendiri di rumah. Tes ini berkembang dengan cepat dan menghasilkan hasil tanpa kehadiran dokter atau teknisi laboratorium. Dengan tes di tempat perawatan, pasien meninjau hasil di luar pengaturan medis dan menentukan langkah selanjutnya sendiri.';

  @override
  String get home_health_screening_booked_success =>
      'Janji temu skrining berhasil dipesan!';

  @override
  String get home_health_screening_booking_failed => 'Pemesanan gagal';

  @override
  String get homecare_elderly_title => 'Perawatan Lansia di Rumah';

  @override
  String get homecare_house_bedding_cleaning =>
      'Pembersihan Rumah & Tempat Tidur';

  @override
  String get homecare_house_bedding_cleaning_desc =>
      'Layanan kebersihan rutin untuk menjaga lingkungan hidup yang higienis, nyaman, dan aman bagi lansia.';

  @override
  String get homecare_living_security_safety =>
      'Keamanan & Keselamatan Tempat Tinggal';

  @override
  String get homecare_living_security_safety_desc =>
      'Pemeriksaan keamanan dan penataan untuk mengurangi risiko dan menciptakan lingkungan hidup yang aman.';

  @override
  String get homecare_kitchen_bathroom_repair =>
      'Perbaikan Dapur & Kamar Mandi';

  @override
  String get homecare_kitchen_bathroom_repair_desc =>
      'Perbaikan kecil sesuai permintaan untuk menjaga fungsionalitas dan keamanan di area utama rumah.';

  @override
  String get homecare_plus_active => 'Homecare Plus Aktif';

  @override
  String get homecare_get_plus => 'Dapatkan Homecare Plus';

  @override
  String homecare_balance(int balance) {
    return 'Saldo: $balance Jam';
  }

  @override
  String homecare_subscription_offer(int quota, String price) {
    return '$quota Jam seharga $price';
  }

  @override
  String get homecare_request_services_btn => 'Minta Layanan';

  @override
  String get homecare_select_at_least_one_task =>
      'Harap pilih setidaknya satu tugas.';

  @override
  String get homecare_task_list_title => 'Daftar Tugas';

  @override
  String get homecare_feature_name => 'NAMA FITUR';

  @override
  String get homecare_frequency => 'FREKUENSI';

  @override
  String get homecare_weekly => 'Mingguan';

  @override
  String get homecare_monthly => 'Bulanan';

  @override
  String get homecare_as_needed => 'Sesuai Kebutuhan';

  @override
  String get homecare_review_checkout_title => 'Tinjau & Pembayaran';

  @override
  String get homecare_requested_tasks => 'Tugas yang Diminta';

  @override
  String get homecare_billing_option => 'Opsi Penagihan';

  @override
  String get homecare_hourly_rate => 'Tarif Per Jam';

  @override
  String get homecare_use_subscription_balance => 'Gunakan Saldo Langganan';

  @override
  String homecare_deduct_hours(int hours, int balance) {
    return 'Potong $hours Jam (Saldo: $balance j)';
  }

  @override
  String homecare_insufficient_balance(int balance) {
    return 'Saldo Tidak Cukup ($balance j)';
  }

  @override
  String get homecare_confirm_booking_btn => 'Konfirmasi Pesanan';

  @override
  String get homecare_subscription_plans_title => 'Paket Langganan';

  @override
  String homecare_care_hours(int hours) {
    return '$hours Jam Perawatan';
  }

  @override
  String homecare_valid_for_days(int days) {
    return 'Berlaku selama $days Hari';
  }

  @override
  String get homecare_experienced_caregivers => 'Perawat Berpengalaman';

  @override
  String get homecare_active_subscription => 'Langganan Aktif';

  @override
  String homecare_expires_on(String date) {
    return 'Berakhir pada $date';
  }

  @override
  String homecare_purchase_now(String price) {
    return 'Beli Sekarang - $price';
  }

  @override
  String get precision_nutrition_title => 'Nutrisi Presisi';

  @override
  String get precision_assessment_title => 'Penilaian Nutrisi Presisi';

  @override
  String get precision_assessment_desc =>
      'Mulai perjalanan Anda dengan analisis mendalam tentang gen, metabolisme, dan gaya hidup Anda untuk memahami kebutuhan unik tubuh Anda.';

  @override
  String get precision_plan_title => 'Rencana Nutrisi Presisi';

  @override
  String get precision_plan_desc =>
      'Dapatkan strategi nutrisi yang dipersonalisasi yang dibuat oleh para ahli untuk mengatasi tujuan dan kondisi kesehatan spesifik Anda.';

  @override
  String get precision_implementation_title => 'Implementasi Nutrisi Presisi';

  @override
  String get precision_implementation_desc =>
      'Lacak kemajuan dan sesuaikan rencana Anda melalui dukungan berkelanjutan, pemantauan biomarker, dan alat digital cerdas.';

  @override
  String get precision_start_now => 'Mulai Sekarang';

  @override
  String get precision_book_now => 'Pesan Sekarang';

  @override
  String get precision_main_concern_question => 'Apa kekhawatiran utama Anda?';

  @override
  String get precision_main_concern_subtitle =>
      'Pilih area yang paling menggambarkan tujuan kesehatan utama Anda';

  @override
  String get precision_sub_health => 'Sub-Sehat';

  @override
  String get precision_sub_health_desc =>
      'Tingkatkan kesehatan dan tingkat energi secara keseluruhan';

  @override
  String get precision_chronic_disease => 'Penyakit Kronis';

  @override
  String get precision_chronic_disease_desc =>
      'Kelola dan tingkatkan kondisi kesehatan kronis';

  @override
  String get precision_anti_aging => 'Anti-penuaan';

  @override
  String get precision_anti_aging_desc =>
      'Optimalkan kesehatan dan vitalitas seiring bertambahnya usia';

  @override
  String get precision_basic_info_title => 'Info Dasar & Riwayat Kesehatan';

  @override
  String get precision_age_label => 'Usia';

  @override
  String get precision_age_hint => 'Cth 34 tahun';

  @override
  String get precision_age_error => 'Harap masukkan usia Anda';

  @override
  String get precision_age_valid_error => 'Harap masukkan usia yang valid';

  @override
  String get precision_gender_label => 'Jenis Kelamin';

  @override
  String get precision_gender_error => 'Harap pilih jenis kelamin Anda';

  @override
  String get precision_known_condition_label => 'Kondisi Diketahui (Opsional)';

  @override
  String get precision_known_condition_hint =>
      'Tulis riwayat kondisi Anda di sini';

  @override
  String get precision_special_consideration_title =>
      'Pasien dengan Pertimbangan Khusus';

  @override
  String get precision_medication_history_label => 'Riwayat obat & suplemen';

  @override
  String get precision_medication_history_hint =>
      'Cth: Hindari Clopidogrel, Ondansetron, dll';

  @override
  String get precision_family_history_label => 'Riwayat kesehatan keluarga';

  @override
  String get precision_family_history_hint =>
      'Tulis biomarker lain di sini (minimal 10 karakter)';

  @override
  String get precision_family_history_error =>
      'Harap masukkan setidaknya 10 karakter';

  @override
  String get precision_self_rated_health_title => 'Penilaian Kesehatan Mandiri';

  @override
  String get precision_terrible => 'Sangat Buruk';

  @override
  String get precision_bad => 'Buruk';

  @override
  String get precision_neutral => 'Netral';

  @override
  String get precision_good => 'Baik';

  @override
  String get precision_excellent => 'Sangat Baik';

  @override
  String get precision_its_terrible => 'Sangat buruk';

  @override
  String get precision_its_bad => 'Buruk';

  @override
  String get precision_its_good => 'Baik';

  @override
  String get precision_its_very_good => 'Sangat baik';

  @override
  String get precision_lifestyle_habits_title => 'Gaya Hidup & Kebiasaan';

  @override
  String get precision_sleep_hours_question =>
      'Berapa jam Anda tidur per malam?';

  @override
  String precision_hours_per_day(String hours) {
    return '$hours jam per hari';
  }

  @override
  String get precision_activity_level_label =>
      'Jelaskan tingkat aktivitas harian Anda';

  @override
  String get precision_activity_level_hint =>
      'Cth Bekerja di balik meja 8 jam per hari';

  @override
  String get precision_activity_level_error =>
      'Harap jelaskan tingkat aktivitas Anda';

  @override
  String get precision_exercise_frequency_label =>
      'Seberapa sering Anda berolahraga per minggu?';

  @override
  String get precision_exercise_frequency_hint =>
      'Cth: Sekitar 30 menit per hari';

  @override
  String get precision_exercise_frequency_error =>
      'Harap jelaskan frekuensi olahraga Anda';

  @override
  String get precision_stress_level_label => 'Tingkat stres';

  @override
  String get precision_stress_level_hint => 'Cth: Tingkat stres menengah';

  @override
  String get precision_stress_level_error =>
      'Harap jelaskan tingkat stres Anda';

  @override
  String get precision_smoking_alcohol_label =>
      'Kebiasaan merokok atau alkohol?';

  @override
  String get precision_smoking_alcohol_hint => 'Cth: Perokok berat';

  @override
  String get precision_smoking_alcohol_error =>
      'Harap jelaskan kebiasaan merokok/alkohol Anda';

  @override
  String get precision_nutrition_habits_title => 'Kebiasaan Nutrisi';

  @override
  String get precision_meal_frequency_label =>
      'Jelaskan frekuensi makan harian Anda';

  @override
  String get precision_meal_frequency_hint => 'Cth Dua kali sehari';

  @override
  String get precision_meal_frequency_error =>
      'Harap jelaskan frekuensi makan Anda';

  @override
  String get precision_food_sensitivities_label =>
      'Sensitivitas atau alergi makanan yang diketahui';

  @override
  String get precision_food_sensitivities_hint =>
      'Cth: Makanan laut seperti udang';

  @override
  String get precision_food_sensitivities_error =>
      'Harap jelaskan sensitivitas makanan Anda';

  @override
  String get precision_favorite_foods_label => 'Jenis makanan favorit';

  @override
  String get precision_favorite_foods_hint => 'Cth: Ayam, Sup Sehat, Bakso';

  @override
  String get precision_favorite_foods_error =>
      'Harap jelaskan makanan favorit Anda';

  @override
  String get precision_avoided_foods_label => 'Jenis makanan yang dihindari';

  @override
  String get precision_avoided_foods_hint => 'Cth: Makanan laut';

  @override
  String get precision_avoided_foods_error =>
      'Harap jelaskan makanan yang Anda hindari';

  @override
  String get precision_water_intake_label => 'Asupan air';

  @override
  String get precision_water_intake_hint => 'Cth: 7 gelas per hari';

  @override
  String get precision_water_intake_error => 'Harap jelaskan asupan air Anda';

  @override
  String get precision_past_diets_label => 'Diet masa lalu';

  @override
  String get precision_past_diets_hint =>
      'Cth: Keto, rendah karbohidrat, nabati, makanan mentah';

  @override
  String get precision_past_diets_error => 'Harap jelaskan diet masa lalu Anda';

  @override
  String get precision_biomarker_upload_title => 'Unggah Biomarker';

  @override
  String get precision_upload_header =>
      'Unggah rekam medis Anda dan hubungkan perangkat';

  @override
  String get precision_upload_subtitle =>
      'Ini membantu kami membuat rencana nutrisi yang lebih akurat dan personal';

  @override
  String get precision_upload_medical_records => 'Unggah Rekam Medis';

  @override
  String get precision_upload_medical_records_desc =>
      'Unggah PDF, gambar, atau dokumen medis lainnya';

  @override
  String get precision_choose_file => 'Pilih File';

  @override
  String get precision_connect_wearable => 'Hubungkan Perangkat Wearable';

  @override
  String get precision_connect_wearable_desc =>
      'Sinkronkan data dari jam tangan pintar, pelacak kebugaran, atau perangkat lainnya';

  @override
  String get precision_uploaded_files => 'File Terunggah';

  @override
  String get precision_submit_assessment => 'Kirim Penilaian';

  @override
  String get precision_success_title => 'Berhasil!';

  @override
  String get precision_success_content =>
      'Penilaian Nutrisi Presisi Anda telah berhasil dikirim. Para ahli kami akan meninjau informasi Anda dan membuat rencana yang dipersonalisasi untuk Anda.';

  @override
  String get precision_view_details => 'Lihat Detail';

  @override
  String get precision_my_assessment_details => 'Detail Penilaian Nutrisi Saya';

  @override
  String get precision_edit_information => 'Ubah Informasi';

  @override
  String get precision_download_pdf => 'Unduh (PDF)';

  @override
  String get precision_back_to_page => 'Kembali ke Halaman Nutrisi Presisi';

  @override
  String get precision_plan_my_plan => 'Rencana Nutrisi Presisi Saya';

  @override
  String get precision_plan_tab_dietary => 'Rencana Diet';

  @override
  String get precision_plan_tab_supplements => 'Suplemen';

  @override
  String get precision_plan_tab_lifestyle => 'Gaya Hidup';

  @override
  String get precision_plan_request_update => 'Minta Pembaruan Rencana';

  @override
  String get precision_plan_goal => 'TUJUAN';

  @override
  String get precision_plan_strategy => 'STRATEGI';

  @override
  String get precision_plan_daily_calory => 'TARGET KALORI HARIAN';

  @override
  String get precision_plan_recommended_foods =>
      'Makanan yang Direkomendasikan';

  @override
  String get precision_plan_foods_to_limit => 'Makanan untuk Dibatasi';

  @override
  String get precision_plan_weekly_meal_plan => 'Rencana Makan Mingguan';

  @override
  String get precision_plan_view_all => 'Lihat Semua';

  @override
  String get precision_weekly_meal_plan_title => 'Rencana Makan Mingguan';

  @override
  String precision_day_meal_plan(String day) {
    return 'Rencana Makan $day';
  }

  @override
  String get precision_meal_breakfast => 'Sarapan';

  @override
  String get precision_meal_lunch => 'Makan Siang';

  @override
  String get precision_meal_dinner => 'Makan Malam';

  @override
  String get precision_implementation_journey => 'Perjalanan Implementasi';

  @override
  String get precision_implementation_indepth_assessment =>
      'Penilaian Mendalam (2-4 minggu)';

  @override
  String get precision_implementation_intervention => 'Intervensi (3-6 bulan)';

  @override
  String get precision_implementation_maintenance => 'Pemeliharaan';

  @override
  String get precision_sub_health_metabolic => 'Optimalisasi Fungsi Metabolik';

  @override
  String get precision_sub_health_gut_brain => 'Regulasi Poros Usus-Otak';

  @override
  String get precision_sub_health_immune => 'Intervensi Keseimbangan Imun';

  @override
  String get precision_chronic_diabetes => 'Manajemen Diabetes';

  @override
  String get precision_chronic_cardio => 'Dukungan Penyakit Kardiovaskular';

  @override
  String get precision_chronic_autoimmune => 'Perawatan Penyakit Autoimun';

  @override
  String get precision_chronic_obesity => 'Manajemen Obesitas';

  @override
  String get precision_anti_aging_cellular =>
      'Regenerasi Sel & Kesehatan Mitokondria';

  @override
  String get precision_anti_aging_cognitive =>
      'Umur Panjang Kognitif & Neuroproteksi';

  @override
  String get precision_anti_aging_hormonal =>
      'Keseimbangan Hormon & Optimalisasi Vitalitas';

  @override
  String get precision_anti_aging_skin => 'Kesehatan Kulit & Struktur';

  @override
  String get precision_learn_more => 'Pelajari Lebih Lanjut';

  @override
  String get precision_applicable_issues => 'MASALAH YANG BERLAKU';

  @override
  String get precision_services_include => 'LAYANAN TERMASUK';

  @override
  String get precision_interventions_include => 'INTERVENSI TERMASUK';

  @override
  String get precision_solutions_include => 'SOLUSI TERMASUK';

  @override
  String get precision_technologies_used => 'TEKNOLOGI YANG DIGUNAKAN';

  @override
  String get precision_programs_include => 'PROGRAM TERMASUK';

  @override
  String get precision_precision_methods_include => 'METODE PRESISI TERMASUK';

  @override
  String get day_monday => 'Senin';

  @override
  String get day_tuesday => 'Selasa';

  @override
  String get day_wednesday => 'Rabu';

  @override
  String get day_thursday => 'Kamis';

  @override
  String get day_friday => 'Jumat';

  @override
  String get day_saturday => 'Sabtu';

  @override
  String get day_sunday => 'Minggu';

  @override
  String get nutrition_protein => 'Protein';

  @override
  String get nutrition_carbs => 'Karbohidrat';

  @override
  String get nutrition_fat => 'Lemak';

  @override
  String get admin_homecare_service_rates => 'Tarif Layanan';

  @override
  String get admin_homecare_subscription_plans => 'Paket Langganan';

  @override
  String get admin_homecare_update_successful => 'Pembaruan berhasil';

  @override
  String admin_homecare_update_failed(String error) {
    return 'Pembaruan gagal: $error';
  }

  @override
  String get admin_homecare_no_service_rates =>
      'Tidak ada tarif layanan ditemukan.';

  @override
  String get admin_homecare_no_subscription_plans =>
      'Tidak ada paket langganan ditemukan.';

  @override
  String admin_homecare_edit_rate(String name) {
    return 'Ubah Tarif: $name';
  }

  @override
  String get admin_homecare_edit_plan => 'Ubah Paket';

  @override
  String get admin_homecare_price => 'Harga';

  @override
  String get admin_homecare_quota_hours => 'Kuota (Jam)';

  @override
  String get admin_homecare_validity_days => 'Masa Berlaku (Hari)';

  @override
  String get admin_homecare_active => 'Aktif';

  @override
  String get admin_homecare_inactive => 'Tidak Aktif';

  @override
  String get admin_homecare_save_changes => 'Simpan Perubahan';

  @override
  String admin_homecare_plan_details(String price, int quota, int days) {
    return 'Harga: \$$price | Kuota: ${quota}j | Berlaku: ${days}h';
  }
}
