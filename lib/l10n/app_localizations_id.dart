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
  String get nursing_service => 'Perawat ke Rumah';

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
  String get appointment_detail_patient_problem_title => 'Masalah Pasien';

  @override
  String get appointment_detail_patient_problem_empty =>
      'Tidak ada detail masalah khusus yang diberikan.';

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
}
