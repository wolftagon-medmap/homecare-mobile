import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';

abstract class SecondOpinionImagingRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateSecondOpinionImagingAppointmentParams params);

  Future<Either<Failure, Unit>> submitFeedback({
    required int appointmentId,
    required String diagnosticOpinion,
    required String recommendationOpinion,
  });
}

class CreateSecondOpinionImagingAppointmentParams extends Equatable {
  final String type = 'second_opinion_imaging';
  final String providerType = 'radiologist'; // For teleradiology
  final int providerId;
  final DateTime startDatetime;
  final String serviceType;
  final String diseaseName;
  final String? diseaseHistory;
  final String? biomarker;
  final List<SecondOpinionImageFile> images;

  double get payTotal => 50.0; // Placeholder price

  String get summary => 'Second Opinion of $serviceType analysis ($diseaseName)';

  const CreateSecondOpinionImagingAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.serviceType,
    required this.diseaseName,
    this.diseaseHistory,
    this.biomarker,
    this.images = const [],
  });

  @override
  List<Object?> get props => [
        type,
        providerType,
        providerId,
        startDatetime,
        serviceType,
        diseaseName,
        diseaseHistory,
        biomarker,
        images,
      ];
}

class SecondOpinionImageFile extends Equatable {
  final File file;
  final String? imageType;

  const SecondOpinionImageFile({
    required this.file,
    this.imageType,
  });

  @override
  List<Object?> get props => [file, imageType];
}

