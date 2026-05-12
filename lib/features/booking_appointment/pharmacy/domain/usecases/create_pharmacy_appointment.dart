import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/repositories/pharmacy_appointment_repository.dart';

class CreatePharmacyAppointment {
  final PharmacyAppointmentRepository repository;

  CreatePharmacyAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreatePharmacyAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreatePharmacyAppointmentParams extends Equatable {
  final String type = 'pharmacy';
  final int providerId;
  final DateTime startDatetime;
  final PharmacyCase pharmacyCase;
  // Required for smoking_cessation service type — submit questionnaire first,
  // pass the returned response id here.
  final int? questionnaireResponseId;

  String get summary =>
      pharmacyCase.addOnServices.map((e) => e.name).join(', ');

  const CreatePharmacyAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.pharmacyCase,
    this.questionnaireResponseId,
  });

  @override
  List<Object?> get props => [
        type,
        providerId,
        startDatetime,
        pharmacyCase,
        questionnaireResponseId,
      ];
}
