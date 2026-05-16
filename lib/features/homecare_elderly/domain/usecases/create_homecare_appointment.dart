import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/homecare_elderly/domain/entities/billing_type.dart';
import 'package:m2health/features/homecare_elderly/domain/repositories/homecare_appointment_repository.dart';

class CreateHomecareAppointment {
  final HomecareAppointmentRepository repository;

  CreateHomecareAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateHomecareAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateHomecareAppointmentParams extends Equatable {
  final String type = 'homecare';
  final int providerId;
  final DateTime startDatetime;
  final List<String> tasks;
  final BillingType billingType;

  String get summary => 'Homecare: ${tasks.join(', ')}';

  const CreateHomecareAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.tasks,
    required this.billingType,
  });

  @override
  List<Object?> get props => [type, providerId, startDatetime, tasks, billingType];
}
