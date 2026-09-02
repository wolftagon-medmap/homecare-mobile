import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';

class CreateScreeningAppointment {
  final HomeHealthScreeningRepository repository;

  CreateScreeningAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateScreeningAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateScreeningAppointmentParams extends Equatable {
  final String type = 'screening';
  final int providerId;
  final DateTime startDatetime;

  final List<ServiceEntity> selectedServices;

  String get summary =>
      'Home Health Screening: ${selectedServices.map((e) => e.name).join(', ')}';

  const CreateScreeningAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.selectedServices,
  });

  @override
  List<Object?> get props => [providerId, startDatetime, selectedServices];
}