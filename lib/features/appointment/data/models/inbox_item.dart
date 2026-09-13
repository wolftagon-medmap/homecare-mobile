// Provider inbox contract (backend ADR-0006, single-sourced from care-task
// offers as of the CareTask-unify rewrite). Parsing is defensive so one
// malformed item can never crash the whole list.

class InboxAction {
  final String kind; // 'accept' | 'decline' | 'propose_time'
  final bool requiresReason;

  const InboxAction({
    required this.kind,
    required this.requiresReason,
  });

  factory InboxAction.fromJson(Map<String, dynamic> json) => InboxAction(
        kind: json['kind'] as String? ?? '',
        requiresReason: json['requiresReason'] as bool? ?? false,
      );
}

class InboxItemSummary {
  final String? service;

  /// The structured reasons the booking was raised for, resolved to labels by
  /// the server.
  final List<String> issueLabels;
  final String? patientLabel;
  final String? location;
  final String? risk; // 'low' | 'high' | null

  const InboxItemSummary({
    this.service,
    this.issueLabels = const [],
    this.patientLabel,
    this.location,
    this.risk,
  });

  factory InboxItemSummary.fromJson(Map<String, dynamic> json) =>
      InboxItemSummary(
        service: json['service'] as String?,
        issueLabels: _parseLabels(json['issueLabels']),
        patientLabel: json['patientLabel'] as String?,
        location: json['location'] as String?,
        risk: json['risk'] as String?,
      );
}

List<String> _parseLabels(dynamic value) => value is List
    ? value.whereType<String>().toList(growable: false)
    : const <String>[];

class InboxItem {
  final String key;
  final int careTaskId;
  final String title;
  final String serviceLabel;
  final InboxItemSummary summary;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final double? estimatedIncome;
  final DateTime? expiresAt;
  final List<InboxAction> actions;

  const InboxItem({
    required this.key,
    required this.careTaskId,
    required this.title,
    required this.serviceLabel,
    required this.summary,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.estimatedIncome,
    required this.expiresAt,
    required this.actions,
  });

  InboxAction? actionOfKind(String kind) {
    for (final a in actions) {
      if (a.kind == kind) return a;
    }
    return null;
  }

  factory InboxItem.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] is Map<String, dynamic>
        ? InboxItemSummary.fromJson(json['summary'] as Map<String, dynamic>)
        : const InboxItemSummary();
    final actions = (json['actions'] is List)
        ? (json['actions'] as List)
            .whereType<Map<String, dynamic>>()
            .map(InboxAction.fromJson)
            .toList()
        : <InboxAction>[];

    return InboxItem(
      key: json['key'] as String? ?? '',
      careTaskId: (json['careTaskId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Patient',
      serviceLabel: json['serviceLabel'] as String? ?? '',
      summary: summary,
      scheduledStart: _parseDate(json['scheduledStart']),
      scheduledEnd: _parseDate(json['scheduledEnd']),
      estimatedIncome: (json['estimatedIncome'] as num?)?.toDouble(),
      expiresAt: _parseDate(json['expiresAt']),
      actions: actions,
    );
  }

  static DateTime? _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}
