// Patient pending-inbox contract (backend GET /v2/patient/inbox), single-sourced
// from pre-acceptance care tasks as of the CareTask-unify rewrite. Parsing is
// defensive so one malformed item can never crash the whole list.

class PatientInboxProvider {
  final int id;
  final String name;
  final String? avatar;
  final String? jobTitle;

  const PatientInboxProvider({
    required this.id,
    required this.name,
    this.avatar,
    this.jobTitle,
  });

  factory PatientInboxProvider.fromJson(Map<String, dynamic> json) =>
      PatientInboxProvider(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? 'Professional',
        avatar: json['avatar'] as String?,
        jobTitle: json['jobTitle'] as String?,
      );
}

class PatientInboxItem {
  final String key;
  final int careTaskId;
  final String? patientName;
  final String serviceLabel;

  /// When the patient asked. The inbox is ordered on this, newest first.
  final DateTime? createdAt;
  final String status; // raw source status (chip color)

  final String statusLabel; // display text
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final PatientInboxProvider? provider; // null → still finding a professional
  final double? estimatedPrice;
  final String? remarks;

  /// The structured reasons the booking was raised for, resolved to labels by
  /// the server. The remark beside them is the patient's own words.
  final List<String> issueLabels;

  const PatientInboxItem({
    required this.key,
    required this.careTaskId,
    required this.patientName,
    required this.serviceLabel,
    this.createdAt,
    required this.status,
    required this.statusLabel,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.provider,
    required this.estimatedPrice,
    required this.remarks,
    this.issueLabels = const [],
  });

  /// Everyone available was asked and nobody took it. Not cancelled — it is
  /// still the patient's booking, waiting on them to pick another time.
  bool get isUnmatched => status == 'unmatched';

  factory PatientInboxItem.fromJson(Map<String, dynamic> json) =>
      PatientInboxItem(
        key: json['key'] as String? ?? '',
        careTaskId: (json['careTaskId'] as num?)?.toInt() ?? 0,
        patientName: json['patientName'] as String?,
        serviceLabel: json['serviceLabel'] as String? ?? '',
        createdAt: _parseDate(json['createdAt']),
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? '',
        scheduledStart: _parseDate(json['scheduledStart']),
        scheduledEnd: _parseDate(json['scheduledEnd']),
        provider: json['provider'] is Map<String, dynamic>
            ? PatientInboxProvider.fromJson(
                json['provider'] as Map<String, dynamic>)
            : null,
        estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
        remarks: json['remarks'] as String?,
        issueLabels: parseIssueLabels(json['issueLabels']),
      );

  static List<String> parseIssueLabels(dynamic value) => value is List
      ? value.whereType<String>().toList(growable: false)
      : const <String>[];

  static DateTime? _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}
