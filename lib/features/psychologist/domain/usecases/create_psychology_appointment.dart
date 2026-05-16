import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/psychologist/domain/repositories/psychologist_appointment_repository.dart';

class CreatePsychologyAppointment {
  final PsychologistAppointmentRepository repository;

  CreatePsychologyAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreatePsychologyAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreatePsychologyAppointmentParams extends Equatable {
  final String type = 'psychology';
  final int providerId;
  final DateTime startDatetime;

  String get summary => 'Psychology Appointment';

  const CreatePsychologyAppointmentParams({
    required this.providerId,
    required this.startDatetime,
  });

  @override
  List<Object?> get props => [type, providerId, startDatetime];
}
