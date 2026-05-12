import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';

class AddOnServiceModel extends AddOnService {
  const AddOnServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.serviceType,
    super.subCategory,
    super.pricingModel,
    super.durationMinutes,
    super.code,
    super.isPublished,
  });

  factory AddOnServiceModel.fromJson(Map<String, dynamic> json) {
    return AddOnServiceModel(
      id: json['id'] as int,
      // v2 uses 'name'; legacy used 'title'
      name: (json['name'] ?? json['title']) as String? ?? '',
      price: double.parse((json['price'] ?? 0).toString()),
      // v2 uses 'category'; legacy used 'service_type'
      serviceType: (json['category'] ?? json['service_type'] ?? '') as String,
      subCategory: json['sub_category'] as String?,
      pricingModel: json['pricing_model'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      code: json['code'] as String?,
      isPublished: json['is_published'] as bool?,
    );
  }
}
