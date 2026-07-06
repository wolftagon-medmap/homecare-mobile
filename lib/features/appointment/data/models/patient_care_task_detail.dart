import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';

/// Pre-acceptance booking detail (backend GET /v2/care-tasks/:id).
class PatientCareTaskDetail {
  final int careTaskId;
  final String status;
  final String statusLabel;
  final String serviceLabel;
  final String? patientName;
  final String? chiefComplaint;
  final String? preferredDate;
  final String? preferredTime;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final String? location;
  final PatientInboxProvider? provider; // null → still finding a professional
  final double estimatedPrice;
  final int? appointmentId; // set once accepted — bounce to appointment detail

  const PatientCareTaskDetail({
    required this.careTaskId,
    required this.status,
    required this.statusLabel,
    required this.serviceLabel,
    required this.patientName,
    required this.chiefComplaint,
    required this.preferredDate,
    required this.preferredTime,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.location,
    required this.provider,
    required this.estimatedPrice,
    required this.appointmentId,
  });

  factory PatientCareTaskDetail.fromJson(Map<String, dynamic> json) =>
      PatientCareTaskDetail(
        careTaskId: (json['careTaskId'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? '',
        serviceLabel: json['serviceLabel'] as String? ?? '',
        patientName: json['patientName'] as String?,
        chiefComplaint: json['chiefComplaint'] as String?,
        preferredDate: json['preferredDate'] as String?,
        preferredTime: json['preferredTime'] as String?,
        scheduledStart: _parseDate(json['scheduledStart']),
        scheduledEnd: _parseDate(json['scheduledEnd']),
        location: json['location'] as String?,
        provider: json['provider'] is Map<String, dynamic>
            ? PatientInboxProvider.fromJson(
                json['provider'] as Map<String, dynamic>)
            : null,
        estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble() ?? 0.0,
        appointmentId: (json['appointmentId'] as num?)?.toInt(),
      );

  static DateTime? _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}
