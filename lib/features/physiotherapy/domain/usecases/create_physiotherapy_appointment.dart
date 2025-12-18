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
  final String providerType = 'physiotherapist';
  final int providerId;
  final DateTime startDatetime;
  final int duration;
  final String serviceCode;

  double get payTotal {
     // Pricing logic based on service code provided in instructions
     if (serviceCode.contains('45_minutes')) return 25.00;
     if (serviceCode.contains('60_minutes')) return 30.00;
     return 0.0;
  }
  
  String get summary => 'Physiotherapy Session ($duration mins)';

  const CreatePhysiotherapyAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.duration,
    required this.serviceCode,
  });

  @override
  List<Object?> get props => [
        type,
        providerType,
        providerId,
        startDatetime,
        duration,
        serviceCode,
      ];
}
