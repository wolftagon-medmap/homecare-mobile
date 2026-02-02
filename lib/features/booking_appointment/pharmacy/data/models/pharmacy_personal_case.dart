import 'dart:developer';

import 'package:m2health/features/booking_appointment/add_on_services/data/model/add_on_service_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/models/personal_issue_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/pharmacy/data/models/smoking_cessation_form_model.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';

class PharmacyPersonalCaseModel extends PharmacyCase {
  const PharmacyPersonalCaseModel({
    super.appointmentId,
    super.issues,
    super.serviceType,
    super.mobilityStatus,
    super.relatedHealthRecordId,
    super.addOnServices,
    super.smokingCessationForm,
  });

  factory PharmacyPersonalCaseModel.fromJson(Map<String, dynamic> json) {
    return PharmacyPersonalCaseModel(
      appointmentId: json['appointment_id'],
      serviceType: json['service_type'],
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
              .map((addon) => AddOnServiceModel.fromJson(addon))
              .toList()
          : [],
      smokingCessationForm: json['smoking_cessation_form'] != null
          ? SmokingCessationFormModel.fromJson(json['smoking_cessation_form'])
          : null,
    );
  }
}
