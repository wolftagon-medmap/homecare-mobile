import 'package:m2health/features/etc/pricing/data/models/estimate_model.dart';
import 'package:m2health/features/etc/pricing/domain/entities/estimate_revision.dart';

class EstimateRevisionModel extends EstimateRevision {
  const EstimateRevisionModel({
    required super.id,
    required super.careTaskId,
    required super.professionalId,
    required super.status,
    required super.estimate,
    required super.previousTotal,
    required super.createdAt,
    super.note,
    super.respondedAt,
  });

  factory EstimateRevisionModel.fromJson(Map<String, dynamic> json) {
    return EstimateRevisionModel(
      id: json['id'] as int,
      careTaskId: json['careTaskId'] as int? ?? json['care_task_id'] as int,
      professionalId:
          json['professionalId'] as int? ?? json['professional_id'] as int,
      status: _status(json['status'] as String?),
      estimate: EstimateModel.fromJson({'lines': json['lines']}),
      previousTotal: double.parse(
        (json['previousTotal'] ?? json['previous_total'] ?? 0).toString(),
      ),
      note: json['note'] as String?,
      respondedAt: _date(json['respondedAt'] ?? json['responded_at']),
      createdAt:
          _date(json['createdAt'] ?? json['created_at']) ?? DateTime.now(),
    );
  }

  static EstimateRevisionStatus _status(String? raw) => switch (raw) {
        'approved' => EstimateRevisionStatus.approved,
        'rejected' => EstimateRevisionStatus.rejected,
        'superseded' => EstimateRevisionStatus.superseded,
        _ => EstimateRevisionStatus.proposed,
      };

  static DateTime? _date(dynamic raw) =>
      raw is String ? DateTime.tryParse(raw) : null;
}
