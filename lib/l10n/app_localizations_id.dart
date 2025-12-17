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
  String get appointment_title => 'Janji Temu';

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
}
