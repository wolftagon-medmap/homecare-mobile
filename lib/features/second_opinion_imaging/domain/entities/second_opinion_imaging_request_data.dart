import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';

class SecondOpinionImagingRequestData extends Equatable {
  final int id;
  final int appointmentId;
  final String serviceType;
  final String diseaseName;
  final String? diseaseHistory;
  final String? biomarker;
  final List<SecondOpinionImageEntity> images;
  final ServiceEntity? service; // ???
  final DateTime createdAt;
  final DateTime updatedAt;

  const SecondOpinionImagingRequestData({
    required this.id,
    required this.appointmentId,
    required this.serviceType,
    required this.diseaseName,
    this.diseaseHistory,
    this.biomarker,
    this.images = const [],
    this.service,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        appointmentId,
        serviceType,
        diseaseName,
        diseaseHistory,
        biomarker,
        images,
        service,
        createdAt,
        updatedAt,
      ];
}

class SecondOpinionImageEntity extends Equatable {
  final int id;
  final String? imageType;
  final String fileUrl;

  const SecondOpinionImageEntity({
    required this.id,
    this.imageType,
    required this.fileUrl,
  });

  @override
  List<Object?> get props => [id, imageType, fileUrl];
}
