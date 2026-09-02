// Provider inbox contract (backend ADR-0006): one shape over two disjoint
// sources — v1 pending appointments and v2 care-task offers. Parsing is
// defensive so one malformed item can never crash the whole list.

class InboxAction {
  final String kind; // 'accept' | 'decline' | 'propose_time'
  final String entity; // 'offer' | 'appointment'
  final int entityId; // careTaskId for offers, appointmentId for appointments
  final bool requiresReason;

  const InboxAction({
    required this.kind,
    required this.entity,
    required this.entityId,
    required this.requiresReason,
  });

  factory InboxAction.fromJson(Map<String, dynamic> json) => InboxAction(
        kind: json['kind'] as String? ?? '',
        entity: json['entity'] as String? ?? '',
        entityId: (json['entityId'] as num?)?.toInt() ?? 0,
        requiresReason: json['requiresReason'] as bool? ?? false,
      );
}

class InboxItemSummary {
  final String? service;
  final String? patientLabel;
  final String? location;
  final String? risk; // 'low' | 'high' | null

  const InboxItemSummary(
      {this.service, this.patientLabel, this.location, this.risk});

  factory InboxItemSummary.fromJson(Map<String, dynamic> json) =>
      InboxItemSummary(
        service: json['service'] as String?,
        patientLabel: json['patientLabel'] as String?,
        location: json['location'] as String?,
        risk: json['risk'] as String?,
      );
}

class InboxItem {
  final String origin; // 'v1_appointment' | 'v2_offer'
  final String key;
  final String title;
  final String serviceLabel;
  final InboxItemSummary summary;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final double? estimatedIncome;
  final DateTime? expiresAt;
  final List<InboxAction> actions;

  const InboxItem({
    required this.origin,
    required this.key,
    required this.title,
    required this.serviceLabel,
    required this.summary,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.estimatedIncome,
    required this.expiresAt,
    required this.actions,
  });

  bool get isOffer => origin == 'v2_offer';

  /// The entity a conversation hangs off: the care task for an offer, the
  /// appointment for a v1 row. Read from the actions rather than parsed out of
  /// `key`, so it stays right if the key format ever changes.
  int get summaryEntityId => actions.isEmpty ? 0 : actions.first.entityId;

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
      origin: json['origin'] as String? ?? 'unknown',
      key: json['key'] as String? ?? '',
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
