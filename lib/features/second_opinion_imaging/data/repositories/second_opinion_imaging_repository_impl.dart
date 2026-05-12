import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/second_opinion_imaging/data/datasources/second_opinion_imaging_remote_datasource.dart';
import 'package:m2health/features/second_opinion_imaging/domain/repositories/second_opinion_imaging_repository.dart';

class SecondOpinionImagingRepositoryImpl extends SecondOpinionImagingRepository {
  final AppointmentService appointmentService;
  final SecondOpinionImagingRemoteDataSource remoteDataSource;

  SecondOpinionImagingRepositoryImpl({
    required this.appointmentService,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateSecondOpinionImagingAppointmentParams params) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('type', params.type));
      formData.fields.add(MapEntry('provider_id', params.providerId.toString()));
      formData.fields.add(MapEntry('start_datetime', params.startDatetime.toIso8601String()));
      formData.fields.add(MapEntry('summary', params.summary));

      formData.fields.add(MapEntry('request_data[service_type]', params.serviceType));
      formData.fields.add(MapEntry('request_data[disease_name]', params.diseaseName));
      if (params.diseaseHistory != null) {
        formData.fields.add(MapEntry('request_data[disease_history]', params.diseaseHistory!));
      }
      if (params.biomarker != null) {
        formData.fields.add(MapEntry('request_data[biomarker]', params.biomarker!));
      }

      for (int i = 0; i < params.images.length; i++) {
        final img = params.images[i];
        if (img.imageType != null) {
          formData.fields.add(MapEntry('request_data[images][$i][image_type]', img.imageType!));
        }
        formData.files.add(MapEntry(
          'request_data[images][$i][file]',
          await MultipartFile.fromFile(img.file.path),
        ));
      }

      final response = await appointmentService.createAppointmentMultipart(formData);
      final result = AppointmentModel.fromJson(
          response['appointment'] as Map<String, dynamic>);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createDiagnosticReport({
    required int appointmentId,
    required String conclusion,
    String? recommendation,
    int? fileUploadId,
  }) async {
    try {
      await appointmentService.createDiagnosticReport(
        appointmentId,
        conclusion: conclusion,
        recommendation: recommendation,
        fileUploadId: fileUploadId,
      );
      return const Right(unit);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @Deprecated(
      'Use createDiagnosticReport(appointmentId, conclusion, recommendation). TODO: delete.')
  Future<Either<Failure, Unit>> submitFeedback({
    required int appointmentId,
    required String diagnosticOpinion,
    required String recommendationOpinion,
  }) async {
    try {
      await remoteDataSource.submitFeedback(
        appointmentId: appointmentId,
        diagnosticOpinion: diagnosticOpinion,
        recommendationOpinion: recommendationOpinion,
      );
      return const Right(unit);
    } on Failure catch (failure) {
      return Left(failure);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
