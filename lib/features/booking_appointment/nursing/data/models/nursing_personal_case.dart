import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/models/personal_issue_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/entities/nursing_case.dart';

class NursingPersonalCaseModel extends NursingCase {
  const NursingPersonalCaseModel({
    super.appointmentId,
    required super.issues,
    super.mobilityStatus,
    super.relatedHealthRecordId,
    required super.addOnServices,
  });

  factory NursingPersonalCaseModel.fromJson(Map<String, dynamic> json) {
    return NursingPersonalCaseModel(
      appointmentId: json['appointment_id'],
      issues: json['personal_issues'] != null
          ? (json['personal_issues'] as List)
              .map((issue) => PersonalIssueModel.fromJson(issue))
              .toList()
          : [],
      mobilityStatus: json['mobility_status'] != null
          ? MobilityStatus.fromApiValue(json['mobility_status'])
          : null,
      relatedHealthRecordId: json['related_health_record_id'],
      addOnServices: json['add_on_services'] != null
          ? (json['add_on_services'] as List)
              .map((s) => ServiceModel.fromJson(s as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
