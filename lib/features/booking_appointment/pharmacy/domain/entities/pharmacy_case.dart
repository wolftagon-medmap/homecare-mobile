import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/smoking_cessation/domain/entities/smoking_cessation_form.dart';

class PharmacyCase extends Equatable {
  final int? appointmentId;
  final String serviceType; // general_counseling | smoking_cessation
  final List<PersonalIssue> issues;
  final MobilityStatus? mobilityStatus;
  final int? relatedHealthRecordId;
  final List<AddOnService> addOnServices;
  final SmokingCessationForm? smokingCessationForm;

  const PharmacyCase({
    this.appointmentId,
    this.serviceType = 'general_counseling',
    this.issues = const [],
    this.mobilityStatus,
    this.relatedHealthRecordId,
    this.addOnServices = const [],
    this.smokingCessationForm,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        serviceType,
        issues,
        mobilityStatus,
        relatedHealthRecordId,
        addOnServices,
        smokingCessationForm,
      ];

  PharmacyCase copyWith({
    int? appointmentId,
    String? serviceType,
    List<PersonalIssue>? issues,
    MobilityStatus? mobilityStatus,
    int? relatedHealthRecordId,
    List<AddOnService>? addOnServices,
    SmokingCessationForm? smokingCessationForm,
  }) {
    return PharmacyCase(
      appointmentId: appointmentId ?? this.appointmentId,
      serviceType: serviceType ?? this.serviceType,
      issues: issues ?? this.issues,
      mobilityStatus: mobilityStatus ?? this.mobilityStatus,
      relatedHealthRecordId: relatedHealthRecordId ?? this.relatedHealthRecordId,
      addOnServices: addOnServices ?? this.addOnServices,
      smokingCessationForm: smokingCessationForm ?? this.smokingCessationForm,
    );
  }
}
