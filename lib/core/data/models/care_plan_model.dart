import 'package:m2health/core/domain/entities/care_plan_entity.dart';

class CarePlanModel extends CarePlanEntity {
  const CarePlanModel({
    required super.id,
    required super.type,
    required super.status,
    required super.title,
    super.description,
    super.startDate,
    super.endDate,
    super.activities,
  });

  factory CarePlanModel.fromJson(Map<String, dynamic> json) {
    final activities = (json['activities'] as List? ?? [])
        .map((e) =>
            CarePlanActivityModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return CarePlanModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      status: json['status'] as String? ?? 'draft',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      activities: activities,
    );
  }
}

class CarePlanActivityModel extends CarePlanActivity {
  const CarePlanActivityModel({
    required super.id,
    required super.type,
    required super.description,
    required super.status,
    super.scheduledDate,
    super.detail,
  });

  factory CarePlanActivityModel.fromJson(Map<String, dynamic> json) {
    return CarePlanActivityModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'not_started',
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.tryParse(json['scheduled_date'] as String)
          : null,
      detail: json['detail'] as Map<String, dynamic>?,
    );
  }
}
