import '../../domain/entities/estimate_revision.dart';

/// Mirrors `EstimateRevisionPayload`. Amounts arrive already calculated by the
/// pricing module; nothing here recomputes or re-sums them.
class EstimateRevisionModel {
  final int revisionId;
  final int careTaskId;
  final String status;
  final String currency;
  final double currentTotal;
  final double proposedTotal;
  final List<Map<String, dynamic>> lines;
  final String? note;

  const EstimateRevisionModel({
    required this.revisionId,
    required this.careTaskId,
    required this.status,
    required this.currency,
    required this.currentTotal,
    required this.proposedTotal,
    required this.lines,
    required this.note,
  });

  factory EstimateRevisionModel.fromJson(Map<String, dynamic> json) =>
      EstimateRevisionModel(
        revisionId: (json['revisionId'] as num?)?.toInt() ?? 0,
        careTaskId: (json['careTaskId'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? 'pending',
        currency: json['currency'] as String? ?? r'$',
        currentTotal: (json['currentTotal'] as num?)?.toDouble() ?? 0,
        proposedTotal: (json['proposedTotal'] as num?)?.toDouble() ?? 0,
        lines: (json['lines'] is List)
            ? (json['lines'] as List)
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
            : const [],
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'revisionId': revisionId,
        'careTaskId': careTaskId,
        'status': status,
        'currency': currency,
        'currentTotal': currentTotal,
        'proposedTotal': proposedTotal,
        'lines': lines,
        'note': note,
      };

  EstimateRevision toEntity() => EstimateRevision(
        revisionId: revisionId,
        careTaskId: careTaskId,
        status: switch (status) {
          'approved' => EstimateRevisionStatus.approved,
          'withdrawn' => EstimateRevisionStatus.withdrawn,
          _ => EstimateRevisionStatus.pending,
        },
        currency: currency,
        currentTotal: currentTotal,
        proposedTotal: proposedTotal,
        lines: lines.map(_lineFrom).toList(),
        note: note,
      );

  static EstimateLine _lineFrom(Map<String, dynamic> json) => EstimateLine(
        code: json['code'] as String? ?? '',
        label: json['label'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        change: switch (json['change'] as String?) {
          'added' => EstimateLineChange.added,
          'removed' => EstimateLineChange.removed,
          _ => EstimateLineChange.unchanged,
        },
      );
}
