import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/create_screening_appointment.dart';

abstract class HomeHealthScreeningRepository {
  // ---- Book Screening Appointments ----
  Future<Either<Failure, List<ServiceEntity>>> getScreeningServices();
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateScreeningAppointmentParams params);

  // ---- v2 Provider Screening Actions ----
  // status: request_accepted | sample_collected | report_ready
  Future<Either<Failure, Unit>> updateServiceRequestStatus(
      int appointmentId, String status);

  // ---- Deprecated Provider Screening Actions ----
  @Deprecated('Use updateServiceRequestStatus(appointmentId, "request_accepted"). TODO: delete.')
  Future<Either<Failure, Unit>> acceptScreeningRequest(int screeningRequestId);
  @Deprecated('Use updateServiceRequestStatus(appointmentId, "sample_collected"). TODO: delete.')
  Future<Either<Failure, Unit>> confirmSampleCollected(int screeningRequestId);
  @Deprecated('Use updateServiceRequestStatus(appointmentId, "report_ready"). TODO: delete.')
  Future<Either<Failure, Unit>> markScreeningReportReady(
      int screeningRequestId);
}
