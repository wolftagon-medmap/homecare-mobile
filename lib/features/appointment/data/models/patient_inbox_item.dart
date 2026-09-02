// Patient pending-inbox contract (backend GET /v2/patient/inbox): one shape
// over two disjoint sources — v1 pending appointments and v2 pre-acceptance
// care tasks. Parsing is defensive so one malformed item can never crash the
// whole list.

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

/// A professional's alternative slot, when one is awaiting this patient.
/// Absent on every other item, so the card is unchanged wherever there is none.
class PatientInboxProposal {
  final int proposalId;
  final DateTime? proposedStart;
  final DateTime? proposedEnd;
  final DateTime? expiresAt;
  final String? reason;

  const PatientInboxProposal({
    required this.proposalId,
    required this.proposedStart,
    required this.proposedEnd,
    required this.expiresAt,
    required this.reason,
  });

  factory PatientInboxProposal.fromJson(Map<String, dynamic> json) =>
      PatientInboxProposal(
        proposalId: (json['proposalId'] as num?)?.toInt() ?? 0,
        proposedStart: _parseDate(json['proposedStart']),
        proposedEnd: _parseDate(json['proposedEnd']),
        expiresAt: _parseDate(json['expiresAt']),
        reason: json['reason'] as String?,
      );

  static DateTime? _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}

class PatientInboxItem {
  final String origin; // 'appointment' | 'care_task'
  final String key;
  final int? appointmentId;
  final int? careTaskId;
  final String? patientName;
  final String serviceLabel;
  final String status; // raw source status (chip color)
  final String statusLabel; // display text
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final PatientInboxProvider? provider; // null → still finding a professional
  final double? estimatedPrice;
  final String? chiefComplaint;
  final PatientInboxProposal? proposal;

  const PatientInboxItem({
    required this.origin,
    required this.key,
    required this.appointmentId,
    required this.careTaskId,
    required this.patientName,
    required this.serviceLabel,
    required this.status,
    required this.statusLabel,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.provider,
    required this.estimatedPrice,
    required this.chiefComplaint,
    this.proposal,
  });

  bool get isCareTask => origin == 'care_task';

  /// The professional has offered a different time and is waiting on an answer.
  bool get hasTimeProposal => proposal != null && status == 'time_proposed';

  factory PatientInboxItem.fromJson(Map<String, dynamic> json) =>
      PatientInboxItem(
        origin: json['origin'] as String? ?? 'unknown',
        key: json['key'] as String? ?? '',
        appointmentId: (json['appointmentId'] as num?)?.toInt(),
        careTaskId: (json['careTaskId'] as num?)?.toInt(),
        patientName: json['patientName'] as String?,
        serviceLabel: json['serviceLabel'] as String? ?? '',
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? '',
        scheduledStart: _parseDate(json['scheduledStart']),
        scheduledEnd: _parseDate(json['scheduledEnd']),
        provider: json['provider'] is Map<String, dynamic>
            ? PatientInboxProvider.fromJson(
                json['provider'] as Map<String, dynamic>)
            : null,
        estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
        chiefComplaint: json['chiefComplaint'] as String?,
        proposal: json['proposal'] is Map<String, dynamic>
            ? PatientInboxProposal.fromJson(
                json['proposal'] as Map<String, dynamic>)
            : null,
      );

  static DateTime? _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}
