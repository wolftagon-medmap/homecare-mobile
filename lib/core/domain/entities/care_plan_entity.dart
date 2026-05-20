import 'package:equatable/equatable.dart';

class CarePlanEntity extends Equatable {
  final int id;
  // smoking_cessation | nutrition | diabetes_management | weight_loss
  final String type;
  // draft | active | on_hold | completed | cancelled
  final String status;
  final String title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<CarePlanActivity> activities;

  const CarePlanEntity({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.activities = const [],
  });

  @override
  List<Object?> get props =>
      [id, type, status, title, description, startDate, endDate, activities];
}

class CarePlanActivity extends Equatable {
  final int id;
  // medication | advice | follow_up | exercise
  final String type;
  final String description;
  // not_started | in_progress | completed | cancelled
  final String status;
  final DateTime? scheduledDate;
  final Map<String, dynamic>? detail;

  const CarePlanActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    this.scheduledDate,
    this.detail,
  });

  @override
  List<Object?> get props =>
      [id, type, description, status, scheduledDate, detail];
}
