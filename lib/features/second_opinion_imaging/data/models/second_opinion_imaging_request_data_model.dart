import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/second_opinion_imaging/domain/entities/second_opinion_imaging_request_data.dart';

class SecondOpinionImagingRequestDataModel
    extends SecondOpinionImagingRequestData {
  const SecondOpinionImagingRequestDataModel({
    required super.id,
    required super.appointmentId,
    required super.serviceType,
    required super.diseaseName,
    super.diseaseHistory,
    super.biomarker,
    super.images = const [],
    super.service,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SecondOpinionImagingRequestDataModel.fromJson(
      Map<String, dynamic> json) {
    return SecondOpinionImagingRequestDataModel(
      id: json['id'],
      appointmentId: json['appointment_id'],
      serviceType: json['service_type'],
      diseaseName: json['disease_name'],
      diseaseHistory: json['disease_history'],
      biomarker: json['biomarker'],
      images: (json['images'] as List? ?? [])
          .map((i) => SecondOpinionImageModel.fromJson(i))
          .toList(),
      service: json['service'] != null ? _parseService(json['service']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static ServiceEntity _parseService(Map<String, dynamic> json) {
    return ServiceEntity(
      id: json['id'],
      name: json['title'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class SecondOpinionImageModel extends SecondOpinionImageEntity {
  const SecondOpinionImageModel({
    required super.id,
    super.imageType,
    required super.fileUrl,
  });

  factory SecondOpinionImageModel.fromJson(Map<String, dynamic> json) {
    return SecondOpinionImageModel(
      id: json['id'],
      imageType: json['image_type'],
      fileUrl: json['file']['url'],
    );
  }
}
