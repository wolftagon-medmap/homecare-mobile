import 'package:dartz/dartz.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/home_health_screening/data/datasources/home_health_screening_remote_datasource.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/create_screening_appointment.dart';

class HomeHealthScreeningRepositoryImpl
    implements HomeHealthScreeningRepository {
  final HomeHealthScreeningRemoteDatasource remoteDatasource;
  final AppointmentService appointmentService;

  HomeHealthScreeningRepositoryImpl({
    required this.remoteDatasource,
    required this.appointmentService,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> getScreeningServices() async {
    try {
      final result = await remoteDatasource.getScreeningServicesV2();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateScreeningAppointmentParams params) async {
    try {
      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': params.summary,
        'request_data': {
          'service_ids': params.selectedServices.map((e) => e.id).toList(),
        },
      };

      final response = await appointmentService.createAppointment(payload);
      final result = AppointmentModel.fromJson({
        ...response['appointment'] as Map<String, dynamic>,
        if (response['order'] != null) 'order': response['order'],
      });
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---- v2 Provider Screening Actions (use appointmentId) ----

  @override
  Future<Either<Failure, Unit>> updateServiceRequestStatus(
      int appointmentId, String status) async {
    try {
      await remoteDatasource.updateServiceRequestStatus(appointmentId, status);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---- Deprecated Provider Screening Actions ----

  @override
  @Deprecated(
      'Use updateServiceRequestStatus(appointmentId, "request_accepted"). TODO: delete.')
  Future<Either<Failure, Unit>> acceptScreeningRequest(
      int screeningRequestId) async {
    try {
      // ignore: deprecated_member_use
      await remoteDatasource.acceptScreeningRequest(screeningRequestId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @Deprecated(
      'Use updateServiceRequestStatus(appointmentId, "sample_collected"). TODO: delete.')
  Future<Either<Failure, Unit>> confirmSampleCollected(
      int screeningRequestId) async {
    try {
      // ignore: deprecated_member_use
      await remoteDatasource.confirmSampleCollected(screeningRequestId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @Deprecated(
      'Use updateServiceRequestStatus(appointmentId, "report_ready"). TODO: delete.')
  Future<Either<Failure, Unit>> markScreeningReportReady(
      int screeningRequestId) async {
    try {
      // ignore: deprecated_member_use
      await remoteDatasource.markScreeningReportReady(screeningRequestId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
