import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';

class PharmacyCase extends Equatable {
  final int? appointmentId;
  final String serviceType;
  final String? coachingTopic;
  final List<PersonalIssue> issues;
  final MobilityStatus? mobilityStatus;
  final int? relatedHealthRecordId;
  final List<ServiceEntity> addOnServices;

  const PharmacyCase({
    this.appointmentId,
    this.serviceType = 'general_counseling',
    this.coachingTopic,
    this.issues = const [],
    this.mobilityStatus,
    this.relatedHealthRecordId,
    this.addOnServices = const [],
  });

  @override
  List<Object?> get props => [
        appointmentId,
        serviceType,
        coachingTopic,
        issues,
        mobilityStatus,
        relatedHealthRecordId,
        addOnServices,
      ];

  PharmacyCase copyWith({
    int? appointmentId,
    String? serviceType,
    String? coachingTopic,
    List<PersonalIssue>? issues,
    MobilityStatus? mobilityStatus,
    int? relatedHealthRecordId,
    List<ServiceEntity>? addOnServices,
  }) {
    return PharmacyCase(
      appointmentId: appointmentId ?? this.appointmentId,
      serviceType: serviceType ?? this.serviceType,
      coachingTopic: coachingTopic ?? this.coachingTopic,
      issues: issues ?? this.issues,
      mobilityStatus: mobilityStatus ?? this.mobilityStatus,
      relatedHealthRecordId:
          relatedHealthRecordId ?? this.relatedHealthRecordId,
      addOnServices: addOnServices ?? this.addOnServices,
    );
  }
}
