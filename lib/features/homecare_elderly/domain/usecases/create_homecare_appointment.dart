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
  final String providerType = 'caregiver';
  final int providerId;
  final DateTime startDatetime;
  final List<String> tasks;
  final BillingType billingType;

  String get summary => 'Homecare: ${tasks.join(', ')}';

  // Logic: Hourly ($25/hr * 2 hrs = $50). Subscription = 0.
  // Assuming 2 hours slot as per requirement.
  // Backend recalculates payTotal, so we send 0.0 to satisfy validator.
  double get payTotal => 0.0;

  const CreateHomecareAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.tasks,
    required this.billingType,
  });

  @override
  List<Object?> get props => [
        type,
        providerType,
        providerId,
        startDatetime,
        tasks,
        billingType,
      ];
}
