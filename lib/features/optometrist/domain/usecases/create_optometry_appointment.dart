import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/optometrist/domain/repositories/optometrist_appointment_repository.dart';

class CreateOptometryAppointment {
  final OptometristAppointmentRepository repository;

  CreateOptometryAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateOptometryAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateOptometryAppointmentParams extends Equatable {
  final String type = 'optometry';
  final int providerId;
  final DateTime startDatetime;

  String get summary => 'Optometry Appointment';

  const CreateOptometryAppointmentParams({
    required this.providerId,
    required this.startDatetime,
  });

  @override
  List<Object?> get props => [type, providerId, startDatetime];
}
