import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/physiotherapy/domain/entities/physiotherapy_request_data.dart';

class PhysiotherapyRequestDataModel extends PhysiotherapyRequestData {
  const PhysiotherapyRequestDataModel({
    required super.id,
    required super.appointmentId,
    required super.duration,
    required super.service,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PhysiotherapyRequestDataModel.fromJson(Map<String, dynamic> json) {
    return PhysiotherapyRequestDataModel(
      id: json['id'],
      appointmentId: json['appointment_id'],
      duration: json['duration'],
      service: _parseService(json['service']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static ServiceEntity _parseService(Map<String, dynamic> json) {
    return ServiceEntity(
      id: json['id'],
      name: json['title'], // Mapping title to name
      price: (json['price'] as num).toDouble(),
    );
  }
}
