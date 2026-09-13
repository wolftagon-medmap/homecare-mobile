import 'package:equatable/equatable.dart';
import 'package:m2health/features/patient_health_profile/medical_record/domain/entities/medical_record.dart';

abstract class MedicalRecordEvent extends Equatable {
  const MedicalRecordEvent();

  @override
  List<Object> get props => [];
}

class FetchMedicalRecords extends MedicalRecordEvent {}

class DeleteMedicalRecordEvent extends MedicalRecordEvent {
  final MedicalRecord record;

  const DeleteMedicalRecordEvent(this.record);

  @override
  List<Object> get props => [record];
}
