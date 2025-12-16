import 'package:m2health/features/homecare_elderly/domain/entities/homecare_request_data.dart';

class HomecareRequestDataModel extends HomecareRequestData {
  const HomecareRequestDataModel({
    required super.id,
    required super.appointmentId,
    required super.billingType,
    required super.services,
  });

  factory HomecareRequestDataModel.fromJson(Map<String, dynamic> json) {
    return HomecareRequestDataModel(
      id: json['id'] ?? 0,
      appointmentId: json['appointment_id'] ?? 0,
      billingType: json['billing_type'],
      services:
          (json['services'] as List? ?? []).map((e) => e as String).toList(),
    );
  }
}
