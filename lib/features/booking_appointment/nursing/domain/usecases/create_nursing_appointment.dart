import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

class CreateNursingAppointment {
  final NursingAppointmentRepository repository;

  CreateNursingAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateNursingAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateNursingAppointmentParams extends Equatable {
  final String type = 'nursing';
  final int providerId;
  final DateTime startDatetime;
  final int? patientProfileId;
  final Address? location;
  final NursingCase nursingCase;

  String get summary => nursingCase.addOnServices.map((e) => e.name).join(', ');

  const CreateNursingAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    this.patientProfileId,
    this.location,
    required this.nursingCase,
  });

  @override
  List<Object?> get props => [
        type,
        providerId,
        startDatetime,
        patientProfileId,
        location,
        nursingCase
      ];
}
