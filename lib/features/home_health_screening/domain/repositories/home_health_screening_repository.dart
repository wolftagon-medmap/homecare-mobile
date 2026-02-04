import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/create_screening_appointment.dart';

abstract class HomeHealthScreeningRepository {
  // ---- Book Screening Appointments ----
  Future<Either<Failure, List<ScreeningCategory>>> getScreeningServices();
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateScreeningAppointmentParams params);

  // ---- Actions for Practitioners ----
  Future<Either<Failure, Unit>> acceptScreeningRequest(int screeningRequestId);
  Future<Either<Failure, Unit>> confirmSampleCollected(int screeningRequestId);
  Future<Either<Failure, Unit>> markScreeningReportReady(
      int screeningRequestId);
}
