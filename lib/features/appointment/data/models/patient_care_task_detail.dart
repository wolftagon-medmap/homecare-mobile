import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';

/// Pre-acceptance booking detail (backend GET /v2/care-tasks/:id).
class PatientCareTaskDetail {
  final int careTaskId;
  final String status;
  final String statusLabel;
  final String serviceLabel;
  final String? patientName;
  final String? remarks;

  /// The structured reasons the booking was raised for, resolved to labels by
  /// the server. The remark beside them is the patient's own words.
  final List<String> issueLabels;
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
    required this.remarks,
    this.issueLabels = const [],
    required this.preferredDate,
    required this.preferredTime,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.location,
    required this.provider,
    required this.estimatedPrice,
    required this.appointmentId,
  });

  /// Everyone who could be asked is out. Not cancelled: it is waiting on the
  /// patient to change the time or pick someone else.
  bool get isUnmatched => status == 'unmatched';

  factory PatientCareTaskDetail.fromJson(Map<String, dynamic> json) =>
      PatientCareTaskDetail(
        careTaskId: (json['careTaskId'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? '',
        serviceLabel: json['serviceLabel'] as String? ?? '',
        patientName: json['patientName'] as String?,
        remarks: json['remarks'] as String?,
        issueLabels: PatientInboxItem.parseIssueLabels(json['issueLabels']),
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
