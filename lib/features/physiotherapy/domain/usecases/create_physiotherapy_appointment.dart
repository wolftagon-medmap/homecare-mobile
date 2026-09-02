import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/physiotherapy/domain/repositories/physiotherapy_appointment_repository.dart';

class CreatePhysiotherapyAppointment {
  final PhysiotherapyAppointmentRepository repository;

  CreatePhysiotherapyAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreatePhysiotherapyAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreatePhysiotherapyAppointmentParams extends Equatable {
  final String type = 'physiotherapy';
  final int providerId;
  final DateTime startDatetime;
  final int duration;
  final String physioType;

  String get summary => 'Physiotherapy Session ($duration mins)';

  const CreatePhysiotherapyAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.duration,
    required this.physioType,
  });

  @override
  List<Object?> get props => [type, providerId, startDatetime, duration, physioType];
}
